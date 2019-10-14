import sqlite3
import re

# Load routes
connection = sqlite3.connect('../../sqlite/database.db')
connection.row_factory = sqlite3.Row
cursor = connection.cursor()
cursor.execute('SELECT * FROM routes limit 50')
routes = cursor.fetchall()

bolt_regex = re.compile(r'\b([0-9]|[12][0-9])\b')

class Route:

  def __init__(self, name, bolts, stickclip):
    self.name = name
    self.bolts = bolts
    self.stickclip = stickclip

  def __str__(self):
    var_list = [self.name, self.bolts, self.stickclip]
    return "name: {0}\tbolts: {1}\tstickclip: {2}".format(*var_list)

# Iterate over each route
for route in routes:
  protection = route['protection'].lower()
  stickclip = 1 if 'stickclip' in protection else 0
  bolt_match = bolt_regex.match(protection)
  bolts = bolt_match.group(0) if bolt_match else None
  this_route = Route(route['name'], bolts, stickclip)
  print(str(this_route))
