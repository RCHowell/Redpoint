/**
  This is the main scraping script.
  This script performs a Depth First Search starting at the base of the Red River Gorge.
  This script constructs a table of the pages it found and their type.
  This script also constructs a transitive closure table
  for SQL graph representation and efficient descendent querying in SQL

  @ Author R. C. Howell 2017
*/

const request = require('sync-request');
const cheerio = require('cheerio');
const fs = require('fs');

const pages = fs.createWriteStream('./data/pages.tsv');
const relationships = fs.createWriteStream('./data/relationships.tsv');

// Write TSV Headers
// pages.write('PAGE_ID\tPAGE_NAME\tPAGE_URL\tIS_ROUTE\n');
// relationships.write('PARENT_ID\tCHILD_ID\n');

// Count tallies up how many nodes have been made, and uses that the node id
let COUNT = 0;

class Node {
  constructor(name, url, type) {
    COUNT += 1;
    this.id = COUNT;
    this.name = name;
    this.url = url;
    this.children = [];
    this.type = type;
  }

  addChild(child) {
    this.children.push(child);
  }
}

function writeToTSV(node) {
  // This data is intended to be inserted into sqlite which doesn't have a boolean type
  const isRoute = (node.type === 'route') ? 1 : 0;
  pages.write(`${node.id}\t"${node.name}"\t"${node.url}"\t${isRoute}\n`);
}

// Setup to perform depth first search
const discovered = new Map();
const stack = [];

// Setup ancestry tracking during the search
const ancestries = new Map();

// Setup where to start searching from
const rootUrl = 'https://www.mountainproject.com/area/105841134/red-river-gorge';
const rootNode = new Node('Red River Gorge', rootUrl, 'area');
writeToTSV(rootNode);

// Initialize control structures
stack.push(rootNode);
ancestries.set(rootNode.id, []);

// Begin search to construct graph
while (stack.length !== 0) {
  const node = stack.pop();
  const nodeAnsestry = ancestries.get(node.id);
  const newAnsestry = nodeAnsestry.concat(node.id);
  if (discovered.has(node) === false) {
    discovered.set(node.name, true);
    // Scrape Info about this node's potential children
    const res = request('GET', node.url);
    const body = res.getBody();
    const $ = cheerio.load(body);
    // List Title tells us what the children are.
    const listTitle = $('.mp-sidebar h3').text();
    // Set a boolean to true if the children are areas.
    const discoveringAreas = listTitle.search('Areas') !== -1;
    const selector = (discoveringAreas) ? '.lef-nav-row a' : '#left-nav-route-table tbody tr a';
    const type = (discoveringAreas) ? 'area' : 'route';
    // if (discoveringAreas) console.log(`Exploring ${node.name}`);
    $(selector).each((i, e) => {
      // Replace all single quotes with double single qoutes for sql storage
      const name = $(e).text().replace(/'/g, "''").replace(/"/g, '');
      const url = $(e).attr('href');
      const child = new Node(name, url, type);
      writeToTSV(child);
      ancestries.set(child.id, newAnsestry);
      node.addChild(child);
      if (discoveringAreas) stack.push(child);
    });
  }
}


pages.end();

// Write the transitive closure table
ancestries.forEach((ancestry, id) => {
  const { length } = ancestry;
  for (let depth = 1; depth <= length; depth += 1) {
    const parentId = ancestry[length - depth];
    relationships.write(`${parentId}\t${id}\t${depth}\n`);
  }
});

// Write the graph to standard out
console.log(JSON.stringify(rootNode));

relationships.end();
