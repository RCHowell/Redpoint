// R. C. Howell - 2018
// rhowell2@nd.edu

// Scraping Information
const ROOT_URL = 'https://www.redriverclimbing.com/RRCGuide/';
const SCOPE = '.region_collection';
const SELECTOR = '.nav_links';
const REGION_NAMES = [
  'Grays Branch Region',
  'Lower Gorge Region',
  'Northern Gorge Region',
  'Middle Gorge Region',
  'Upper Gorge Region',
  'Eastern Gorge Region',
  'Tunnel Ridge Road Region',
  'Natural Bridge Region',
  'Southern Region',
  'Muir Valley',
  'Miller Fork',
  'Foxtown',
];
let regionCount = 0;

const x = require('x-ray')({
  filters: {
    // eslint-disable-next-line no-confusing-arrow
    trim: v => typeof v === 'string' ? v.trim() : v,
    // eslint-disable-next-line no-plusplus, no-unused-vars
    getRegionName: _ => REGION_NAMES[regionCount++],
  },
});

module.exports = {
  stream: (out) => {
    const stream = x(ROOT_URL, SCOPE, [{
      region: '@class | getRegionName',
      walls: x(SELECTOR, [{
        name: '@title',
        url: '@href',
      }]),
    }]).stream();
    stream.pipe(out);
  },
};
