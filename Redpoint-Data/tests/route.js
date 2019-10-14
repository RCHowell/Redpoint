// This is not an automated test file. See spec.js for automated tests
// The purpose of this file is for viewing class function and debugging
const Route = require('../lib/route');

const route = new Route({
  url: process.argv[2],
});

route.get().then((data) => {
  console.log(data);
});
