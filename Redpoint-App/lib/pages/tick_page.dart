import 'package:flutter/material.dart';
import 'package:red_point/components/route/route_result_list_tile.dart';
import 'package:red_point/components/route_sorting_popup_menu.dart';
import 'package:red_point/models/route.dart';
import 'package:red_point/models/route.dart' as R;
import 'package:red_point/pages/route_page.dart';
import 'package:red_point/presenters/tick_page_presenter.dart';


class TickPage extends StatefulWidget {
  @override
  State createState() => _TickPageState();
}

class _TickPageState extends State<TickPage> implements TickPageViewContract {
  List<R.Route> _routeResults;
  TickPagePresenter _presenter;

  _TickPageState() {
    _presenter = TickPagePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _routeResults = List();
    _presenter.getRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticks'),
        centerTitle: true,
        actions: [
          RouteSortingPopupMenu(
            choices: [
              RouteSortingChoice.alpha,
              RouteSortingChoice.grade,
              RouteSortingChoice.stars
            ],
            onSelected: (RouteSortingChoice choice) {
              _presenter.sortRoutes(_routeResults, choice);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (_, int i) => Column(
          children: <Widget>[
            RouteResultListTile(_routeResults[i], () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) =>
                    RoutePage(_routeResults[i], _routeResults[i].wall),
              ));
            }),
            Divider(height: 2.0),
          ],
        ),
        itemCount: _routeResults.length,
      ),
    );
  }

  @override
  void onUpdateRoutesComplete(List<R.Route> routes) {
    setState(() {
      _routeResults = routes;
    });
  }
}
