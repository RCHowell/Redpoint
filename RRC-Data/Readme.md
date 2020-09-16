# Red River Climbing Scraping

Disclaimer: this is dated and ugly, but apparently still.

This directory holds scripts used to scrape route and area information from Red River Climbing. You can find a copy of the database here `./sqlite/db.sqlite3` or `Redpoint-App/assets/db.sqlite3`.

## Verification

There is little verification. I compared the number of scraped routes to the number of routes on rrc when doing an empty advanced search. The most recent time I scraped, I retrieved all 3,303 routes. 
## Steps

### Fetching
```
node ./scripts/fetch_regions.js
node ./scripts/fetch_walls.js
node ./scripts/fetch_routes.js | tee error.log
```

### Transforming
```
node ./scripts/regions_to_tsv.js > ./sqlite/data/regions.tsv
node ./scripts/walls_to_tsv.js > ./sqlite/data/walls.tsv
node ./scripts/routes_to_tsv.js > ./sqlite/data/routes.tsv
```

### Relationships

```
node ./scripts/regions_to_walls_tsv.js > ./sqlite/data/regions_to_walls.tsv
node ./scripts/walls_to_routes_tsv.js > ./sqlite/data/walls_to_routes.tsv
```

### Sqlite DB

```
cd sqlite
sqlite3 db.sqlite3 < ./tables.sql
sqlite3 db.sqlite3 < ./create.sql

# validate
sqlite> select count(*) from routes;
3303
```
