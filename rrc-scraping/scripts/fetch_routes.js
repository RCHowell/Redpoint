const routes = require('../lib/routes');
const fs = require('fs');
const path = require('path');

const outfile = path.resolve('./tmp/routes.json');
const buffer = fs.createWriteStream(outfile);

routes.stream(buffer);
