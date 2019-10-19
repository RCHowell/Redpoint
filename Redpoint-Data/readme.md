# Redpoint-Data



## IMPORTANT
Mountain Project has updated their entire site, so the scraping scripts are now defunct. I will not be updating the scripts in favor of [Red River Climbing](https://www.redriverclimbing.com/RRCGuide/). I have chosen to switch from Mountain Project to Red River Climbing because RRC offers nearly double the number of routes with more details and images per route. Overall it is a better data source. You can find the latest scripts in the RRC-Data directory.

## What's this?

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
2. Follow instructions in `/sqlite` to create the database and insert relationships and pages
3. Run `node routes.js` to insert routes table and routes into the database
