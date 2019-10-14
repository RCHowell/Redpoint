// This is not an automated test file. See spec.js for automated tests
// The purpose of this file is for viewing class function and debugging
const Area = require('../lib/area');

const page = {
  url: process.argv[2],
  id: 0,
};

const area = new Area(page);

area.get().then((data) => {
  console.log(data);
});
