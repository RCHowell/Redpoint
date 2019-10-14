-- Select all routes from an area with given id
.headers on
.mode column

-- Get children pages given a page id
SELECT pages.name, pages.url, relationships.depth FROM pages
INNER JOIN relationships
ON relationships.child_id = pages.page_id
WHERE relationships.parent_id = 3 AND pages.is_route = 1;


-- Select all areas/crags and print out routes broken down by type
SELECT
  P.page_id,
  P.name,
  P.url,
  (
    SELECT COUNT(*) FROM routes
    INNER JOIN relationships AS R
    ON R.child_id = routes.route_id
    WHERE R.parent_id = P.page_id AND routes.type = 'Sport'
  ) sport_count,
  (
    SELECT COUNT(*) FROM routes
    INNER JOIN relationships AS R
    ON R.child_id = routes.route_id
    WHERE R.parent_id = P.page_id AND routes.type = 'Trad'
  ) trad_count,
  (
    SELECT COUNT(*) FROM routes
    INNER JOIN relationships AS R
    ON R.child_id = routes.route_id
    WHERE R.parent_id = P.page_id AND routes.type != 'Trad' AND routes.type != 'Sport'
  ) other_count
FROM pages AS P
INNER JOIN relationships AS R ON R.child_id = P.page_id
WHERE R.parent_id = 1 AND P.is_route = 0 AND R.depth = 1;

SELECT
  R.route_id,
  R.name,
  (
    SELECT tag FROM tags
    LEFT JOIN routes ON routes.route_id = tags.route_id
  ) tags
FROM routes as R
LIMIT 1;

-- Query a route based upon attributes and tags
SELECT 
  r.route_id, r.name, r.length, r.stars, r.type, r.grade,
  GROUP_CONCAT(t.tag) AS tags
  FROM routes r
LEFT JOIN tags t
  ON t.route_id = r.route_id
WHERE
  r.length >= 0.0 AND
  r.stars >= 0.0 AND
  r.grade_int >= 0 AND
  r.type IN ('Trad', 'TradOriginal') AND
  t.tag IN ('arete', 'steep')
GROUP BY r.route_id
LIMIT 10;

SELECT * FROM tags WHERE
  tag IN ('pumpy', 'juggy');




