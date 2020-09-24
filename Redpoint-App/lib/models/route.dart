import 'dart:async';
import 'package:flutter/material.dart';
import 'package:red_point/components/route_sorting_popup_menu.dart';
import 'package:red_point/models/grade.dart';

import 'filter.dart';

enum RouteSortingChoice { alpha, l2r, r2l, stars, grade }
enum RouteType { sport, trad, tr, boulder }

const Set<String> Types = {'Sport', 'Trad', 'Other'};

const Map<RouteSortingChoice, String> choiceHints = {
  RouteSortingChoice.alpha: "Alpha",
  RouteSortingChoice.grade: "Grade",
  RouteSortingChoice.stars: "Stars",
  RouteSortingChoice.l2r: "Left to Right",
  RouteSortingChoice.r2l: "Right to Left",
};

const Map<RouteSortingChoice, IconData> choiceIcons = {
  RouteSortingChoice.alpha: Icons.sort_by_alpha,
  RouteSortingChoice.grade: Icons.poll,
  RouteSortingChoice.stars: Icons.star,
  RouteSortingChoice.l2r:  Icons.chevron_right,
  RouteSortingChoice.r2l: Icons.chevron_left,
};

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

  static sort(List<Route> routes, RouteSortingChoice choice) {
    if (choice == RouteSortingChoice.alpha) routes.sort((a, b) => a.name.compareTo(b.name));
    if (choice == RouteSortingChoice.l2r) routes.sort((a, b) => a.number.compareTo(b.number));
    if (choice == RouteSortingChoice.r2l) routes.sort((a, b) => b.number.compareTo(a.number));
    if (choice == RouteSortingChoice.stars) routes.sort((a, b) => b.stars.compareTo(a.stars));
    if (choice == RouteSortingChoice.grade) routes.sort((a, b) => a.grade.gradeInt.compareTo(b.grade.gradeInt));
  }
}

abstract class RouteRepository {
  /// Given some [Route.id], get that [Route]'s information.
  Future<Route> get(int id);
  Future<List<Route>> getRoutesForWall(int id);
  Future<List<Route>> search(Filter f);
}
