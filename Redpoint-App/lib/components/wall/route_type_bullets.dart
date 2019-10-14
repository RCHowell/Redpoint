import 'package:flutter/material.dart';
import 'package:red_point/models/route.dart' as R;

class RouteTypeBullets extends StatelessWidget {

  List<R.Route> _routes;

  RouteTypeBullets(this._routes);

  @override
  Widget build(BuildContext context) {

    Map<String, int> freqs = {
      "Sport": 0,
      "Trad": 0,
      "Other": 0
    };

    _routes.forEach((route) {
      if (freqs.containsKey(route.type)) freqs[route.type] += 1;
      else freqs["Other"] += 1;
    });

    List<_TypeCount> counts = List();
    freqs.forEach((type, count) {
      if (count > 0) counts.add(_TypeCount(type, count));
    });

    return Row(
      children: counts
          .map((_TypeCount c) => _RouteCountBullet(c))
          .toList(),
    );

  }

}

class _TypeCount {
  String type;
  int count;
  _TypeCount(this.type, this.count);
}

class _RouteCountBullet extends StatelessWidget {

  _TypeCount _typeCount;

  _RouteCountBullet(this._typeCount);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color other = theme.scaffoldBackgroundColor;
    Color red = theme.accentColor;
    TextStyle subheadStyle = theme.textTheme.subhead;
    Color color;
    Color textColor;

    if (_typeCount.type == 'Sport') {
      color = red;
      textColor = Colors.white;
    } else if (_typeCount.type == 'Trad') {
      color = Colors.blueGrey[500];
      textColor = Colors.blueGrey[100];
    } else {
      color = Colors.blueGrey[100];
      textColor = Colors.blueGrey[800];
    }

    TextStyle style = new TextStyle(
      fontFamily: subheadStyle.fontFamily,
      fontWeight: subheadStyle.fontWeight,
      fontSize: subheadStyle.fontSize,
      color: textColor,
    );

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: new BorderRadius.circular(6.0),
        ),
        child: Text('${_typeCount.count} ${_typeCount.type}',
          textAlign: TextAlign.center,
          style: style,
          overflow: TextOverflow.clip,
          maxLines: 1,
        ),
      ),
      flex: (_typeCount.count > 10) ? 2 : 1,
//      flex: _typeCount.count,
    );
  }
}