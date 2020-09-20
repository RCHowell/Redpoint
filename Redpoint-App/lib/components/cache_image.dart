import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:red_point/repositories/image_repository.dart';

class CacheImage extends StatefulWidget {
  final Key key;
  final String url;
  final double height;
  final double width;
  final BoxFit fit;
  final Alignment alignment;
  final Color color;
  final BlendMode colorBlendMode;
  final ImageRepeat repeat;

  CacheImage({
    this.key,
    @required this.url,
    this.width,
    this.height,
    this.color,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
  })  : assert(url != null),
        assert(alignment != null),
        assert(repeat != null),
        super(key: key);

  @override
  State createState() => _CacheImageState();
}

class _CacheImageState extends State<CacheImage> {
  ImageRepository _repo;
  Uint8List _bytes;
  bool _error;

  @override
  void initState() {
    super.initState();
    _bytes = Uint8List(0);
    _error = false;
    _repo = ImageRepository();
    _repo.get(widget.url)
        .then(_handleImage)
        .catchError((err) {
          print("Error _repo.get in cache_image");
          print(err);
          _error = true;
        });
  }

  void _handleImage(Uint8List bytes) {
    setState(() {
      if (bytes.isEmpty) _error = true;
      else _bytes = bytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_bytes.isEmpty) return _loading();
    return Image.memory(
      _bytes,
      key: widget.key,
      height: widget.height,
      width: widget.width,
      alignment: widget.alignment,
      fit: widget.fit,
      repeat: widget.repeat,
      color: widget.color,
      colorBlendMode: widget.colorBlendMode,
    );
  }

  Widget _loading() => Container(
      height: widget.height,
      width: widget.width,
      color: Colors.blueGrey[50],
      child: Center(
        child: (_error) ? Icon(Icons.error_outline) : CircularProgressIndicator(),
      ));

}
