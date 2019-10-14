import 'package:flutter/material.dart';

const double PAD_HOR = 10.0;
const double PAD_VERT = 6.0;

class Bullet extends StatelessWidget {

  final String text;
  String color;
  int flex;
  TextAlign align;

  Bullet({
    this.text,
    int flex = 1,
    String color = 'light',
    TextAlign align = TextAlign.center
  }) {
    this.flex = flex;
    this.color = color;
    this.align = align;
  }

  @override
  Widget build(BuildContext context) {

    ThemeData theme = Theme.of(context);
    Color dark = theme.scaffoldBackgroundColor;
    Color red = theme.accentColor;
    TextStyle subheadStyle = theme.textTheme.subhead;
    Color bulletColor;
    Color textColor;

    if (this.color == 'red') {
      bulletColor = red;
      textColor = Colors.white;
    } else if (this.color == 'dark') {
      bulletColor = Colors.blueGrey[100];
      textColor = Colors.blueGrey[800];
    } else {
      bulletColor = dark;
      textColor = Colors.blueGrey[800];
    }

    TextStyle style = new TextStyle(
      fontFamily: subheadStyle.fontFamily,
      fontWeight: subheadStyle.fontWeight,
      fontSize: subheadStyle.fontSize,
      color: textColor,
    );

    return new Expanded(
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
        padding: const EdgeInsets.symmetric(vertical: PAD_VERT, horizontal: PAD_HOR),
        decoration: new BoxDecoration(
          color: bulletColor,
          borderRadius: new BorderRadius.circular(6.0),
        ),
        child: new Text(
          this.text,
          textAlign: this.align,
          style: style,
          overflow: TextOverflow.clip,
          maxLines: 1,
        ),
      ),
      flex: this.flex,
    );
  }
}

/// A Static Bullet is just like a regular bullet, but it does not expand
class StaticBullet extends StatelessWidget {
  final Widget child;
  final Color color;

  StaticBullet({
    this.child,
    this.color
  });

  @override
  Widget build(BuildContext context) {

    Color fallbackColor = Theme.of(context).scaffoldBackgroundColor;

    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
      padding: const EdgeInsets.symmetric(vertical: PAD_VERT, horizontal: PAD_HOR),
      decoration: new BoxDecoration(
        color: (this.color != null) ? this.color : fallbackColor,
        borderRadius: new BorderRadius.circular(6.0),
      ),
      child: this.child,
    );
  }
}
