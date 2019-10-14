import json
import sqlite3

# Load tags
file = open("./terms.json", "r")
file_text = file.read();
tag_list = json.loads(file_text)

# Load routes
connection = sqlite3.connect('../../sqlite/database.db')
connection.row_factory = sqlite3.Row
cursor = connection.cursor()
cursor.execute('SELECT * FROM routes')
routes = cursor.fetchall()

# Iterate over each route
for route in routes:
  route_tags = []
  description = route['description'].lower()
  # See if each tag is in the description
  for tag in tag_list:
    tag_name, tag_tests = tag.items()[0]
    # Each tag has multiple tests
    for test in tag_tests:
      if test in description:
        route_tags.append(tag_name)
        break
  for tag in route_tags:
    print(tag + "\t" + str(route['route_id']))
