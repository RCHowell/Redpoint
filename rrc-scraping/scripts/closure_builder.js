// This file constructs a transitive closure table from current relationships
// Currently, relationships can on be queried for direct descendents with a single query
// I have to recursively query to get more descendents.
// This is inefficient when sqflite on iOS and Android is not multi-threaded
// The solution is to expand the current relationships table to be a transitive closure table

// Top level element is regions, but there is wall data
const regions = require('../datasets/walls.json');

regions.forEach((region) => {
  region.walls.forEach((wall) => {
    console.log(`${region.id}\t${wall.id}\t1`);
    wall.routes.forEach((route) => {
      console.log(`${region.id}\t${route.id}\t2`);
      console.log(`${wall.id}\t${route.id}\t1`);
    });
  });
});
