// DEPRECATED. NO LONGER UP TO DATE.

const fs = require('fs');
const path = require('path');
const csvjson = require('csvjson');
const sqlite3 = require('sqlite3').verbose();

const relationsFile = fs.readFileSync(path.join(__dirname, '../data', 'route_numbers.tsv'), { encoding: 'utf8' });
const options = {
  delimiter: '\t',
  quote: '"',
};
const relations = csvjson.toArray(relationsFile, options);
const { length } = relations;

// Get location of db
const dbFilename = path.join(__dirname, '../sqlite', 'relations.db');

const db = new sqlite3.Database(dbFilename, sqlite3.OPEN_READWRITE, (err) => {
  if (err) console.log(err);
  // else console.log('Database open');
});

db.serialize(() => {
  db.run('BEGIN TRANSACTION');
  for (let i = 0; i < length; i += 1) {
    const id = Number.parseInt(relations[i][0], 10);
    const number = Number.parseInt(relations[i][1], 10);
    db.run('UPDATE routes SET number = ? WHERE route_id = ?', number, id);
  }
  db.run('END');
});
