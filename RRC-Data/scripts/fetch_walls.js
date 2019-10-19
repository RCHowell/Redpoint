const walls = require('../lib/walls');
const fs = require('fs');
const path = require('path');

const outfile = path.resolve('./tmp/walls.json');
const buffer = fs.createWriteStream(outfile);

walls.stream(buffer);
