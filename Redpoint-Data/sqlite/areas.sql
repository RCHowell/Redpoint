CREATE TABLE areas(
  area_id INT PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  url TEXT NOT NULL,
  lat INT NOT NULL,
  lon INT NOT NULL,
  description TEXT NOT NULL,
  location TEXT NOT NULL,
  needsPermit INT NOT NULL,
  permitInfo TEXT NOT NULL
);
