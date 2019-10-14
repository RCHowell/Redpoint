import 'dart:async';
import 'package:red_point/models/grade.dart';

enum RouteSortingChoices { alpha, l2r, r2l, stars, grade }
enum RouteTypes { sport, trad, tr, boulder }

class Route {

  final int id;
  final String url;
  final int number;
  final String type;
  final int length;
  final Grade grade;
  final num stars;
  final List<String> images;
  String name;
  String location;
  String wall;

  Route({
    this.id,
    this.name,
    this.url,
    this.number,
    this.type,
    this.length,
    this.stars,
    this.location,
    this.images,
    this.grade,
  });

  Route.fromMap(Map<String, dynamic> data)
    : this.id = data['id'],
      this.url = data['url'],
      this.number = data['number'],
      this.type = data['type'],
      this.length = data['length'],
      this.grade = Grade.fromMap(data),
      this.stars = data['stars'],
      this.images = (data['images'] != null) ? parseImages(data['images']) : List<String>() {
    this.name = data['name']?.replaceAll('\\', '');
    this.location = data['location']?.replaceAll('\\', '');
  }


  static List<String> parseImages(String str) =>
      str.split(',').where((s) => s != '').toList();


  @override
  String toString() {
    return '''
    {
      id: $id,
      name: $name,
      url: $url,
      type: $type,
      grade: ${grade.toString()},
      stars: $stars,
      images: ${images.toString()}
    }
    ''';
  }
}

abstract class RouteRepository {
  /// Given some [Route.id], get that [Route]'s information.
  Future<Route> get(int id);
  Future<List<Route>> getRoutesForWall(int id);
  Future<List<Route>> search(String prefix);
}
