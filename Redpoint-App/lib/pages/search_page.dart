import 'package:flutter/material.dart';
import 'package:red_point/components/route/route_result_list_tile.dart';
import 'package:red_point/models/wall.dart';
import 'package:red_point/models/route.dart' as R;
import 'package:red_point/presenters/search_page_presenter.dart';
import 'package:red_point/pages/route_page.dart';
import 'package:red_point/pages/wall_page.dart';

class SearchPage extends StatefulWidget {
  @override
  State createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> implements SearchPageViewContract {

  List<Wall> _wallResults;
  List<R.Route> _routeResults;
  SearchPagePresenter _presenter;

  _SearchPageState() {
    _presenter = SearchPagePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _wallResults = List();
    _routeResults = List();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: _searchInput(),
          centerTitle: false,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: 'Routes'),
              Tab(text: 'Walls'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _routeResultsList(),
            _wallResultsList(),
          ],
        ),
      ),
    );
  }

  Widget _routeResultsList() {
    if (_routeResults.length < 1) return Center(child: Text('Routes'));
    return ListView.builder(
      itemBuilder: (_, int i) =>
          Column(
            children: <Widget>[
              RouteResultListTile(_routeResults[i], () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => RoutePage(_routeResults[i], _routeResults[i].wall),
                ));
              }),
              Divider(height: 2.0),
            ],
          ),
      itemCount: _routeResults.length,
    );
  }

  Widget _wallResultsList() {
    if (_wallResults.length < 1) return Center(child: Text('Walls'));
    return ListView.builder(
      itemBuilder: (_, int i) => Column(
        children: <Widget>[
          Material(
            color: Colors.white,
            child: ListTile(
              title: Text(_wallResults[i].name),
              trailing: Text(_wallResults[i].routes.length.toString()),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => WallPage(_wallResults[i].id),
                ));
              },
            ),
          ),
          Divider(height: 2.0),
        ],
      ),
      itemCount: _wallResults.length,
    );
  }

  Widget _searchInput() => Container(
        padding: EdgeInsets.only(left: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).primaryColorDark,
        ),
        child: TextField(
          onChanged: (String substring) {
            if (substring.isEmpty) {
              setState(() {
                _routeResults = List();
                _wallResults = List();
              });
            }
            else _presenter.search(substring);
          },
          autocorrect: false,
          autofocus: true,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          style: Theme.of(context).textTheme.body1.copyWith(
                color: Colors.white,
              ),
        ),
      );

  @override
  void onSearchComplete(List<R.Route> routes, List<Wall> walls) {
    setState(() {
      _routeResults = routes;
      _wallResults = walls;
    });
  }


}
