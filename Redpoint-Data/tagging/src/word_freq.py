import sqlite3
import nltk
from nltk import Text
import string

connection = sqlite3.connect('../../sqlite/database.db')
connection.row_factory = sqlite3.Row
cursor = connection.cursor()
cursor.execute('SELECT * FROM routes')

# Setup for creating a frequency distribution
corpus_tokens = []
stopwords = nltk.corpus.stopwords.words('english') + list(string.punctuation) + ['...']

# Build a massive text of all route descriptions
routes = cursor.fetchall()
for route in routes:
  description = route['description']
  tokens = nltk.tokenize.word_tokenize(description)
  tags = nltk.pos_tag(tokens)
  for tag in tags:
    if 'VB' not in tag[1]: corpus_tokens.append(tag[0])

dist = nltk.FreqDist(w.lower() for w in corpus_tokens if w not in stopwords)
dist.plot(100, cumulative=False)
