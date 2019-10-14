const request = require('sync-request');
const cheerio = require('cheerio');
const fs = require('fs');
const path = require('path');
const sqlite3 = require('sqlite3').verbose();
const Area = require('./lib/area');

const routeNumbers = fs.createWriteStream('../data/route_numbers.tsv');

// Get location of db
const dbFilename = path.join(__dirname, 'sqlite', 'database.db');

const db = new sqlite3.Database(dbFilename, sqlite3.OPEN_READWRITE, (err) => {
  if (err) console.log(err);
  // else console.log('Database open');
});

function writeToTSV(route) {
  routeNumbers.write(`${route.id}\t${route.number}\n`);
}

function getRoutesQuery(id) {
  return `
    SELECT routes.url, routes.route_id FROM routes
    INNER JOIN relationships
    ON relationships.child_id = routes.route_id
    WHERE relationships.parent_id = ${id}
  `;
}

// Take in a list of routes with the route number and join with the route_id
function join(routesWithNumber, routesWithId) {
  const out = [];
  const idMap = new Map();
  for (let i = 0; i < routesWithId.length; i += 1) {
    const route = routesWithId[i];
    idMap.set(route.url, route.route_id);
  }
  for (let i = 0; i < routesWithNumber.length; i += 1) {
    const route = routesWithNumber[i];
    const node = {
      url: route.url,
      id: idMap.get(route.url),
      number: Number.parseInt(route.routeNumber, 10),
    };
    if (typeof node.id !== 'undefined') out.push(node);
  }
  return out;
}

db.serialize(() => {
  db.each('SELECT * FROM pages WHERE is_route = 0', (err, page) => {
    if (err) console.error(err);
    db.all(getRoutesQuery(page.page_id), (routesError, routes) => {
      if (routesError) console.errora(err);
      if (routes.length > 0) {
        const area = new Area(page.url);
        area.get().then((data) => {
          // console.log(join(data.children, routes));
          join(data.children, routes).forEach((element) => {
            writeToTSV(element);
          });
        });
      }
    });
  });
});
