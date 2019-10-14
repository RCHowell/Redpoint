const regWithUrl = require('../datasets/regions.json');
const regWithout = require('../datasets/walls.json');


const getUrl = (wallName) => {
  let url;
  regWithUrl.forEach((region) => {
    region.walls.forEach((wall) => {
      if (wall.name === wallName) url = wall.url;
    });
  });
  return url;
};

regWithout.forEach((region) => {
  region.walls.forEach((wall) => {
    const url = getUrl(wall.name);
    wall.url = url;
  });
});

console.log(JSON.stringify(regWithout, null, 2));
