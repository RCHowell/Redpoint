// Script to retrieve area data from scraped graph

const path = require('path');
const fs = require('fs');
const Area = require('./lib/area');
const sqlite3 = require('sqlite3').verbose();

// Number of routes to scrape in parallel
const N = 50;

// Get location of db
const dbFilename = path.join(__dirname, 'sqlite', 'database.db');
// console.log(`Database file: ${dbFilename}`);

// Load area table schema from file
const areasTableSchemaFile = path.join(__dirname, 'sqlite', 'areas.sql');
const areasTableSchema = fs.readFileSync(areasTableSchemaFile, {
  encoding: 'utf-8',
});

const db = new sqlite3.Database(dbFilename, sqlite3.OPEN_READWRITE, (err) => {
  if (err) console.log(err);
});

// Given N areas, scrape N in parallel
function getAreas(areaPages) {
  return new Promise((resolve, reject) => {
    const runners = [];
    areaPages.forEach((areaPage) => {
      const area = new Area(areaPage);
      runners.push(area.get().catch((err) => {
        console.log(`Error for route: ${areaPage}`);
        console.error(err);
      }));
    });
    Promise.all(runners).then((areasData) => {
      resolve(areasData);
    }).catch((err) => {
      console.log(err);
      reject(err);
    });
  });
}

// function insert(area) {
//   // console.log(`Inserting ${route.route_id}: ${route.name}, ${route.url}`);
//   db.run(`
//     INSERT INTO routes (route_id, name, url, type, length, grade, stars, description, location, protection, needsPermit, permitInfo, number)
//     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
//   `, [
//       route.route_id,
//       route.name,
//       route.url,
//       route.type,
//       route.length,
//       route.grade,
//       route.stars,
//       route.description,
//       route.location,
//       route.protection,
//       route.needsPermit,
//       route.permitInfo,
//       route.number,
//     ], (err) => {
//       if (err) {
//         console.log(err);
//         console.log(`Error inserting for ${route}`);
//       }
//     });
// }

db.serialize(() => {
  db.run('DROP TABLE IF EXISTS areas');
  // db.run(areasTableSchema);
  const tasks = [];
  db.all('SELECT * FROM pages WHERE is_route = 0', (err, areas) => {
    if (err) {
      console.error(err);
      process.exit(1);
    }
    const l = areas.length;
    // Slice array in chunks of N routes
    for (let i = 0; i < l; i += N) {
      const chunk = areas.slice(i, i + N);
      console.log(`Running chunk ${i}-${i + N}`);
      tasks.push(() => getAreas(chunk));
    }
  });

  db.run('ANALYZE pages', () => {
    // Serialize promises which are scraping each chunk of routes
    const task = tasks.reduce((m, p) => m.then(v => Promise.all([...v, p()])), Promise.resolve([]));
    task.then((data) => {
      // reduce data from matrix to list
      const flattened = data.reduce((acc, cur) => acc.concat(cur), []);
      flattened.forEach(console.log);
      // db.serialize(() => {
      //   db.run('BEGIN TRANSACTION');
      //   console.log('Inserting to database');
      //   flattened.forEach(insert);
      //   db.run('END');
      // });
    });
  });
});
