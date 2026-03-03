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
    final coursesJson = jsonEncode(courses.map((e) => e.toJson()).toList());
    await _prefs.setString(_coursesKey, coursesJson);
    await _prefs.setInt(_countKey, count);
  }

  bool isVersionChanged(CourseVersion newVersion) {
    final stored = getStoredVersion();
    if (stored == null) return true;
    return stored.version != newVersion.version || stored.hash != newVersion.hash;
  }
}
