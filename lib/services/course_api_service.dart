import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';
import 'course_cache_service.dart';

class CourseApiService {
  static const String _baseUrl = String.fromEnvironment('API_BASE_URL');
  static const String _apiKey = String.fromEnvironment('API_KEY');

  Future<CourseVersion> fetchVersion() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/version'),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return CourseVersion.fromJson(json);
      } else {
        throw Exception('Failed to load version: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<CoursesResponse> fetchCourses({bool forceRefresh = false}) async {
    try {
      final cacheService = await CourseCacheService.create();

      if (!forceRefresh) {
        final version = await fetchVersion();
        if (!cacheService.isVersionChanged(version)) {
          final cachedCourses = cacheService.getStoredCourses();
          final cachedCount = cacheService.getStoredCount();
          if (cachedCourses != null && cachedCourses.isNotEmpty) {
            return CoursesResponse(count: cachedCount, data: cachedCourses);
          }
        }
        await cacheService.saveVersion(version);
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/data'),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final coursesResponse = CoursesResponse.fromJson(json);
        await cacheService.saveCourses(coursesResponse.data, coursesResponse.count);
        return coursesResponse;
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
}
