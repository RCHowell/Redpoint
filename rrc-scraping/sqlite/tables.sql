CREATE TABLE regions(
  region_id INT PRIMARY KEY NOT NULL,
  name TEXT NOT NULL
);

CREATE TABLE walls(
  wall_id INT PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  url TEXT NOT NULL,
  directions TEXT NOT NULL
);

CREATE TABLE routes(
  route_id INT PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  url TEXT NOT NULL,
  type TEXT NOT NULL,
  length INT NOT NULL,
  grade TEXT NOT NULL,
  stars REAL NOT NULL,
  location TEXT NOT NULL,
  number INT NOT NULL,
  grade_int INT NOT NULL,
  images TEXT NOT NULL
);

CREATE TABLE regions_to_walls(
  region_id INT NOT NULL,
  wall_id  INT NOT NULL,
  FOREIGN KEY (region_id) REFERENCES regions(region_id),
  FOREIGN KEY (wall_id)  REFERENCES walls(wall_id)
);

CREATE TABLE walls_to_routes(
  wall_id INT NOT NULL,
  route_id  INT NOT NULL,
  FOREIGN KEY (wall_id) REFERENCES walls(wall_id),
  FOREIGN KEY (route_id)  REFERENCES routes(route_id)
);
