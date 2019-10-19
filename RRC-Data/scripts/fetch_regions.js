const areasStream = require('../lib/regions');
const fs = require('fs');
const path = require('path');

const outfile = path.resolve('./tmp/regions.json');
const buffer = fs.createWriteStream(outfile);
areasStream.stream(buffer);
