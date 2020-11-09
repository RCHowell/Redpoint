import 'package:red_point/models/wall.dart';
import 'package:red_point/repositories/sqlite_wall_repository.dart';
import 'package:red_point/repositories/sqlite_route_repository.dart';
import 'package:red_point/models/route.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class WallPageViewContract {
  int id;
  void onGetWallComplete(Wall wall);
  void onGetRoutesComplete(List<Route> routes);
  void onToggleBookMarkComplete(bool isBookmarked);
  void onSetTickComplete(int index);
}

class WallPagePresenter {

  final WallPageViewContract _view;
  WallRepository _wallRepository;
  RouteRepository _routeRepository;

  WallPagePresenter(this._view) {
    _wallRepository = SQLiteWallRepository();
    _routeRepository = SQLiteRouteRepository();
  }

  void getWall() {
    assert (_view != null);
    _wallRepository.get(_view.id).then((wall) {
      _view.onGetWallComplete(wall);
    });
  }

  void getRoutes() {
    assert (_view != null);
    _routeRepository.getRoutesForWall(_view.id).then((List<Route> routes) {
      // Default sort left to right
      routes.sort((a, b) => a.number.compareTo(b.number));
      _view.onGetRoutesComplete(routes);
    });
  }

  void toggleBookmark() {
    assert (_view != null);
    _wallRepository.toggleBookmark(_view.id).then(_view.onToggleBookMarkComplete);
  }

  void sortRoutes(List<Route> routes, RouteSortingChoice choice) {
    assert (_view != null);
    Route.sort(routes, choice);
    _view.onGetRoutesComplete(routes);
  }

  void setTick(int index, Route route) {
    assert (_view != null);
    _routeRepository.setTick(route.id, !route.tick)
        .then((_) => _view.onSetTickComplete(index));
  }

}
