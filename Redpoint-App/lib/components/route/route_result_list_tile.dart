import 'package:flutter/material.dart';
import 'package:red_point/models/route.dart' as RRoute;

class RouteResultListTile extends StatelessWidget {
  final RRoute.Route route;
  final Function onTap;

  RouteResultListTile(this.route, this.onTap);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<Widget> starList = _getStars(context);

    if (route.images.length > 0)
      starList.add(Icon(
        Icons.image,
        color: theme.textTheme.body1.color,
        size: 14.0,
      ));

    return Material(
      color: Colors.white,
      child: ListTile(
        onTap: onTap,
        title: Text(
          route.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: starList),
            Text(route.wall, textAlign: TextAlign.left),
          ],
        ),
        trailing: _trailing(theme),
      ),
    );
  }

  Widget _trailing(ThemeData theme) {
    return Chip(
      label: Text(
        route.grade.yds,
        style: theme.textTheme.body1.copyWith(
          color: _getTypeTextColor(),
        ),
      ),
      backgroundColor: _getTypeBackgroundColor(theme),
    );
  }

  Color _getTypeTextColor() {
    if (route.type == 'Sport') return Colors.white;
    if (route.type == 'Trad') return Colors.blueGrey[100];
    return Colors.blueGrey[800];
  }

  Color _getTypeBackgroundColor(ThemeData theme) {
    if (route.type == 'Sport') return theme.primaryColor;
    if (route.type == 'Trad') return Colors.blueGrey[500];
    return Colors.blueGrey[100];
  }

  List<Widget> _getStars(BuildContext context) {
    List<Widget> stars = new List<Widget>();
    ThemeData theme = Theme.of(context);
    Color color = theme.textTheme.body1.color;
    double size = 14.0;

    // Round count to nearest half and decide which 5 icons to show
    double rounded = (this.route.stars * 2).round() / 2;
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
}
