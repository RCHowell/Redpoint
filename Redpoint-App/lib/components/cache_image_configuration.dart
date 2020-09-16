import 'package:flutter/material.dart';

class CacheImageConfiguration extends ImageConfiguration {
  final String url;

  CacheImageConfiguration(this.url);

  @override
  String toString() => "CacheImageConfiguration{url:$url}";

  @override
  int get hashCode => url.hashCode;

  @override
  bool operator ==(Object other) =>
      other is CacheImageConfiguration && other.url == url;
}
