import 'package:red_point/models/wall.dart';
import 'package:red_point/repositories/sqlite_wall_repository.dart';

abstract class WallsPageViewContract {
  void onGetWallsComplete(List<Wall> walls);
}

class WallsPagePresenter {

  final WallsPageViewContract _view;
  WallRepository _repository;
  List<Wall> _walls;

  WallsPagePresenter(this._view) {
    this._repository = SQLiteWallRepository();
  }

  void getWalls() {
    assert (_view != null);
    _repository.getWalls().then((walls) {
      _view.onGetWallsComplete(walls);
      _walls = walls;
    });
  }

  void sortWalls(List<Wall> walls, choice) {
    if (choice == WallSortingChoices.alpha) _walls.sort((a, b) => a.name.compareTo(b.name));
    else walls.sort((a, b) => b.routes.length.compareTo(a.routes.length));
    _view.onGetWallsComplete(walls);
  }
}
