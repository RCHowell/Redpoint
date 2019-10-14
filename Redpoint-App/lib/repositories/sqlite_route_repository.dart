import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
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
  Future<List<Route>> search(String substring) async {
    if (!initialized) await this._initialize();
    List<Map> results = await this.db.rawQuery('''
      SELECT r.*, w.name AS wall
      FROM walls_to_routes AS wr
      JOIN walls AS w ON w.wall_id = wr.wall_id
      JOIN routes AS r ON r.route_id = wr.route_id
      WHERE r.name LIKE "%$substring%" LIMIT 50
    ''');
    return results.map((Map result) {
      Route route = Route.fromMap(result);
      route.wall = result['wall'];
      return route;
    }).toList();
  }

}
