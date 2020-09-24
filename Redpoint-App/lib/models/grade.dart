class Grade {

  static const ANY = const Grade(
    yds: 'Any',
    gradeInt: 0,
  );

  static const MIN_YDS = '5.1';
  static const MAX_YDS = '5.15a';

  static const MIN_V = 'V0';
  static const MAX_V = 'V15';

  // Grade reference for mapping to ints
  static const INTS = {
    "5.1": 0,
    "5.2": 1,
    "5.3": 2,
    "5.4": 3,
    "5.5": 4,
    "5.6": 5,
    "5.7": 6,
    // "5.7+": 7,
    // "5.8-": 8,
    "5.8": 9,
    // "5.8+": 10,
    // "5.9-": 11,
    "5.9": 12,
    // "5.9+": 13,
    // "5.10-": 14,
    // "5.10": 15,
    "5.10a": 16,
    "5.10b": 17,
    "5.10c": 18,
    "5.10d": 19,
    // "5.10+": 20,
    // "5.11-": 21,
    // "5.11": 22,
    "5.11a": 23,
    "5.11b": 24,
    "5.11c": 25,
    "5.11d": 26,
    // "5.11+": 27,
    // "5.12-": 28,
    // "5.12": 29,
    "5.12a": 30,
    "5.12b": 31,
    "5.12c": 32,
    "5.12d": 33,
    // "5.12+": 34,
    // "5.13-": 35,
    // "5.13": 36,
    "5.13a": 37,
    "5.13b": 38,
    "5.13c": 39,
    "5.13d": 40,
    // "5.13+": 41,
    // "5.14-": 42,
    // "5.14": 43,
    "5.14a": 44,
    "5.14b": 45,
    "5.14c": 46,
    "5.14d": 47,
    // "5.14+": 48,
    "5.15a": 49,
    "V0": 1050,
    "V1": 1051,
    "V2": 1052,
    "V3": 1053,
    "V4": 1054,
    "V5": 1055,
    "V6": 1056,
    "V7": 1057,
    "V8": 1058,
    "V9": 1059,
    "V10": 1060,
    "V11": 1061,
    "V12": 1062,
    "V13": 1063,
    "V14": 1064,
    "V15": 1065
  };
  
  final String yds;
  final int gradeInt;

  const Grade({
    this.yds = 'Any',
    this.gradeInt = 0,
  });

  Grade.fromMap(Map map) :
    yds = map['grade'],
    gradeInt = map['grade_int'];

  @override
  String toString() {
    return '''
{
  'yds': $yds,
  'gradeInt': $gradeInt
}
    ''';
  }
}
