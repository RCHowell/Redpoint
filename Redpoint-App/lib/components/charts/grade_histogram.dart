import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:red_point/models/route.dart' as R;
import 'package:red_point/models/grade.dart';

class GradeHistogram extends StatelessWidget {
  final List<R.Route> _routes;
  final bool detailed;

  GradeHistogram(this._routes, {this.detailed = false});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color themeRed = theme.accentColor;
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

    List<charts.Series<GradeCount, String>> seriesList = [
      charts.Series<GradeCount, String>(
        id: 'Sport',
        colorFn: (_, __) => red,
        domainFn: (GradeCount gc, _) => gc.grade,
        measureFn: (GradeCount gc, _) => gc.count,
        data: _freqList('Sport'),
        labelAccessorFn: (GradeCount gc, _) => gc.count.toString(),
      ),
      charts.Series<GradeCount, String>(
        id: 'Trad',
        colorFn: (_, __) => blueGrey,
        domainFn: (GradeCount gc, _) => gc.grade,
        measureFn: (GradeCount gc, _) => gc.count,
        data: _freqList('Trad'),
        labelAccessorFn: (GradeCount gc, _) => gc.count.toString(),
      ),
    ];

    return charts.BarChart(
      seriesList,
      layoutConfig: charts.LayoutConfig(
        topMarginSpec: charts.MarginSpec.fixedPixel(0),
        rightMarginSpec: charts.MarginSpec.defaultSpec,
        leftMarginSpec: charts.MarginSpec.defaultSpec,
        bottomMarginSpec: charts.MarginSpec.defaultSpec,
      ),
      animate: true,
      defaultInteractions: false,
      animationDuration: Duration(milliseconds: 500),
      barGroupingType: charts.BarGroupingType.stacked,
      primaryMeasureAxis: (detailed)
          ? charts.NumericAxisSpec(
              renderSpec: charts.GridlineRendererSpec<num>())
          : charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec<num>()),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec<String>(
          tickLengthPx: 0,
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
            fontFamily: theme.textTheme.body1.fontFamily,
            color: charts.MaterialPalette.gray.shade400,
          ),
        ),
        showAxisLine: false,
      ),
    );
  }

  List<GradeCount> _freqList(String type) {
    // Keep track of freqs for the most important grades
    Map<String, num> freqs = {
      "<": 0,
      "5.9": 0,
      "5.10": 0,
      "5.11": 0,
      "5.12": 0,
      "5.13": 0,
      "5.14": 0,
    };

    // Counting how many times each grade int appears
    for (int i = 0; i < _routes.length; i += 1) {
      R.Route route = _routes[i];
      if (route.type != type) continue;
      int g = route.grade.gradeInt;
      if (g < 11) {
        freqs["<"] += 1;
      } else if (11 <= g && g <= 13) {
        freqs["5.9"] += 1;
      } else if (14 <= g && g <= 20) {
        freqs["5.10"] += 1;
      } else if (21 <= g && g <= 27) {
        freqs["5.11"] += 1;
      } else if (28 <= g && g <= 34) {
        freqs["5.12"] += 1;
      } else if (35 <= g && g <= 41) {
        freqs["5.13"] += 1;
      } else if (42 <= g && g <= 48) {
        freqs["5.14"] += 1;
      }
    }

    // Convert to list of elements to be graphed
    List<GradeCount> list = List();
    freqs.forEach((grade, count) => list.add(GradeCount(grade, count)));
    return list;
  }
}

class GradeCount {
  final String grade;
  final num count;

  GradeCount(this.grade, this.count);
}
