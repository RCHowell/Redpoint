import 'package:flutter/material.dart';
import 'package:red_point/components/route/route_result_list_tile.dart';
import 'package:red_point/components/route_sorting_popup_menu.dart';
import 'package:red_point/models/filter.dart';
import 'package:red_point/models/grade.dart';
import 'package:red_point/models/route.dart';
import 'package:red_point/models/wall.dart';
import 'package:red_point/models/route.dart' as R;
import 'package:red_point/presenters/search_page_presenter.dart';
import 'package:red_point/pages/route_page.dart';
import 'package:red_point/pages/wall_page.dart';

import '../theme.dart';

class SearchPage extends StatefulWidget {
  @override
  State createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> implements SearchPageViewContract {

  List<Wall> _wallResults;
  List<R.Route> _routeResults;
  SearchPagePresenter _presenter;
  Filter _filter;

  _SearchPageState() {
    _presenter = SearchPagePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _wallResults = List();
    _routeResults = List();
    Set<String> types = Set();
    types.addAll(Types);
    _filter = Filter(
      minGrade: 0,
      maxGrade: Grade.INTS[Grade.MAX_YDS],
      term: '',
      types: types,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: _searchInput(),
          centerTitle: false,
          actions: [
            IconButton(
              icon: Icon(Icons.equalizer),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext ctx) {
                    return FilterDialog(_filter);
                  }
                  ).then((f) {
                    if (f == null) return;
                    Filter _f = f;
                    setState(() {
                      // overwrite term from existing filter
                      _f.term = _filter.term;
                      _filter = f;
                    });
                    _presenter.search(_filter);
                });
              },
            ),
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
          onChanged: (String term) {
            if (term.isEmpty) {
              setState(() {
                _routeResults = List();
                _wallResults = List();
              });
            } else
              setState(() {
                _filter.term = term;
              });
              _presenter.search(_filter);
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

  @override
  void onSortRoutesComplete(List<R.Route> routes) {
    setState(() {
      _routeResults = routes;
    });
  }
}

class FilterDialog extends StatefulWidget {

  final Filter f;

  FilterDialog(this.f);

  @override
  State createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {

  // TODO replace with a Filter
  String _minGrade;
  String _maxGrade;
  Set<String> _types;

  @override
  void initState() {
    super.initState();
    // TODO this could be better
    _minGrade = Grade.INTS.keys.firstWhere((v) => Grade.INTS[v] == widget.f.minGrade);
    _maxGrade = Grade.INTS.keys.firstWhere((v) => Grade.INTS[v] == widget.f.maxGrade);
    _types = Set<String>();
    _types.addAll(widget.f.types);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter', style: TextStyle(color: textDark)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<String>(
                value: _minGrade,
                items: Grade.SORT_INTS.keys
                    .map((g) => DropdownMenuItem<String>(
                          value: g,
                          child: Text(g),
                        ))
                    .toList(),
                onChanged: (g) {
                  setState(() {
                    _minGrade = g;
                  });
                },
              ),
              Text('to'),
              DropdownButton<String>(
                value: _maxGrade,
                items: Grade.SORT_INTS.keys
                    .map((g) => DropdownMenuItem<String>(
                          value: g,
                          child: Text(g),
                        ))
                    .toList(),
                onChanged: (g) {
                  setState(() {
                    _maxGrade = g;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 14.0,
            ),
            child: Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 6.0,
              children: [
                // TODO clean this up + fewer magic strings
                ToggleChip(
                  label: 'Sport',
                  active: _types.contains('Sport'),
                  onPressed: () {
                    String key = 'Sport';
                    setState(() {
                      if (_types.contains(key)) _types.remove(key);
                      else _types.add(key);
                    });
                  },
                ),
                ToggleChip(
                  label: 'Trad',
                  active: _types.contains('Trad'),
                  onPressed: () {
                    String key = 'Trad';
                    setState(() {
                      if (_types.contains(key)) _types.remove(key);
                      else _types.add(key);
                    });
                  },
                ),
                ToggleChip(
                  label: 'Other',
                  active: _types.contains('Other'),
                  onPressed: () {
                    String key = 'Other';
                    setState(() {
                      if (_types.contains(key)) _types.remove(key);
                      else _types.add(key);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        FlatButton(
          child: Text('APPLY', style: TextStyle(color: red)),
          onPressed: () {
            Navigator.of(context).pop(Filter(
              minGrade: Grade.INTS[_minGrade],
              maxGrade: Grade.INTS[_maxGrade],
              types: _types,
            ));
          },
        )
      ],
    );
  }
}

class ToggleChip extends StatelessWidget {

  final String label;
  final Function onPressed;
  final bool active;

  ToggleChip({this.label,this.onPressed, this.active});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      backgroundColor: (active) ? red : Colors.blueGrey[50],
      labelStyle: TextStyle(color: (active) ? Colors.white : textDark),
      label: Text(label),
      onPressed: onPressed,
    );
  }
}
