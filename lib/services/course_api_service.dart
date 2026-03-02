import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/course.dart';

class CourseApiService {
  static const int pageSize = 10;
  
  String get _baseUrl => dotenv.env['API_BASE_URL'] ?? '';
  String get _apiKey => dotenv.env['API_KEY'] ?? '';

  Future<CoursesResponse> fetchCourses({int page = 1}) async {
    try {
      final skip = (page - 1) * pageSize;
      final response = await http.get(
        Uri.parse('$_baseUrl/data?limit=$pageSize&skip=$skip'),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return CoursesResponse.fromJson(json);
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
}
