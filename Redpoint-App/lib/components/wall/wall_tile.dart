import 'package:flutter/material.dart';
import 'package:red_point/models/wall.dart';
import 'package:red_point/components/custom_card.dart';
import 'package:red_point/components/custom_title.dart';
import 'package:red_point/components/charts/grade_histogram.dart';
import 'package:red_point/components/wall/route_type_bullets.dart';

class WallTile extends StatelessWidget {
  final Wall _wall;
  final Function _onTap;

  WallTile(this._wall, this._onTap);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: _onTap,
    child: CustomCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomTitle(_wall.name),
          SizedBox(
            height: 65.0,
            child: GradeHistogram(_wall.routes),
          ),
          Container(
            margin: const EdgeInsets.only(top: 4.0),
            child: RouteTypeBullets(_wall.routes),
          )
        ],
      ),
    ),
  );
}
