# Redpoint-App

This directory contains the [Flutter](https://flutter.dev) app for Redpoint.

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

