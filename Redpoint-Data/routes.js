// Script to retrieve route data from scraped graph

const path = require('path');
const fs = require('fs');
const Route = require('./lib/route');
const sqlite3 = require('sqlite3').verbose();

// Number of routes to scrape in parallel
const N = 50;

// Get location of db
const dbFilename = path.join(__dirname, 'sqlite', 'database.db');
// console.log(`Database file: ${dbFilename}`);

// Load routes table schema from file
const routesTableSchemaFile = path.join(__dirname, 'sqlite', 'routes.sql');
const routesTableSchema = fs.readFileSync(routesTableSchemaFile, {
  encoding: 'utf-8',
});

const db = new sqlite3.Database(dbFilename, sqlite3.OPEN_READWRITE, (err) => {
  if (err) console.log(err);
});

// Given N routes, scrape N in parallel
function getRoutes(routePages) {
  return new Promise((resolve, reject) => {
    const runners = [];
    routePages.forEach((routePage) => {
      const route = new Route(routePage);
      runners.push(route.get().catch((err) => {
        console.log(`Error for route: ${routePage}`, err);
      }));
    });
    Promise.all(runners).then((routesData) => {
      resolve(routesData);
    }).catch((err) => {
      console.log(err);
      reject(err);
    });
  });
}

function insert(route) {
  // console.log(`Inserting ${route.route_id}: ${route.name}, ${route.url}`);
  db.run(`
    INSERT INTO routes (route_id, name, url, type, length, grade, stars, description, location, protection, needs_permit, permit_info, number, grade_int)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `, [
      route.route_id,
      route.name,
      route.url,
      route.type,
      route.length,
      route.grade,
      route.stars,
      route.description,
      route.location,
      route.protection,
      route.needs_permit,
      route.permit_info,
      route.number,
      route.grade_int,
    ], (err) => {
      if (err) {
        console.log(err);
        console.log(`Error inserting for ${route}`);
      }
    });
}

db.serialize(() => {
  db.run('DROP TABLE IF EXISTS routes');
  db.run(routesTableSchema);
  const tasks = [];
  db.all('SELECT * FROM pages WHERE is_route = 1', (err, routes) => {
    if (err) {
      console.error(err);
      process.exit(1);
    }
    const l = routes.length;
    // Slice array in chunks of N routes
    for (let i = 0; i < l; i += N) {
      const chunk = routes.slice(i, i + N);
      console.log(`Running chunk ${i}-${i + N}`);
      tasks.push(() => getRoutes(chunk));
    }
  });

  db.run('ANALYZE pages', () => {
    // Serialize promises which are scraping each chunk of routes
    const task = tasks.reduce((m, p) => m.then(v => Promise.all([...v, p()])), Promise.resolve([]));
    task.then((data) => {
      // reduce data from matrix to list
      const flattened = data.reduce((acc, cur) => acc.concat(cur), []);
      db.serialize(() => {
        db.run('BEGIN TRANSACTION');
        console.log('Inserting to database');
        flattened.forEach(insert);
        db.run('END');
      });
    });
  });
});
