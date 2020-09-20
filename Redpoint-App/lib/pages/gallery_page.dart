import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:red_point/components/cache_image_provider.dart';

class GalleryPage extends StatelessWidget {
  final List<String> imageUrls;

  GalleryPage(this.imageUrls);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: imageUrls.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: TabBarView(
          children: imageUrls.map((url) => Container(
            child: PhotoView(
               imageProvider: CacheImageProvider(url),
            ),
          )).toList(),
        ),
      ),
    );
  }
}
