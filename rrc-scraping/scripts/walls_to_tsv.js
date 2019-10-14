const regions = require('../datasets/walls.json');
const escape = require('sql-escape');

const wallToTSV = (wall) => {
  const name = wall.name.replace('\t', '');
  if (!wall.directions) wall.directions = 'No Direction Information';
  const directions = wall.directions.replace(/\t+|\r?\n|\r/g, '');
  console.log(`${wall.id}\t${name}\t${wall.url}\t${directions.trim()}`);
};

regions.forEach((region) => {
  region.walls.forEach((wall) => {
    wallToTSV(wall);
  });
});
