const routes = require('../datasets/routes.json');
const grades = require('../datasets/grades.json');
const url = require('url');
const escape = require('sql-escape');

const getGradeInt = (grade) => {
  const gradeInt = grades[grade];
  return (!gradeInt) ? 9999 : gradeInt;
};

const getGrade = (grade) => {
  const g = grades[grade];
  return (!g) ? 'Unknown' : grade;
};

const toInt = (len) => {
  const a = parseInt(len, 10);
  return (isNaN(a)) ? 0 : a;
};

const clean = text => text
  .replace(/\r?\n|\t+|\n+/g, '')
  .replace('"', "''")
  .trim();

const fixStars = stars => (stars === null) ? 0 : stars;

const imagesStr = images => images
  .map((img) => {
    // const myUrl = url.parse(img);
    // let params = myUrl.search;
    // params = params.replace('&w=165', '');
    // myUrl.search = params;
    // console.log(myUrl);
    return img.replace('&w=165', '');
  })
  .toString();

const toTSV = (route) => {
  let line = '';
  line += `${route.id}\t`;
  line += `${clean(route.name)}\t`;
  line += `${route.url}\t`;
  line += `${route.type}\t`;
  line += `${toInt(route.length)}\t`;
  line += `${getGrade(route.grade)}\t`;
  line += `${fixStars(route.stars)}\t`;
  line += `${clean(route.location)}\t`;
  line += `${route.number}\t`;
  line += `${getGradeInt(route.grade)}\t`;
  line += `${imagesStr(route.images)}`;
  console.log(line);
};

routes.forEach(toTSV);
