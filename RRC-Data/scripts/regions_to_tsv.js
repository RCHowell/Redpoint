const regions = require('../datasets/walls.json');

regions.forEach((region) => {
    console.log(`${region.id}\t${region.region}`);
});
