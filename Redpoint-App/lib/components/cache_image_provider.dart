import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:red_point/repositories/image_repository.dart';
import 'dart:ui' as ui show instantiateImageCodec, Codec;


class CacheImageProvider extends ImageProvider<CacheImageProvider> {

  String _url;
  ImageRepository _repo;

  CacheImageProvider(this._url) {
    _repo = ImageRepository();
  }

  @override
  ImageStreamCompleter load(CacheImageProvider _url) {
    return MultiFrameImageStreamCompleter(
        codec: _loadAsync(),
        scale: 1.0,
        informationCollector: (StringBuffer information) {
          information.writeln(_url);
        }
    );
  }

  Future<ui.Codec> _loadAsync() async {
    List bytes = await _repo.get(_url);
    if (bytes.length == 0)
      return null;
    return await ui.instantiateImageCodec(bytes);
  }

  @override
  Future<CacheImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<CacheImageProvider>(this);
  }


}