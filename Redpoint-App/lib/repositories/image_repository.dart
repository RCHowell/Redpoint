import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class GetImageError extends Error {
  final Object message;
  GetImageError(this.message);
  String toString() => "Failed to retrieve image";
}

class ImageRepository {

  DefaultCacheManager _cache;
  bool _initialized = false;
  Directory _docs;

  ImageRepository() {
    _initialized = false;
  }

  Future _initialize() async {
    _cache = DefaultCacheManager();
    _initialized = true;
    _docs = await getApplicationDocumentsDirectory();
  }

  Future<Uint8List> get(String url) async {
    if (!_initialized) await _initialize();
    String filename = key(url);
    String path = join(_docs.path, filename);
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // File is not downloaded
      // Retrieve from cache, and put in cache if did not exist
      return _cache
          .getSingleFile(url)
          .then((file) => file.readAsBytes())
          .catchError((e) {
            print("[ERROR] failed to fetch image from cache");
            print(e);
            return Future.value(Uint8List(0));
          });
    } else {
      // File is downloaded. Retrieve its bytes
      print('File served from storage');
      return File(path).readAsBytes();
    }
  }

  String key(String url) => base64Encode(url.codeUnits);

  Future<bool> saveImage(String url) async {
    if (!_initialized) await _initialize();
    String filename = key(url);
    String path = join(_docs.path, filename);
    // Only save a file if it does not exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // Retrieve from cache, and put in cache if did not exist
      try {
        File file = await _cache.getSingleFile(url);
        // Read bytes from the file in the cache
        List<int> bytes = await file.readAsBytes();
        // Write the byte data to application documents
        await File(path).writeAsBytes(bytes);
        return true;
      } catch(e) {
        print(e);
      }
    }
    return false;
  }

}