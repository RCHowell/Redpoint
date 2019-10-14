import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:red_point/pages/loading_page.dart';
import 'package:red_point/pages/walls_page.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool _loaded;

  initState() {
    super.initState();
    _loaded = false;
    _load();
  }

  // Create database in documents from the specified database in assets
  Future _load() async {
    // Construct a file path to copy database to
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "asset_database.db");
    // Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound){
      // Load database from asset and copy
      ByteData data = await rootBundle.load(join('assets', 'db.sqlite3'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Save copied asset to documents
      await File(path).writeAsBytes(bytes);
    }
    setState(() {
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) => (_loaded) ? WallsPage() : LoadingPage();
}
