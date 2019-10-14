import 'package:flutter/material.dart';
import 'package:red_point/models/wall.dart';

class WallListTile extends StatelessWidget {
  final Wall _wall;
  final Function _onTap;

  WallListTile(this._wall, this._onTap);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Material(
      color: Colors.white,
      child: ListTile(
        onTap: _onTap,
        title: Text(
          _wall.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('${_wall.routes.length} routes'),
      ),
    );
  }

}
