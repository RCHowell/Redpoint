import 'package:flutter/material.dart';

class DividerTitle extends StatelessWidget {

  final String _title;

  DividerTitle(this._title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 8.0,
      ),
      child: Text(
        _title,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: Colors.blueGrey[800],
        ),
      ),
    );
  }
}