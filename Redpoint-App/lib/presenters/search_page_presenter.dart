import 'package:red_point/models/route.dart';
import 'package:red_point/models/wall.dart';
import 'package:red_point/repositories/sqlite_route_repository.dart';
import 'package:red_point/repositories/sqlite_wall_repository.dart';

abstract class SearchPageViewContract {
  void onSearchComplete(List<Route> routes, List<Wall> walls);
}

class SearchPagePresenter {

  SearchPageViewContract _view;
  WallRepository _wallRepo;
  RouteRepository _routeRepo;

  SearchPagePresenter(this._view) {
    this._routeRepo = SQLiteRouteRepository();
    this._wallRepo = SQLiteWallRepository();
  }

  void search(String substring) async {
    List<Route> routes = await _routeRepo.search(substring);
    List<Wall> walls = await _wallRepo.search(substring);
    _view.onSearchComplete(routes, walls);
  }

}
