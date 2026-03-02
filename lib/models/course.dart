class Course {
  final String id;
  final String courseCode;
  final String courseName;
  final String courseDescription;
  final int academicYear;
  final int academicSemester;
  final int courseType;
  final int credits1;
  final int credits2;
  final String departmentCode;
  final String departmentName;
  final String teachingGoal;
  final bool isClosed;
  final BasicInfo basicInfo;
  final List<GradingItem> gradingItems;
  final List<SelectionRecord> selectionRecords;
  final List<String> teachers;

  Course({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.courseDescription,
    required this.academicYear,
    required this.academicSemester,
    required this.courseType,
    required this.credits1,
    required this.credits2,
    required this.departmentCode,
    required this.departmentName,
    required this.teachingGoal,
    required this.isClosed,
    required this.basicInfo,
    required this.gradingItems,
    required this.selectionRecords,
    required this.teachers,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      courseCode: json['course_code'] ?? '',
      courseName: json['course_name'] ?? '',
      courseDescription: json['course_description'] ?? '',
      academicYear: json['academic_year'] ?? 0,
      academicSemester: json['academic_semester'] ?? 0,
      courseType: json['course_type'] ?? 0,
      credits1: json['credits1'] ?? 0,
      credits2: json['credits2'] ?? 0,
      departmentCode: json['department_code'] ?? '',
      departmentName: json['department_name'] ?? '',
      teachingGoal: json['teaching_goal'] ?? '',
      isClosed: json['is_closed'] ?? false,
      basicInfo: BasicInfo.fromJson(json['basic_info'] ?? {}),
      gradingItems: (json['grading_items'] as List<dynamic>?)
              ?.map((e) => GradingItem.fromJson(e))
              .toList() ??
          [],
      selectionRecords: (json['selection_records'] as List<dynamic>?)
              ?.map((e) => SelectionRecord.fromJson(e))
              .toList() ??
          [],
      teachers: (json['teachers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class BasicInfo {
  final String classTime;
  final String targetClass;
  final String targetGrade;
  final String enrollmentNotes;

  BasicInfo({
    required this.classTime,
    required this.targetClass,
    required this.targetGrade,
    required this.enrollmentNotes,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      classTime: json['class_time'] ?? '',
      targetClass: json['target_class'] ?? '',
      targetGrade: json['target_grade'] ?? '',
      enrollmentNotes: json['enrollment_notes'] ?? '',
    );
  }
}

class GradingItem {
  final String method;
  final int percentage;
  final String description;

  GradingItem({
    required this.method,
    required this.percentage,
    required this.description,
  });

  factory GradingItem.fromJson(Map<String, dynamic> json) {
    return GradingItem(
      method: json['method'] ?? '',
      percentage: json['percentage'] ?? 0,
      description: json['description'] ?? '',
    );
  }
}

class SelectionRecord {
  final String date;
  final int enrolled;
  final int remaining;
  final int registered;

  SelectionRecord({
    required this.date,
    required this.enrolled,
    required this.remaining,
    required this.registered,
  });

  factory SelectionRecord.fromJson(Map<String, dynamic> json) {
    return SelectionRecord(
      date: json['date'] ?? '',
      enrolled: json['enrolled'] ?? 0,
      remaining: json['remaining'] ?? 0,
      registered: json['registered'] ?? 0,
    );
  }
}

class CoursesResponse {
  final int count;
  final List<Course> data;

  CoursesResponse({
    required this.count,
    required this.data,
  });

  factory CoursesResponse.fromJson(Map<String, dynamic> json) {
    return CoursesResponse(
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Course.fromJson(e))
              .toList() ??
          [],
    );
  }
}
