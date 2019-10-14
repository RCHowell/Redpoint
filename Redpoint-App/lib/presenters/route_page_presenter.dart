import 'package:red_point/models/route.dart';
import 'package:red_point/repositories/sqlite_route_repository.dart';

abstract class RoutePageViewContract {
}

/// Presenter for a [RoutePage]
/// 
/// This class communicates with a [RouteRepository] and controls a [RoutePage].
class RoutePagePresenter {

  RoutePageViewContract _view;
  RouteRepository _repository;

  RoutePagePresenter(this._view) {
    this._repository = new SQLiteRouteRepository();
  }

}
