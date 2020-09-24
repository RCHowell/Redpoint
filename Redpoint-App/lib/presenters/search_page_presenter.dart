import 'package:red_point/models/filter.dart';
import 'package:red_point/models/route.dart';
import 'package:red_point/models/wall.dart';
import 'package:red_point/repositories/sqlite_route_repository.dart';
import 'package:red_point/repositories/sqlite_wall_repository.dart';

abstract class SearchPageViewContract {
  void onSearchComplete(List<Route> routes, List<Wall> walls);
  void onSortRoutesComplete(List<Route> routes);
}

class SearchPagePresenter {

  SearchPageViewContract _view;
  WallRepository _wallRepo;
  RouteRepository _routeRepo;
  RouteSortingChoice _lastChoice;

  SearchPagePresenter(this._view) {
    this._routeRepo = SQLiteRouteRepository();
    this._wallRepo = SQLiteWallRepository();
    _lastChoice = RouteSortingChoice.alpha;
  }

  void search(Filter f) async {
    List<Route> routes = await _routeRepo.search(f);
    List<Wall> walls = await _wallRepo.search(f.term);
    Route.sort(routes, _lastChoice);
    _view.onSearchComplete(routes, walls);
  }

  void sortRoutes(List<Route> routes, RouteSortingChoice choice) {
    assert (_view != null);
    _lastChoice = choice;
    Route.sort(routes, choice);
    _view.onSortRoutesComplete(routes);
  }
}
