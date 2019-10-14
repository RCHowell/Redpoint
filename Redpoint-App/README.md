# Redpoint

This is a Flutter app. You can build and install it on your Android or iOS device using the Flutter cli.

## TODOs
- (DATA) Add stats about wall angle and sun / weather
- (REFACTOR) Improve how sport/trad/other colors are determined
- Remove CLOSED areas from the database
- Create a locations table linked to places

## Features
- Offline images
  - Save images for a particular crag. You get the benefit of offline images, but can save a lot of storage space!
  - Caching of inidivdual images for routes you view so you don't have to download a whole area
- Offline maps & live GPS
  - Topographical maps of the Red River Gorge with GPS tracking for 
- Fast search
- Red River Climbing quicklinks
- Bookmark your favorite crags

## Offline Map Tiles
I use the [flutter_maps](https://pub.dartlang.org/packages/flutter_map) package to display offline
maps of the gorge.

### How To
1. Install TileMill
2. Follow these steps for OSM Bright - [link](https://tilemill-project.github.io/tilemill/docs/guides/osm-bright-mac-quickstart/)
3. Export Map Tiles
3. Use mbtilesToPng [link](https://github.com/alfanhui/mbtilesToPngs)

### Lat,Lon Bounds
Calculate the bounds with the following equation
```
n = 2 ^ zoom
lon_deg = xtile / n * 360.0 - 180.0
lat_rad = arctan(sinh(π * (1 - 2 * ytile / n)))
lat_deg = lat_rad * 180.0 / π
```

SouthWest Bounding Tile := (2190, 5024)
NorthEast Bounding Tile := (2193, 5027)

