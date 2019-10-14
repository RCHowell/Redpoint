const path = require('path');
const sqlite3 = require('sqlite3').verbose();

// Get location of db
const dbFilename = path.join(__dirname, '../sqlite', 'database.db');

const db = new sqlite3.Database(dbFilename, sqlite3.OPEN_READWRITE, (err) => {
  if (err) console.log(err);
  else console.log('Database open');
});

function gradeInt(grade) {
  let result = 999999;
  if (grade.startsWith('V')) {
    result = parseInt(/[0-9]+/.exec(grade)[0], 10) + 1000;
  } else {
    result = parseInt(grade.match(/[0-9]+/g)[1], 10) * 10;
    if (/a/.test(grade)) result += 2;
    if (/b/.test(grade)) result += 4;
    if (/c/.test(grade)) result += 6;
    if (/d/.test(grade)) result += 8;
    if (/-/.test(grade)) result -= 1;
    if (/\+/.test(grade)) result += 1;
  }
  return result;
}

db.serialize(() => {
  db.all('SELECT route_id, name, grade FROM routes', (err, routes) => {
    if (err) console.log(err);
    else {
      db.run('BEGIN TRANSACTION');
      routes.forEach((route) => {
        db.run('UPDATE routes SET grade_int = $grade_int WHERE route_id = $id', {
          $id: route.route_id,
          $grade_int: gradeInt(route.grade),
        });
      });
      db.run('END');
      db.close(() => console.log('DB closed'));
    }
  });
});
