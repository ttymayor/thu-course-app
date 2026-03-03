class ScheduleCourse {
  final String courseId;
  final String courseCode;
  final String courseName;
  final String location;
  final int dayOfWeek; // 0 = Mon, 1 = Tue, ..., 5 = Sat
  final int startPeriod;
  final int endPeriod;
  final String teacher;

  ScheduleCourse({
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.location,
    required this.dayOfWeek,
    required this.startPeriod,
    required this.endPeriod,
    required this.teacher,
  });

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseCode': courseCode,
      'courseName': courseName,
      'location': location,
      'dayOfWeek': dayOfWeek,
      'startPeriod': startPeriod,
      'endPeriod': endPeriod,
      'teacher': teacher,
    };
  }

  factory ScheduleCourse.fromJson(Map<String, dynamic> json) {
    return ScheduleCourse(
      courseId: json['courseId'] ?? '',
      courseCode: json['courseCode'] ?? '',
      courseName: json['courseName'] ?? '',
      location: json['location'] ?? '',
      dayOfWeek: json['dayOfWeek'] ?? 0,
      startPeriod: json['startPeriod'] ?? 0,
      endPeriod: json['endPeriod'] ?? 0,
      teacher: json['teacher'] ?? '',
    );
  }

  static List<ScheduleCourse> fromCourse(dynamic course) {
    final List<ScheduleCourse> result = [];
    final classTime = course.basicInfo.classTime;

    if (classTime.isEmpty) return result;

    // Split on commas only when followed by a Chinese day character,
    // so "三/3,4[L105]" stays as one entry instead of splitting "3,4".
    final parts = classTime.split(RegExp(r',(?=[一二三四五六])'));

    for (final part in parts) {
      try {
        final slashIndex = part.indexOf('/');
        if (slashIndex == -1) continue;

        final dayStr = part.substring(0, slashIndex).trim();
        final rest = part.substring(slashIndex + 1).trim();

        final bracketStart = rest.indexOf('[');
        final location = bracketStart != -1 && rest.contains(']')
            ? rest.substring(bracketStart + 1, rest.indexOf(']'))
            : '';
        final periodStr =
            (bracketStart != -1 ? rest.substring(0, bracketStart) : rest)
                .trim();

        final dayOfWeek = _parseDay(dayStr);
        if (dayOfWeek == -1) continue;

        final indices = _parsePeriodIndices(periodStr);
        if (indices.isEmpty) continue;

        result.add(ScheduleCourse(
          courseId: course.id,
          courseCode: course.courseCode,
          courseName: course.courseName,
          location: location,
          dayOfWeek: dayOfWeek,
          startPeriod: indices.first,
          endPeriod: indices.last,
          teacher: course.teachers.isNotEmpty ? course.teachers.first : '',
        ));
      } catch (_) {
        continue;
      }
    }

    return result;
  }

  // Returns sorted timetable row indices for period strings like "1", "1-3", "3,4", "A", "B"
  static List<int> _parsePeriodIndices(String periodStr) {
    final List<int> result = [];

    for (final part in periodStr.split(',')) {
      final s = part.trim();
      if (s == 'A') {
        result.add(0);
      } else if (s == 'B') {
        result.add(5);
      } else if (s.contains('-')) {
        final rangeParts = s.split('-');
        final start = int.tryParse(rangeParts[0].trim());
        final end = int.tryParse(rangeParts[1].trim());
        if (start != null && end != null) {
          for (int i = start; i <= end; i++) {
            result.add(_toTableIndex(i));
          }
        }
      } else {
        final num = int.tryParse(s);
        if (num != null) result.add(_toTableIndex(num));
      }
    }

    result.sort();
    return result;
  }

  // Period labels: ['A', '1', '2', '3', '4', 'B', '5', '6', '7', '8', '9', '10', '11', '12', '13']
  // Period numbers 1-4 sit at the same index; 5-13 are shifted +1 by 'B' at index 5
  static int _toTableIndex(int period) {
    if (period <= 4) return period;
    return period + 1;
  }

  static int _parseDay(String day) {
    switch (day) {
      case '一':
        return 0;
      case '二':
        return 1;
      case '三':
        return 2;
      case '四':
        return 3;
      case '五':
        return 4;
      case '六':
        return 5;
      default:
        return -1;
    }
  }
}
