import 'package:flutter/material.dart';

// Components
import 'package:red_point/components/bullet.dart';
import 'package:red_point/components/custom_title.dart';
import 'package:red_point/components/custom_card.dart';

// Model
import 'package:red_point/models/route.dart' as RRoute;

class RouteTile extends StatelessWidget {
  final RRoute.Route route;
  final Function onTap;

  RouteTile(this.route, this.onTap);

  @override
  Widget build(BuildContext context) {
    List<Widget> starList = _getStars(context);
    TextStyle subheadStyle = Theme.of(context).textTheme.subtitle1;
    Color red = Theme.of(context).primaryColor;
    TextStyle style = new TextStyle(
      fontFamily: subheadStyle.fontFamily,
      fontWeight: subheadStyle.fontWeight,
      fontSize: subheadStyle.fontSize,
      color: Colors.white,
    );

    String title = (route.number != 999999)
        ? '${route.number + 1}. ${route
        .name}'
        : route.name;

    return new GestureDetector(
      onTap: onTap,
      child: new CustomCard(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new CustomTitle(title),
            new Row(
              children: <Widget>[
                new StaticBullet(
                  child: new Text(
                    route.grade.yds,
                    style: style,
                  ),
                  color: red,
                ),
                new Bullet(
                  text: '${this.route.length}\'',
                ),
                new Bullet(
                  text: route.type,
                  color: _typeColor(),
                ),
                new StaticBullet(
                  child: new Container(
                    margin: const EdgeInsets.symmetric(vertical: 2.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: starList,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _typeColor() {
    String color;
    if (this.route.type == 'Sport')
      color = 'red';
    else if (this.route.type == 'Trad')
      color = 'dark';
    else
      color = 'light';
    return color;
  }

  List<Widget> _getStars(BuildContext context) {
    List<Widget> stars = new List<Widget>();
    ThemeData theme = Theme.of(context);
    Color color = theme.textTheme.bodyText1.color;
    double size = theme.textTheme.subtitle1.fontSize + 2;

    // Round count to nearest half and decide which 5 icons to show
    double rounded = (this.route.stars * 2).round() / 2;
    int wholeCount = rounded.truncate();
    int emptyCount = 4 - wholeCount;
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
}

class SmallRouteTile extends StatelessWidget {
  final RRoute.Route route;
  final Function onTap;

  SmallRouteTile(this.route, this.onTap);

  @override
  Widget build(BuildContext context) {
    List<Widget> starList = _getStars(context);
    TextStyle subheadStyle = Theme.of(context).textTheme.subtitle1;
    Color red = Theme.of(context).primaryColor;
    TextStyle style = new TextStyle(
      fontFamily: subheadStyle.fontFamily,
      fontWeight: subheadStyle.fontWeight,
      fontSize: subheadStyle.fontSize,
      color: Colors.white,
    );

    return new GestureDetector(
      onTap: onTap,
      child: new CustomCard(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new CustomTitle(route.name),
            new Row(
              children: <Widget>[
                new StaticBullet(
                  child: new Text(
                    route.grade.yds,
                    style: style,
                  ),
                  color: red,
                ),
//                new Bullet(
//                  text: route.type,
//                  color: _typeColor(),
//                ),
                new Bullet(
                  text: '${this.route.length}\'',
                ),
                new StaticBullet(
                  child: new Container(
                    margin: const EdgeInsets.symmetric(vertical: 2.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: starList,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _typeColor() {
    String color;
    if (this.route.type == 'Sport')
      color = 'red';
    else if (this.route.type == 'Trad')
      color = 'dark';
    else
      color = 'light';
    return color;
  }

  List<Widget> _getStars(BuildContext context) {
    List<Widget> stars = new List<Widget>();
    ThemeData theme = Theme.of(context);
    Color color = theme.textTheme.bodyText1.color;
    double size = theme.textTheme.subtitle1.fontSize + 2;

    // Round count to nearest half and decide which 5 icons to show
    double rounded = (this.route.stars * 2).round() / 2;
    int wholeCount = rounded.truncate();
    int emptyCount = 4 - wholeCount;
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
}
