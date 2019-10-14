import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:red_point/models/route.dart' as R;
import 'package:red_point/models/grade.dart';

class GradeHistogramDetailed extends StatelessWidget {
  final List<R.Route> _routes;
  final bool detailed;

  GradeHistogramDetailed(this._routes, {this.detailed = false});

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
//        labelAccessorFn: (GradeCount gc, _) => gc.count.toString(),
      ),
      charts.Series<GradeCount, String>(
        id: 'Trad',
        colorFn: (_, __) => blueGrey,
        domainFn: (GradeCount gc, _) => gc.grade,
        measureFn: (GradeCount gc, _) => gc.count,
        data: _freqList('Trad'),
      ),
    ];

    return charts.BarChart(
      seriesList,
      animate: true,
      defaultInteractions: false,
      animationDuration: Duration(milliseconds: 500),
      barGroupingType: charts.BarGroupingType.stacked,
      primaryMeasureAxis: charts.NumericAxisSpec(
        showAxisLine: false,
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          dataIsInWholeNumbers: true,
          desiredTickCount: 5,
        ),
      ),
      domainAxis: charts.OrdinalAxisSpec(
        tickProviderSpec: charts.StaticOrdinalTickProviderSpec([
          charts.TickSpec('<', label: '<'),
          charts.TickSpec('5.10a', label: '5.10'),
          charts.TickSpec('5.11a', label: '5.11'),
          charts.TickSpec('5.12a', label: '5.12'),
          charts.TickSpec('5.13a', label: '5.13'),
          charts.TickSpec('>', label: '5.14+'),
        ]),
        renderSpec: charts.SmallTickRendererSpec<String>(
          tickLengthPx: 3,
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
      "5.10a": 0,
      "5.10b": 0,
      "5.10c": 0,
      "5.10d": 0,
      "5.11a": 0,
      "5.11b": 0,
      "5.11c": 0,
      "5.11d": 0,
      "5.12a": 0,
      "5.12b": 0,
      "5.12c": 0,
      "5.12d": 0,
      "5.13a": 0,
      "5.13b": 0,
      "5.13c": 0,
      "5.13d": 0,
      ">": 0,
    };

    // Counting how many times each grade int appears
    for (int i = 0; i < _routes.length; i += 1) {
      R.Route route = _routes[i];
      if (route.type != type) continue;
      int g = route.grade.gradeInt;
      if (g <= Grade.INTS['5.8']) {
        freqs["<"] += 1;
      } else if (Grade.INTS['5.9-'] <= g && g <= Grade.INTS['5.9+']) {
        freqs["5.9"] += 1;
      } else if (Grade.INTS['5.10-'] <= g && g <= Grade.INTS['5.10a']) {
        freqs["5.10a"] += 1;
      } else if (Grade.INTS['5.10b'] == g) {
        freqs["5.10b"] += 1;
      } else if (Grade.INTS['5.10c'] == g) {
        freqs["5.10c"] += 1;
      } else if (Grade.INTS['5.10d'] <= g && g <= Grade.INTS['5.10+']) {
        freqs["5.10d"] += 1;
      } else if (Grade.INTS['5.11-'] <= g && g <= Grade.INTS['5.11a']) {
        freqs["5.11a"] += 1;
      } else if (Grade.INTS['5.11b'] == g) {
        freqs["5.11b"] += 1;
      } else if (Grade.INTS['5.11c'] == g) {
        freqs["5.11c"] += 1;
      } else if (Grade.INTS['5.11d'] <= g && g <= Grade.INTS['5.11+']) {
        freqs["5.11d"] += 1;
      } else if (Grade.INTS['5.12-'] <= g && g <= Grade.INTS['5.12a']) {
        freqs["5.12a"] += 1;
      } else if (Grade.INTS['5.12b'] == g) {
        freqs["5.12b"] += 1;
      } else if (Grade.INTS['5.12c'] == g) {
        freqs["5.12c"] += 1;
      } else if (Grade.INTS['5.12d'] <= g && g <= Grade.INTS['5.12+']) {
        freqs["5.12d"] += 1;
      } else if (Grade.INTS['5.13-'] <= g && g <= Grade.INTS['5.13a']) {
        freqs["5.13a"] += 1;
      } else if (Grade.INTS['5.13b'] == g) {
        freqs["5.13b"] += 1;
      } else if (Grade.INTS['5.13c'] == g) {
        freqs["5.13c"] += 1;
      } else if (Grade.INTS['5.13d'] <= g && g <= Grade.INTS['5.13+']) {
        freqs["5.13d"] += 1;
      } else if (Grade.INTS['5.14-'] <= g && g <= Grade.INTS['5.15a']) {
        freqs['>'] += 1;
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
