import 'package:flutter/material.dart';
import 'package:red_point/models/wall.dart';
import 'package:red_point/models/route.dart' as R;
import 'package:red_point/repositories/image_repository.dart';

class DownloadImagesPage extends StatefulWidget {
  final Wall _wall;

  DownloadImagesPage(this._wall);

  @override
  State createState() => _DownloadImagesPageState();
}

class _DownloadImagesPageState extends State<DownloadImagesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ImageRepository _repo;
  List<String> _images;
  bool _inProgress;
  double _progress;

  @override
  void initState() {
    super.initState();
    _repo = ImageRepository();
    _images = List();
    _inProgress = false;
    _progress = 0.0;
    widget._wall.routes.forEach((R.Route route) {
      route.images.forEach(_images.add);
    });
  }

  void _toggleProgress() {
    setState(() {
      _inProgress = !_inProgress;
    });
  }

  void _complete(String message) {
    _toggleProgress();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void _downloadImages() {
    _toggleProgress();
    Future.forEach(_images, (_image) async {
      try {
        await _repo.saveImage(_image);
        setState(() { _progress += 1 / _images.length; });
      } catch (error) {
        print(error);
      }
    }).then((_) {
      _complete('All images downloaded');
    }).catchError((err) {
      _complete('Some images failed to download');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget._wall.name),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 24.0),
            child: Text('There are ${_images.length} Images',
                style: Theme.of(context).textTheme.subhead,
                textAlign: TextAlign.center),
          ),
          Container(
            height: 40.0,
            margin: const EdgeInsets.all(14.0),
            child: (_inProgress)
                ? LinearProgressIndicator(
                    value: _progress,
                  )
                : FlatButton(
                    child: Text("Let's go"),
                    onPressed: _downloadImages,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'Do not exit once in progress',
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            child: Text(
              'Images may take up a lot of storage space',
              style: Theme.of(context).textTheme.body1.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
