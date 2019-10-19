const regions = require('../datasets/walls.json');

regions.forEach((region) => {
  region.walls.forEach((wall) => {
    console.log(`${region.id}\t${wall.id}`);
  });
});
