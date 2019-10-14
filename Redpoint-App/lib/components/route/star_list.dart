import 'package:flutter/material.dart';
import 'package:red_point/components/bullet.dart';

/// Class to generate lists of 4 stars
/// MountainProject does 4 star ratings
/// 
/// Given some number of stars, generate either the [List] of star icons or
/// a [StaticBullet] filled with the star icons.
class StarList {

  static List<Widget> get(num starCount, BuildContext context) {
    List<Widget> stars = List();
    ThemeData theme = Theme.of(context);
    Color color = theme.textTheme.body1.color;
    double size = theme.textTheme.subhead.fontSize + 2;

    // Round count to nearest half and decide which 4 icons to show
    double rounded = (starCount * 2).round() / 2;
    int wholeCount = rounded.truncate();
    int emptyCount = 5 - wholeCount;
    bool hasHalf = (rounded - wholeCount) == 0.5;

    // Add whole stars
    for (int i = 0; i < wholeCount; i += 1) {
      stars.add(new Icon(
        Icons.star,
        color: color,
        size: size,
      ));
    }

    // Add half star
    if (hasHalf) {
      emptyCount -= 1;
      stars.add(new Icon(
        Icons.star_half,
        color: color,
        size: size,
      ));
    }

    // Add open stars
    for (int i = 0; i < emptyCount; i += 1) {
      stars.add(new Icon(
        Icons.star_border,
        color: color,
        size: size,
      ));
    }

    return stars;
  }

  static Widget bullet(num starCount, BuildContext context) {
    return new StaticBullet(
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: StarList.get(starCount, context),
        ),
      ),
    );
  }

}