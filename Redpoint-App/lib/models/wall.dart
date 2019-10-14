import 'dart:async';
import 'package:red_point/models/route.dart';

class Wall {

  static String bookmarkKey = 'WALL_BOOKMARKS';
  final int id;
  final String url;
  String name;
  String directions;
  List<Route> routes;
  bool isBookmarked;

  Wall({
    this.id,
    this.name,
    this.url,
    this.directions,
    this.routes,
    this.isBookmarked,
  });

  Wall.fromMap(Map<String, dynamic> data, this.routes)
    : this.id = data['wall_id'],
      this.url = data['url'] {
    this.name = data['name']?.replaceAll('\\', '');
    this.directions = data['directions']?.replaceAll('\\', '');
  }

  @override
  String toString() {
    return '''
{
  id: $id,
  name: $name,
  url: $url,
  directions: $directions,
  routes: ${routes.toString()}
}
    ''';
  }

}

/// Abstract class for subclasses intending to be a [Wall] repository.
abstract class WallRepository {
  /// Given some [Wall.id], get that [Wall]'s information.
  Future<Wall> get(int id);
  Future<List<Wall>> getWalls();
  Future<bool> toggleBookmark(int id);
  Future<List<Wall>> search(String substring);
}

enum WallSortingChoices { alpha, size }
