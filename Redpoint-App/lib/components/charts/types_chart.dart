/// Donut chart example. This is a simple pie chart with a hole in the middle.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:red_point/models/route.dart' as R;
import 'package:flutter/material.dart';

class TypesChart extends StatelessWidget {
  final List<R.Route> _routes;
  final bool animate;

  TypesChart(this._routes, {this.animate});

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
    Color themeBlueGrey = Colors.blueGrey[500];
    charts.Color blueGrey = charts.Color(
      r: themeBlueGrey.red,
      g: themeBlueGrey.green,
      b: themeBlueGrey.blue,
      a: themeBlueGrey.alpha,
    );

    List<TypeCount> data = _getTypeCounts();
    List<charts.Color> colors = charts.MaterialPalette.gray.makeShades(data.length);

    List<charts.Series<TypeCount, String>> series = [
      charts.Series<TypeCount, String>(
        id: 'Types',
        domainFn: (TypeCount tc, _) => tc.type,
        measureFn: (TypeCount tc, _) => tc.count,
        labelAccessorFn: (TypeCount tc, _) => '${tc.count} ${tc.type}',
        data: data,
        colorFn: (TypeCount tc, int i) {
          if (tc.type == 'Sport') return red;
          if (tc.type == 'Trad') return blueGrey;
          return colors[i];
        },
      ),
    ];

    return charts.PieChart(series,
        animate: animate,
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
//        defaultRenderer: charts.ArcRendererConfig(arcWidth: 20));
        defaultInteractions: false,
        defaultRenderer: charts.ArcRendererConfig(arcRendererDecorators: [
          charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.outside)
        ]));
  }

  List<TypeCount> _getTypeCounts() {
    Map<String, int> freqs = {};
    _routes.forEach((route) {
      String type = route.type;
      if (freqs.containsKey(type))
        freqs[type] += 1;
      else
        freqs[type] = 1;
    });
    return freqs.keys.map((type) => TypeCount(type, freqs[type])).toList();
  }
}

/// Sample linear data type.
class TypeCount {
  final String type;
  final num count;

  TypeCount(this.type, this.count);
}
