import 'package:red_point/models/grade.dart';
import 'package:red_point/models/route.dart';

class Filter {
  String term;
  int minGrade;
  int maxGrade;
  Set<String> types;

  Filter({this.term, this.minGrade, this.maxGrade, this.types});

}
