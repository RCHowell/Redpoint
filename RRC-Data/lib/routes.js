// Reads in wall data and fetches route data and writes to csv

// R. C. Howell - 2018
// rhowell2@nd.edu

const walls = require('../tmp/walls.json');

// If we already have routes, don't scrape them again
const currRoutes = require('../tmp/routes.json');

const scrapedRoutes = new Set();
scrapedRoutes.forEach(route => scrapedRoutes.add(route.id));

const x = require('x-ray')({
  filters: {
    removeTabs: t => (!t) ? null : t.replaceAll('\t', ''),
  },
});

const routes = [];
walls.forEach(e => e.walls.forEach((wall) => {
  // routes is not a flat array. It is broken into "chunks"
  // of size n with 1 <= n <= 100. This allows scraping n routes
  // concurrently
  routes.push(wall.routes);
}));

const scrapeRoute = route => new Promise((resolve) => {
  x(route.url, '#main', {
    images: x('#route_images', ['img@src']),
    location: '#route_directions',
  }).then((routeData) => {
    const fullRouteData = route;
    fullRouteData.images = routeData.images;
    fullRouteData.location = routeData.location;
    resolve(fullRouteData);
  }).catch((err) => {
    console.log(`\n -- Error for ${route.url} -- \n`);
    console.error(err);
    resolve();
  });
});

const writeRoutes = (out, routesToWrite) => routesToWrite.forEach((route) => {
  scrapedRoutes.add(route.id);
  // eslint-disable-next-line prefer-template
  out.write(JSON.stringify(route, null, 2) + ',');
});

module.exports = {
  stream: async (out) => {
    out.write('[');
    writeRoutes(out, currRoutes);
    for (const chunk of routes) {
      const runners = chunk
        .filter(r => !scrapedRoutes.has(r.id))
        .map(scrapeRoute);
      const routesData = await Promise.all(runners);
      writeRoutes(out, routesData);
    }
    out.write(']');
  },
};
