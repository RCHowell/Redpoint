import 'package:flutter/material.dart';

/// A custom material-like card to hold area tile information
///
/// Takes a [Widget] as a [child].
class CustomCard extends StatelessWidget {
  final Widget child;

  CustomCard({this.child});

  @override
  Widget build(BuildContext context) {

    Color canvasColor = Theme.of(context).canvasColor;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 14.0),
      child: Material(
        color: canvasColor,
        type: MaterialType.card,
        borderRadius: BorderRadius.circular(6.0),
        elevation: 2.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
          child: this.child,
        ),
      ),
    );

  }
}
