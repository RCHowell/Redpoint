CREATE TABLE pages(
  page_id INT PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  url  TEXT NOT NULL,
  is_route INT NOT NULL
);

CREATE TABLE relationships(
  parent_id INT NOT NULL,
  child_id  INT NOT NULL,
  depth INT NOT NULL,
  FOREIGN KEY (parent_id) REFERENCES pages(page_id),
  FOREIGN KEY (child_id)  REFERENCES pages(page_id)
);

CREATE TABLE routes(
  route_id INT PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  url TEXT NOT NULL,
  type TEXT NOT NULL,
  length INT NOT NULL,
  grade TEXT NOT NULL,
  stars REAL NOT NULL,
  description TEXT NOT NULL,
  location TEXT NOT NULL,
  protection TEXT NOT NULL,
  number INT NOT NULL,
  needs_permit INT NOT NULL,
  permit_info TEXT NOT NULL,
  grade_int INT NOT NULL,
);

CREATE TABLE tags(
  tag TEXT NOT NULL,
  route_id INT NOT NULL,
  FOREIGN KEY (route_id) REFERENCES routes(route_id)
);
