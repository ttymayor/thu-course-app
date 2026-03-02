import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course.dart';

class CourseCacheService {
  static const String _versionKey = 'course_version';
  static const String _coursesKey = 'courses_data';
  static const String _countKey = 'courses_count';

  final SharedPreferences _prefs;

  CourseCacheService(this._prefs);

  static Future<CourseCacheService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return CourseCacheService(prefs);
  }

  CourseVersion? getStoredVersion() {
    final versionJson = _prefs.getString(_versionKey);
    if (versionJson == null) return null;
    return CourseVersion.fromJson(jsonDecode(versionJson));
  }

  Future<void> saveVersion(CourseVersion version) async {
    await _prefs.setString(_versionKey, jsonEncode(version.toJson()));
  }

  List<Course>? getStoredCourses() {
    final coursesJson = _prefs.getString(_coursesKey);
    if (coursesJson == null) return null;
    final List<dynamic> list = jsonDecode(coursesJson);
    return list.map((e) => Course.fromJson(e)).toList();
  }

  int getStoredCount() {
    return _prefs.getInt(_countKey) ?? 0;
  }

  Future<void> saveCourses(List<Course> courses, int count) async {
    final coursesJson = jsonEncode(courses.map((e) => {
      'id': e.id,
      'course_code': e.courseCode,
      'course_name': e.courseName,
      'course_description': e.courseDescription,
      'academic_year': e.academicYear,
      'academic_semester': e.academicSemester,
      'course_type': e.courseType,
      'credits1': e.credits1,
      'credits2': e.credits2,
      'department_code': e.departmentCode,
      'department_name': e.departmentName,
      'teaching_goal': e.teachingGoal,
      'is_closed': e.isClosed,
      'basic_info': {
        'class_time': e.basicInfo.classTime,
        'target_class': e.basicInfo.targetClass,
        'target_grade': e.basicInfo.targetGrade,
        'enrollment_notes': e.basicInfo.enrollmentNotes,
      },
      'grading_items': e.gradingItems.map((g) => {
        'method': g.method,
        'percentage': g.percentage,
        'description': g.description,
      }).toList(),
      'selection_records': e.selectionRecords.map((s) => {
        'date': s.date,
        'enrolled': s.enrolled,
        'remaining': s.remaining,
        'registered': s.registered,
      }).toList(),
      'teachers': e.teachers,
    }).toList());
    await _prefs.setString(_coursesKey, coursesJson);
    await _prefs.setInt(_countKey, count);
  }

  bool isVersionChanged(CourseVersion newVersion) {
    final stored = getStoredVersion();
    if (stored == null) return true;
    return stored.version != newVersion.version || stored.hash != newVersion.hash;
  }
}
