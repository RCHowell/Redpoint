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

  void sortRoutes(List<Route> routes, RouteSortingChoices choice) {
    assert (_view != null);
    if (choice == RouteSortingChoices.alpha) routes.sort((a, b) => a.name.compareTo(b.name));
    if (choice == RouteSortingChoices.l2r) routes.sort((a, b) => a.number.compareTo(b.number));
    if (choice == RouteSortingChoices.r2l) routes.sort((a, b) => b.number.compareTo(a.number));
    if (choice == RouteSortingChoices.stars) routes.sort((a, b) => b.stars.compareTo(a.stars));
    if (choice == RouteSortingChoices.grade) routes.sort((a, b) => a.grade.gradeInt.compareTo(b.grade.gradeInt));
    _view.onGetRoutesComplete(routes);
  }

}
