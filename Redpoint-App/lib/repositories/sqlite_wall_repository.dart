import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:red_point/models/wall.dart';
import 'package:red_point/models/route.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getRoutesQuery = '''
  SELECT w.wall_id, w.name, r.grade, r.grade_int, r.type
  FROM walls_to_routes AS wr
  JOIN walls AS w ON w.wall_id = wr.wall_id
  JOIN routes AS r ON r.route_id = wr.route_id
''';


class SQLiteWallRepository extends WallRepository {

  Database _db;
  bool _initialized;

  SQLiteWallRepository() {
    _initialized = false;
  }

  Future _initialize() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'asset_database.db');
    this._db = await openDatabase(databasePath);
    _initialized = true;
  }

  Future<Wall> get(int id) async {
    if (!_initialized) await this._initialize();
    String query = 'SELECT * FROM walls WHERE wall_id = $id';
    List<Map> results = await this._db.rawQuery(query);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(Wall.bookmarkKey);
    if (bookmarks == null) bookmarks = List();
    Wall wall = Wall.fromMap(results.first, []);
    wall.isBookmarked = bookmarks.contains(wall.id.toString());
    return wall;
  }

  Future<List<Wall>> getWalls() async {
    if (!_initialized) await this._initialize();
    List<Map> data = await this._db.rawQuery(getRoutesQuery);
    Map<int, Wall> walls = Map();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(Wall.bookmarkKey);
    if (bookmarks == null) bookmarks = List();

    data.forEach((entry) {
      int wallId = entry['wall_id'];
      if (walls.containsKey(wallId)) {
        Wall wall = walls[wallId];
        wall.routes.add(Route.fromMap(entry));
        walls[wallId] = wall;
      } else {
        Route route = Route.fromMap(entry);
        Wall wall = Wall.fromMap(entry, [route]);
        wall.isBookmarked = bookmarks.contains(wallId.toString());
        walls[wallId] = wall;
      }
    });
    List<Wall> wallList =  walls.values.toList();
    // Sort with largest crags first
    wallList.sort((a, b) => b.routes.length.compareTo(a.routes.length));
    return wallList;
  }

  @override
  Future<bool> toggleBookmark(int id) async {
    String key = id.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> bookmarks = prefs.getStringList(Wall.bookmarkKey)?.toSet();
    if (bookmarks == null) bookmarks = Set();
    if (bookmarks.contains(key)) {
      bookmarks.remove(key);
      prefs.setStringList(Wall.bookmarkKey, bookmarks.toList());
      return false;
    } else {
      bookmarks.add(key);
      prefs.setStringList(Wall.bookmarkKey, bookmarks.toList());
      return true;
    }
  }

  @override
  Future<List<Wall>> search(String substring) async {
    if (!_initialized) await this._initialize();
    String query = '''
      SELECT w.wall_id, w.name,
      (
        SELECT COUNT(r.route_id) FROM routes AS r
        JOIN walls_to_routes AS wr ON wr.route_id = r.route_id
        WHERE wr.wall_id = w.wall_id
      ) routes
      FROM walls AS w 
      WHERE w.name LIKE "%$substring%" LIMIT 50
    ''';
    List<Map> results = await this._db.rawQuery(query);
    return results.map((Map wall) => Wall.fromMap(wall, List(wall['routes']))).toList();
  }
}
