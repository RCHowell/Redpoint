const regions = require('../datasets/walls.json');

regions.forEach((region) => {
  region.walls.forEach((wall) => {
    wall.routes.forEach((route) => {
      console.log(`${wall.id}\t${route.id}`);
    });
  });
});
