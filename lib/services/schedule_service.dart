import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/schedule.dart';
import '../models/course.dart';

class ScheduleService {
  static const String _scheduleKey = 'schedule_courses';
  
  final SharedPreferences _prefs;

  ScheduleService(this._prefs);

  static Future<ScheduleService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ScheduleService(prefs);
  }

  List<ScheduleCourse> getScheduleCourses() {
    final json = _prefs.getString(_scheduleKey);
    if (json == null) return [];
    final List<dynamic> list = jsonDecode(json);
    return list.map((e) => ScheduleCourse.fromJson(e)).toList();
  }

  Future<void> addCourse(Course course) async {
    final courses = getScheduleCourses();
    final newCourses = ScheduleCourse.fromCourse(course);
    
    for (final newCourse in newCourses) {
      final exists = courses.any((c) => 
        c.courseId == newCourse.courseId && 
        c.dayOfWeek == newCourse.dayOfWeek && 
        c.startPeriod == newCourse.startPeriod
      );
      if (!exists) {
        courses.add(newCourse);
      }
    }
    
    await _saveCourses(courses);
  }

  Future<void> removeCourse(String courseId) async {
    final courses = getScheduleCourses();
    courses.removeWhere((c) => c.courseId == courseId);
    await _saveCourses(courses);
  }

  bool isCourseInSchedule(String courseId) {
    final courses = getScheduleCourses();
    return courses.any((c) => c.courseId == courseId);
  }

  Future<void> _saveCourses(List<ScheduleCourse> courses) async {
    final json = jsonEncode(courses.map((c) => c.toJson()).toList());
    await _prefs.setString(_scheduleKey, json);
  }

  Future<void> clearAll() async {
    await _prefs.remove(_scheduleKey);
  }
}
