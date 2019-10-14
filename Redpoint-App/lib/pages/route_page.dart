import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:red_point/models/route.dart' as R;
import 'package:red_point/components/charts/donut_pie_chart.dart';
import 'package:red_point/components/route/star_list.dart';
import 'package:photo_view/photo_view.dart';
import 'package:red_point/presenters/route_page_presenter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:red_point/components/cache_image_provider.dart';
import 'package:red_point/components/cache_image.dart';

class RoutePage extends StatefulWidget {
  final String _wall;
  final R.Route _route;

  RoutePage(this._route, this._wall);

  @override
  State<StatefulWidget> createState() => _RoutePageState(_route, _wall);
}

class _RoutePageState extends State<RoutePage>
    implements RoutePageViewContract {
  RoutePagePresenter _presenter;
  String _wall;
  R.Route _route;

  _RoutePageState(this._route, this._wall) {
    _presenter = RoutePagePresenter(this);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(_wall),
            pinned: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.link),
                onPressed: () async {
                  if (await canLaunch(_route.url))
                    await launch(_route.url);
                  else
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Bad url')));
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _header(),
              _info(),
              _location(),
            ]),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              children: _images(),
            ),
          )
        ],
      ),
    );
  }

  Widget _location() {
    return ListTile(
      title: Text('About'),
      subtitle: Text(_route.location),
    );
  }

  List<Widget> _images() => _route.images
      .map((String imgUrl) => GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HeroPhotoViewWrapper(
                          imageProvider: CacheImageProvider(imgUrl),
                          tag: imgUrl,
                        ),
                  ));
            },
            child: Hero(
              tag: imgUrl,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),

                ),
                child: CacheImage(
                  url: imgUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ))
      .toList();

  Widget _header() {
    ThemeData theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(top: 12.0),
      child: ListTile(
        title: Text(
          _route.name,
          style: theme.textTheme.subhead.copyWith(
            fontSize: 24.0,
          ),
        ),
        trailing: Chip(
          label: Text(
            _route.type,
            style: theme.textTheme.body1.copyWith(
              color: _getTypeTextColor(),
            ),
          ),
          backgroundColor: _getTypeBackgroundColor(theme),
        ),
      ),
    );
  }

  Widget _info() {
    ThemeData theme = Theme.of(context);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  _route.grade.yds,
                  textAlign: TextAlign.right,
                  style: theme.textTheme.subhead.copyWith(
                    fontSize: 40.0,
                  ),
                ),
                Text(
                  _route.length.toString() + ' feet',
                  textAlign: TextAlign.right,
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  alignment: Alignment(0.0, 0.0),
                  children: <Widget>[
                    SizedBox(
                      height: 130.0,
                      child: DonutPieChart(_route.stars, animate: false),
                    ),
                    Text(_route.stars.toString()),
                  ],
                ),
                Row(
                  children: StarList.get(_route.stars, context),
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeTextColor() {
    if (_route.type == 'Sport') return Colors.white;
    if (_route.type == 'Trad') return Colors.blueGrey[100];
    return Colors.blueGrey[500];
  }

  Color _getTypeBackgroundColor(ThemeData theme) {
    if (_route.type == 'Sport') return theme.primaryColor;
    if (_route.type == 'Trad') return Colors.blueGrey[500];
    return Colors.blueGrey[100];
  }
}

class HeroPhotoViewWrapper extends StatelessWidget {
  final String tag;
  final ImageProvider imageProvider;
  final Widget loadingChild;
  final Color backgroundColor;
  final dynamic minScale;
  final dynamic maxScale;

  const HeroPhotoViewWrapper(
      {this.imageProvider,
      this.tag,
      this.loadingChild,
      this.backgroundColor,
      this.minScale,
      this.maxScale});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoView(
          imageProvider: imageProvider,
          loadingChild: loadingChild,
          backgroundColor: backgroundColor,
          minScale: minScale,
          maxScale: maxScale,
          heroTag: tag,
        ));
  }
}
