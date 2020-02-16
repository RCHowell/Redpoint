// This file constructs a transitive closure table from current relationships
// Currently, relationships can on be queried for direct descendents with a single query
// I have to recursively query to get more descendents.
// This is inefficient when sqflite on iOS and Android is not multi-threaded
// The solution is to expand the current relationships table to be a transitive closure table

const fs = require('fs');
const path = require('path');
const graph = require('./data/graph.json');

// Control stack for DFS
const stack = [];

// Discovered Map for search
const discovered = new Map();

// The root node defines the graph
const root = graph;

stack.push(root);
discovered.set(root.id, true);

const ancestries = new Map();
ancestries.set(root.id, []);

while (stack.length !== 0) {
  const node = stack.pop();
  const nodeAnsestry = ancestries.get(node.id);
  const newAnsestry = nodeAnsestry.concat(node.id);
  for (let i = 0; i < node.children.length; i += 1) {
    const child = node.children[i];
    if (discovered.get(child) === undefined) {
      stack.push(child);
      ancestries.set(child.id, newAnsestry);
      discovered.set(child, true);
    }
  }
}

// Print the transitive closure table
ancestries.forEach((ancestry, id) => {
  const { length } = ancestry;
  for (let depth = 1; depth <= length; depth += 1) {
    console.log(ancestry[length - depth], id, depth);
  }
});
