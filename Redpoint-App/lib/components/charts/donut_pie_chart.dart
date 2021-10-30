/// Donut chart example. This is a simple pie chart with a hole in the middle.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class DonutPieChart extends StatelessWidget {

  final num stars;
  final bool animate;

  DonutPieChart(this.stars, {this.animate});

  @override
  Widget build(BuildContext context) {

    ThemeData theme = Theme.of(context);
    Color themeRed = theme.primaryColor;
    charts.Color red = charts.Color(
      r: themeRed.red,
      g: themeRed.green,
      b: themeRed.blue,
      a: themeRed.alpha,
    );
    Color themeBlueGrey = Colors.blueGrey[50];
    charts.Color blueGrey = charts.Color(
      r: themeBlueGrey.red,
      g: themeBlueGrey.green,
      b: themeBlueGrey.blue,
      a: themeBlueGrey.alpha,
    );

    num starVal = stars;
    if (starVal >= 5) starVal -= 0.01;
    List<StarCount> data = [
      StarCount(1, starVal),
      StarCount(0, 5 - starVal),
    ];

    List<charts.Series<StarCount, num>> series = [
      charts.Series<StarCount, int>(
        id: 'Stars',
        domainFn: (StarCount stars, _) => stars.isStars,
        measureFn: (StarCount stars, _) => stars.stars,
        data: data,
        colorFn: (StarCount c, __) {
          if (c.isStars == 1) return red;
          return blueGrey;
        },
      ),
    ];

    return charts.PieChart(
        series,
        animate: animate,

        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        defaultRenderer: charts.ArcRendererConfig(arcWidth: 20));
  }
}

/// Sample linear data type.
class StarCount {
  // 1 for the star count
  // 0 for the complement
  final num isStars;
  final num stars;

  StarCount(this.isStars, this.stars);
}