// R. C. Howell - 2018
// rhowell2@nd.edu

const regions = require('../tmp/regions.json');

let id = 0; // continually incremented to get unique id's for all pages
// A 'page' being a region, wall, or route

// Scraping Information
const SCOPE = '#main';
const x = require('x-ray')({
  filters: {
    // eslint-disable-next-line no-confusing-arrow
    fixDirections: (t) => {
      if (!t) return 'Unknown';
      const splitText = t.split(/\n{4}/);
      if (splitText.length < 2) return t.trim();
      return splitText[1].replace('.Wall', '. Wall').replace(' {show overview map}', '.').trim();
    },
    fixStars: (t) => {
      if (!t) return undefined;
      if (t === '') return 0;
      const stars = parseFloat(t.split(' ')[0]);
      return (stars != null) ? stars : 0;
    },
    fixGrade: (g) => {
      if (!g) return undefined;
      const tokens = g.split('\n');
      // Scraping returns a grade "key" and the yds grade
      return tokens[tokens.length - 1];
    },
    trim: t => (!t) ? undefined : t.trim(),
    parseInt: (n) => {
      if (!n) return undefined;
      const parsedInt = parseInt(n, 10);
      return (parsedInt != null) ? parsedInt : 0;
    },
  },
});

const getRoutesForWall = wall => new Promise((resolve) => {
  x(wall.url, SCOPE, {
    directions: '#dir_p | fixDirections',
    routes: x('table.wall_list tr', [{
      number: 'td:nth-child(1) p | parseInt',
      name: 'td:nth-child(3) a@title',
      url: 'td:nth-child(3) a@href',
      type: 'td:nth-child(4) | trim',
      grade: 'td:nth-child(5) | fixGrade | trim',
      stars: 'td:nth-child(7) | fixStars',
      length: 'td:nth-child(8) span',
    }]),
  }).then((wallData) => {
    // eslint-disable-next-line no-param-reassign
    wallData.name = wall.name;
    wallData.url = wall.url;
    wallData.id = id++;
    wallData.routes.forEach((route) => {
      route.id = id++;
    });
    resolve(wallData);
  }).catch((e) => {
    console.log(`\n --- Error for ${wall.name}, ${wall.url} --- \n`);
    console.log(e);
    resolve();
  });
});

module.exports = {
  stream: async (out) => {
    out.write('[');
    for (const region of regions) {
      const runners = region.walls.map(getRoutesForWall);
      const wallData = await Promise.all(runners);
      // eslint-disable-next-line prefer-template
      out.write(JSON.stringify({
        id: id++,
        region: region.region,
        walls: wallData,
      }, null, 2) + ',');
    }
    out.write(']');
  },
};
