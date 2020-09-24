import 'package:flutter/material.dart';
import 'package:red_point/models/route.dart';

typedef RouteSortingOnSelected = void Function(RouteSortingChoice choice);

class RouteSortingPopupMenu<T> extends StatelessWidget {
  
  final RouteSortingOnSelected onSelected;
  final List<RouteSortingChoice> choices;

  RouteSortingPopupMenu({@required this.onSelected, @required this.choices});

  @override
  Widget build(BuildContext context) {
    Color _color = Color.fromRGBO(160, 160, 160, 1.0);
    return PopupMenuButton<RouteSortingChoice>(
      icon: Icon(Icons.sort),
      tooltip: 'Sort',
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => choices.map((c) =>
          PopupMenuItem<RouteSortingChoice>(
            value: c,
        child: ListTile(
          leading: Icon(choiceIcons[c], color: _color),
          title: Text(choiceHints[c]),
        ),)
      ).toList(),
    );
  }

}