import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:red_point/models/filter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:red_point/models/route.dart';
import 'package:path_provider/path_provider.dart';

// Models
import 'package:red_point/models/grade.dart';

/// A [RouteRepository] which gets data from SQLite
class SQLiteRouteRepository extends RouteRepository {
  Database db;
  bool initialized;

  SQLiteRouteRepository() {
    initialized = false;
  }

  Future _initialize() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'asset_database.db');
    this.db = await openDatabase(databasePath);
    initialized = true;
  }

  Future<Route> get(int id) async {
    if (!initialized) await this._initialize();
    String query = '''
    SELECT R.*
    FROM routes R
    WHERE route_id = $id
    ''';
    List<Map> results = await this.db.rawQuery(query);
    return new Route.fromMap(results.first);
  }

  @override
  Future<List<Route>> getRoutesForWall(int id) async {
    if (!initialized) await this._initialize();
    String query = '''
       SELECT r.*
       FROM walls_to_routes AS wr
       JOIN routes AS r ON r.route_id = wr.route_id
       WHERE wr.wall_id = $id
    ''';
    List<Map> results = await this.db.rawQuery(query);
    return results.map((Map route) => Route.fromMap(route)).toList();
  }

  @override
  Future<List<Route>> search(Filter f) async {
    if (!initialized) await this._initialize();

    List<String> predicates = List();
    if (f.term != "") predicates.add('r.name LIKE "%${f.term}%"');
    if (f.types.isNotEmpty)
      predicates.add('r.type IN ("${f.types.join('","')}")');
    predicates.add('r.grade_int >= ${f.minGrade}');
    predicates.add('r.grade_int <= ${f.maxGrade}');

    String query = '''
      SELECT r.*, w.name AS wall
      FROM walls_to_routes AS wr
      JOIN walls AS w ON w.wall_id = wr.wall_id
      JOIN routes AS r ON r.route_id = wr.route_id
      WHERE ${predicates.join(" AND ")}
      LIMIT 500
    ''';
    List<Map> results = await this.db.rawQuery(query);
    return results.map((Map result) {
      Route route = Route.fromMap(result);
      route.wall = result['wall'];
      return route;
    }).toList();
  }

  @override
  Future setTick(int id, bool tick) async {
    if (!initialized) await this._initialize();
    int n = await this.db.rawUpdate(
        'UPDATE routes SET tick = ? WHERE route_id = ?', [(tick) ? 1 : 0, id]);
    print('Ticked $n routes: $id with value $bool');
  }

  @override
  Future<List<Route>> getTicks() async {
    if (!initialized) await this._initialize();
    String query = '''
      SELECT r.*, w.name AS wall
      FROM walls_to_routes AS wr
      JOIN walls AS w ON w.wall_id = wr.wall_id
      JOIN routes AS r ON r.route_id = wr.route_id
      WHERE tick = 1
    ''';
    List<Map> results = await this.db.rawQuery(query);
    return results.map((Map result) {
      Route route = Route.fromMap(result);
      route.wall = result['wall'];
      return route;
    }).toList();
  }

}
