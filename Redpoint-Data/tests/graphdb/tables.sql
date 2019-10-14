CREATE TABLE pages(
  page_id INT PRIMARY KEY NOT NULL,
  name TEXT NOT NULL
);

CREATE TABLE relationships(
  parent_id INT NOT NULL,
  child_id  INT NOT NULL,
  FOREIGN KEY (parent_id) REFERENCES pages(page_id),
  FOREIGN KEY (child_id)  REFERENCES pages(page_id)
);