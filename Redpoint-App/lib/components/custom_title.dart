import 'package:flutter/material.dart';

/// Custom Title that is often re-used
///
/// Takes a [String] for [text] and creates a single line, fading overflow, headline title.
class CustomTitle extends StatelessWidget {
  final String text;

  CustomTitle(this.text);

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.headline2;
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
        child: Text(
          this.text,
          textAlign: TextAlign.left,
          style: style,
          overflow: TextOverflow.fade,
          maxLines: 1,
        )
      );
  }
}
