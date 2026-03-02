import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_api_service.dart';

class CourseListPage extends StatefulWidget {
  final List<Course> initialCourses;
  final int totalCount;

  const CourseListPage({
    super.key,
    required this.initialCourses,
    required this.totalCount,
  });

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final CourseApiService _apiService = CourseApiService();

  List<Course> _allCourses = [];
  List<Course> _filteredCourses = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _allCourses = widget.initialCourses;
    _filteredCourses = widget.initialCourses;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoading || !_hasMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      _currentPage++;
      final response = await _apiService.fetchCourses(page: _currentPage);

      setState(() {
        _allCourses.addAll(response.data);
        if (_searchController.text.isEmpty) {
          _filteredCourses = _allCourses;
        }
        if (response.data.length < CourseApiService.pageSize) {
          _hasMore = false;
        }
      });
    } catch (e) {
      _currentPage--;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterCourses(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCourses = _allCourses;
      } else {
        _filteredCourses = _allCourses.where((course) {
          return course.courseName.contains(query) ||
              course.courseCode.contains(query) ||
              course.departmentName.contains(query) ||
              course.teachers.any((t) => t.contains(query));
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search courses...',
              leading: const Icon(Icons.search),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _filterCourses('');
                    },
                  ),
              ],
              onChanged: _filterCourses,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: colorScheme.surfaceContainerHighest,
            child: Text(
              'Showing: ${_filteredCourses.length} / ${widget.totalCount} courses',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _filteredCourses.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _filteredCourses.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final course = _filteredCourses[index];
                return _CourseCard(course: course);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Course course;

  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: course.isClosed
              ? colorScheme.surfaceContainerHighest
              : colorScheme.primaryContainer,
          child: Text(
            course.courseCode,
            style: TextStyle(
              fontSize: 10,
              color: course.isClosed
                  ? colorScheme.onSurfaceVariant
                  : colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        title: Text(
          course.courseName,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: course.isClosed ? colorScheme.onSurfaceVariant : null,
          ),
        ),
        subtitle: Text(
          '${course.departmentName} • ${course.basicInfo.classTime}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (course.teachingGoal.isNotEmpty) ...[
                  Text(
                    'Teaching Goal',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(course.teachingGoal),
                  const SizedBox(height: 16),
                ],
                _InfoRow(
                  label: 'Teachers',
                  value: course.teachers.join(', '),
                ),
                _InfoRow(
                  label: 'Credits',
                  value: '${course.credits1} / ${course.credits2}',
                ),
                _InfoRow(
                  label: 'Target Class',
                  value: course.basicInfo.targetClass,
                ),
                _InfoRow(
                  label: 'Target Grade',
                  value: course.basicInfo.targetGrade,
                ),
                if (course.gradingItems.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Grading',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  ...course.gradingItems.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Expanded(child: Text(item.method)),
                            Text(
                              '${item.percentage}%',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                ],
                if (course.selectionRecords.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Selection Records',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Latest: ${course.selectionRecords.last.enrolled} enrolled, ${course.selectionRecords.last.remaining} remaining',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
