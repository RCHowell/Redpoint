import 'package:red_point/models/route.dart';
import 'package:red_point/repositories/sqlite_route_repository.dart';

abstract class TickPageViewContract {
  void onUpdateRoutesComplete(List<Route> routes);
}

class TickPagePresenter {

  TickPageViewContract _view;
  RouteRepository _routeRepo;
  RouteSortingChoice _lastChoice;

  TickPagePresenter(this._view) {
    this._routeRepo = SQLiteRouteRepository();
    _lastChoice = RouteSortingChoice.alpha;
  }

  void getRoutes() {
    assert (_view != null);
    _routeRepo.getTicks().then((List<Route> routes) {
      Route.sort(routes, _lastChoice);
      print(routes);
      _view.onUpdateRoutesComplete(routes);
    });
  }

  void sortRoutes(List<Route> routes, RouteSortingChoice choice) {
    assert (_view != null);
    _lastChoice = choice;
    Route.sort(routes, choice);
    _view.onUpdateRoutesComplete(routes);
  }
}
