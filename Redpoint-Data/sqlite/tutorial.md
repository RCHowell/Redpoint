# SQLite Basic Setup with REDPoint-Data

Note: These commands use relative paths so I'm operating under the assumption that the file structure is like so

```
.
├── data
│   ├── graph.json (scraped area and route graph)
│   ├── pages.tsv (name, url, type of mountainproject pages)
│   ├── tags.tsv (route tags)
│   ├── relationships.tsv (transitive closure table for areas and routes relationship - including depth)
├── sqlite (Running database commands from here)
│   ├── database.db
│   ├── join_examples.sql
│   ├── tables.sql (table schemas)
│   ├── areas.sql (areas table schema)
│   └── tutorial.md
```

## Database Tutorial
> Note: This works fine for now. I may automate this later with gulp.

### Step 1: Construct Graph and .TSV's
```
# Within the project root
node ./graph.js > ./data/graph.json
```

### Step 2: Create Databse and Insert Tables
```
# Within ./sqlite/
sqlite3 database.db < tables.sql
```

### Step 3: Insert TSV's of Pages and Relationships
```
# Within ./sqlite/
sqlite3 database.db
.mode tabs
.import ../data/pages.tsv pages
.import ../data/relationships.tsv relationships
```

### Step 4: Scrape Routes
```
# Within the project root
node ./routes.js
```

### Step 5: Generate Tags
```
# Within ./tagging/
source ./bin/activate
cd src
python tags.py > ../../data/tags.tsv
```

### Step 6: Insert Tags to Database
```
# Within ./sqlite/
sqlite3 database.db
.mode tabs
.import ../data/tags.tsv tags
```

## Formatted Output
```
.mode column
.headers on

# Show the elapsed time for a query
.timer on
```

## Describe Database
```
# List tables
.tables

# Describe tables
PRAGMA table_info([tablename]);

# Show table creation code
.schema tablename

# Show stats for queries
.stats on
```

## Adding a Column to a Table
```
ALTER TABLE {tablename} ADD COLUMN {new column} {type}
``` 