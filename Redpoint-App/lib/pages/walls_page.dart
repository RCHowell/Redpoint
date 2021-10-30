import 'package:flutter/material.dart';
import 'package:red_point/models/wall.dart';
import 'package:red_point/pages/tick_page.dart';
import 'package:red_point/presenters/walls_page_presenter.dart';
import 'package:red_point/components/wall/wall_tile.dart';
import 'package:red_point/components/wall/wall_list_tile.dart';
import 'package:red_point/pages/wall_page.dart';
import 'package:red_point/pages/search_page.dart';

class WallsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WallsPageState();
}

class _WallsPageState extends State<WallsPage>
    implements WallsPageViewContract {
  WallsPagePresenter _presenter;
  List<Wall> _walls;

  _WallsPageState() {
    _presenter = WallsPagePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _walls = List();
    _presenter.getWalls();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: _searchButton(),
            title: Text(
              'Redpoint',
              style: Theme.of(context).textTheme.headline1.copyWith(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 24.0,
                  ),
            ),
            actions: <Widget>[
              _ticksButton(),
              _sortingPopupMenu(),
            ],
            bottom: TabBar(
              tabs: <Widget>[
                Tab(icon: const Icon(Icons.insert_chart)),
                Tab(icon: const Icon(Icons.bookmark)),
              ],
              indicatorColor: Colors.white,
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              (_walls.length > 0) ? _wallList() : _loading(),
              (_walls.length > 0) ? _bookmarkedList() : _loading(),
            ],
          ),
        ),
      );

  Widget _searchButton() => IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => SearchPage(),
          )).then((_) => _presenter.getWalls());
        },
      );

  Widget _ticksButton() => IconButton(
    icon: Icon(Icons.bar_chart),
    onPressed: () {
      Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => TickPage(),
      )).then((_) => _presenter.getWalls());
    },
  );

  Widget _loading() => Center(child: CircularProgressIndicator());

  Widget _sortingPopupMenu() {
    Color _color = Color.fromRGBO(160, 160, 160, 1.0);
    return PopupMenuButton<WallSortingChoices>(
      icon: Icon(Icons.sort),
      tooltip: 'Sort',
      onSelected: (WallSortingChoices choice) {
        _presenter.sortWalls(_walls, choice);
      },
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<WallSortingChoices>>[
            PopupMenuItem<WallSortingChoices>(
              value: WallSortingChoices.alpha,
              child: ListTile(
                leading: Icon(Icons.sort_by_alpha, color: _color),
                title: Text('Alpha'),
              ),
            ),
            PopupMenuItem<WallSortingChoices>(
              value: WallSortingChoices.size,
              child: ListTile(
                leading: Icon(Icons.sort, color: _color),
                title: Text('Size'),
              ),
            ),
          ],
    );
  }

  ListView _wallList() => ListView.builder(
      itemBuilder: (_, int i) =>
          WallTile(_walls[i], navigateToWall(_walls[i].id)));

  ListView _bookmarkedList() => ListView(
        children: _walls
            .where((wall) => wall.isBookmarked)
            .map((wall) => Column(
                  children: <Widget>[
                    WallListTile(wall, navigateToWall(wall.id)),
                    Divider(
                      height: 2.0,
                    ),
                  ],
                ))
            .toList(),
      );

  @override
  void onGetWallsComplete(List<Wall> walls) {
    setState(() {
      _walls = walls;
    });
  }

  // Curried function to simplify navigating to wall pages
  Function navigateToWall(int id) => () {
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(
          builder: (_) => WallPage(id),
        ))
            .then((_) {
          _presenter.getWalls();
        });
      };
}
