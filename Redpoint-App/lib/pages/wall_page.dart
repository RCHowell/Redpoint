import 'package:flutter/material.dart';
import 'package:red_point/components/bordered_section.dart';
import 'package:red_point/components/divider_title.dart';
import 'package:red_point/components/mini_map.dart';
import 'package:red_point/components/route_sorting_popup_menu.dart';
import 'package:red_point/models/route.dart';
import 'package:red_point/pages/map_page.dart';
import 'package:red_point/pages/route_page.dart';
import 'package:red_point/components/charts/grade_histogram_detailed.dart';
import 'package:red_point/components/custom_card.dart';
import 'package:red_point/components/charts/types_chart.dart';
import 'package:red_point/components/route/route_list_tile.dart';
import 'package:red_point/models/route.dart' as R;
import 'package:red_point/models/wall.dart';
import 'package:red_point/presenters/wall_page_presenter.dart';
import 'package:red_point/pages/download_images_page.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';

class WallPage extends StatefulWidget {
  final int id;

  WallPage(this.id);

  @override
  State createState() => _WallPageState(id);
}

class _WallPageState extends State<WallPage> implements WallPageViewContract {
  int id;
  Wall _wall;
  WallPagePresenter _presenter;

  _WallPageState(this.id) {
    _presenter = WallPagePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.getWall();
    _presenter.getRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return (_wall != null)
        ? DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text(_wall.name),
                actions: <Widget>[
                  RouteSortingPopupMenu(
                    choices: [
                      RouteSortingChoice.alpha,
                      RouteSortingChoice.grade,
                      RouteSortingChoice.stars,
                      RouteSortingChoice.l2r,
                      RouteSortingChoice.r2l,
                    ],
                    onSelected: (RouteSortingChoice choice) {
                      _presenter.sortRoutes(_wall.routes, choice);
                    },
                  ),
                  _bookmarkButton(),
                ],
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(icon: const Icon(Icons.format_list_bulleted)),
                    Tab(icon: const Icon(Icons.poll)),
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  _routeList(),
                  _Overview(_wall),
                ],
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }

  Widget _bookmarkButton() => IconButton(
        icon:
            Icon((_wall.isBookmarked) ? Icons.bookmark : Icons.bookmark_border),
        onPressed: _presenter.toggleBookmark,
      );

  Widget _routeList() => ListView.builder(
        itemBuilder: (_, int i) => Column(
          children: <Widget>[
            RouteListTile(_wall.routes[i], () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => RoutePage(_wall.routes[i], _wall.name),
              ));
            }),
            Divider(height: 2.0),
          ],
        ),
        itemCount: _wall.routes.length,
      );

  @override
  void onGetWallComplete(Wall wall) {
    setState(() {
      _wall = wall;
    });
  }

  @override
  void onGetRoutesComplete(List<R.Route> routes) {
    setState(() {
      _wall.routes = routes;
    });
  }

  @override
  void onToggleBookMarkComplete(bool isBookmarked) {
    setState(() {
      _wall.isBookmarked = isBookmarked;
    });
  }
}

class _Overview extends StatefulWidget {
  final Wall _wall;

  _Overview(this._wall);

  @override
  State createState() => _OverviewState(_wall);
}

class _OverviewState extends State<_Overview> {
  final Wall _wall;

  _OverviewState(this._wall);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ListView(
      children: <Widget>[
        // MAP
        // DividerTitle('Map'),
        // Container(
        //   margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 14.0),
        //   height: 200.0,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(4.0),
        //     border: Border.all(
        //       color: Colors.blueGrey[100],
        //     ),
        //   ),
        //   child: MiniMap(_wall.id),
        // ),
        // DIRECTIONS
        DividerTitle('Directions'),
        BorderedSection(
          child: Text(
            _wall.directions,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14.0,
              height: 1.4,
            ),
          ),
        ),
        // STATS
        DividerTitle('Wall Stats'),
        BorderedSection(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 140.0,
                child: GradeHistogramDetailed(_wall.routes),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: SizedBox(
                  height: 140.0,
                  child: TypesChart(_wall.routes, animate: true),
                ),
              ),
            ],
          ),
        ),
        // DOWNLOAD IMAGES
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 14.0,
          ),
          child: FlatButton(
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Text('Download Images'),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => DownloadImagesPage(_wall),
              ));
            },
          ),
        ),
      ],
    );
  }
}
