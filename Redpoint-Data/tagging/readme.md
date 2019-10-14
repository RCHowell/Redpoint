# REDPoint-Data Tagging

This folder contains a python virtual environment with NLTK installed in order to generate tags from route descriptions.

An ideal route object will contain
```
  route_id INT PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  url TEXT NOT NULL,
  type TEXT NOT NULL,
  length INT NOT NULL,
  grade TEXT NOT NULL,
  stars REAL NOT NULL,
  location TEXT NOT NULL,
  protection TEXT NOT NULL,
  number INT NOT NULL,
  needsPermit INT NOT NULL,
  permitInfo TEXT NOT NULL,
```
