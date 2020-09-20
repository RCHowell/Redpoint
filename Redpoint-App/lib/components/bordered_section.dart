import 'package:flutter/material.dart';

class BorderedSection extends StatelessWidget {
  final Widget child;


  BorderedSection({this.child});

  @override
  Widget build(BuildContext context) {
    Color canvasColor = Theme.of(context).canvasColor;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.blueGrey[100]),
          bottom: BorderSide(width: 1.0, color: Colors.blueGrey[100]),
        ),
      ),
      child: this.child,
    );
  }
}
