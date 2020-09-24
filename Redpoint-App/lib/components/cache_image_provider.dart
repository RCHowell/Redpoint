import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:red_point/repositories/image_repository.dart';
import 'dart:ui' as ui show instantiateImageCodec, Codec;


class CacheImageProvider extends ImageProvider<String> {

  String _url;
  ImageRepository _repo;

  CacheImageProvider(this._url) {
    _repo = ImageRepository();
  }

  @override
  ImageStreamCompleter load(String _url, DecoderCallback decode) {
      return MultiFrameImageStreamCompleter(
          codec: _loadAsync(),
          scale: 1.0,
      );
  }

  Future<ui.Codec> _loadAsync() async {
    List bytes = await _repo.get(_url);
    if (bytes.length == 0)
      return null;
    return await ui.instantiateImageCodec(bytes);
  }

  @override
  Future<String> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(_url);
  }

  // @override
  // Future<CacheImageProvider> obtainKey(ImageConfiguration configuration) {
  //   configuration.
  //   return SynchronousFuture<CacheImageProvider>(this);
  // }


}