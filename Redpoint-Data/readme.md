# REDPoint-data

## IMPORTANT
Mountain Project has updated their entire site. The route scraping scripts are now outdated because of this. I will not be updating the scripts until necessary for my other project. Currently, the `graph.js` script is the only one updated to work with the Mountain Project update.

What's this?

I'm working on a project which requires lots of Rock Climbing data! So, this is a repo which has some scraping scripts to get data from Mountain Project. I have it configured to start a depth first search at Kentucky's Red River Gorge, but that could be replaced to start anywhere. Classes in `/lib` can be used to retrieve more information from the page. `index.js` is what constructs the graph of urls and recognizes a page as either a route or an area.

## What are the nodes?

```javascript
class Node {
  constructor(name, url, type) {
    // I'm using the current node count as an id
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
```

## graph.json

This file contains a stringify-ed version of the generated graph.

## pages.tsv and relationships.tsv

These files contain data ready to be inserted into a SQL database.

A **page** is an area or route.

A **relationship** holds the id's of parents and children

## Creating the database
1. Run `node graph.js > graph.json`
1. Follow instructions in `/sqlite` to create the database and insert relationships and pages
1. Run `node routes.js` to insert routes table and routes into the database
