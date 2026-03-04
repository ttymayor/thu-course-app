import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/course.dart';
import '../models/schedule.dart';
import '../services/schedule_service.dart';

class CourseListPage extends StatefulWidget {
  final List<Course> initialCourses;
  final int totalCount;
  final VoidCallback? onScheduleChanged;

  const CourseListPage({
    super.key,
    required this.initialCourses,
    required this.totalCount,
    this.onScheduleChanged,
  });

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  static const int _pageSize = 10;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late Future<ScheduleService> _scheduleServiceFuture;
  Set<String> _scheduledCourseIds = {};
  List<ScheduleCourse> _scheduledSlots = [];

  List<Course> _allCourses = [];
  List<Course> _filteredCourses = [];
  int _currentPage = 0;

  int get _totalPages => (_filteredCourses.length / _pageSize).ceil().clamp(1, double.maxFinite.toInt());

  List<Course> get _pagedCourses {
    final start = _currentPage * _pageSize;
    final end = (start + _pageSize).clamp(0, _filteredCourses.length);
    return _filteredCourses.sublist(start, end);
  }

  @override
  void initState() {
    super.initState();
    _allCourses = widget.initialCourses;
    _filteredCourses = widget.initialCourses;
    _scheduleServiceFuture = ScheduleService.create();
    _loadScheduledCourses();
  }

  Future<void> _loadScheduledCourses() async {
    final service = await _scheduleServiceFuture;
    final courses = service.getScheduleCourses();
    setState(() {
      _scheduledCourseIds = courses.map((c) => c.courseId).toSet();
      _scheduledSlots = courses;
    });
  }

  bool _hasConflict(Course course) {
    final newSlots = ScheduleCourse.fromCourse(course);
    for (final newSlot in newSlots) {
      for (final existing in _scheduledSlots) {
        if (newSlot.dayOfWeek == existing.dayOfWeek &&
            newSlot.startPeriod <= existing.endPeriod &&
            newSlot.endPeriod >= existing.startPeriod) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> _toggleSchedule(Course course) async {
    final l10n = AppLocalizations.of(context)!;
    final service = await _scheduleServiceFuture;
    if (_scheduledCourseIds.contains(course.id)) {
      await service.removeCourse(course.id);
      setState(() {
        _scheduledCourseIds.remove(course.id);
        _scheduledSlots.removeWhere((c) => c.courseId == course.id);
      });
      widget.onScheduleChanged?.call();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.removedFromSchedule(course.courseName)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      await service.addCourse(course);
      final newSlots = ScheduleCourse.fromCourse(course);
      setState(() {
        _scheduledCourseIds.add(course.id);
        _scheduledSlots.addAll(newSlots);
      });
      widget.onScheduleChanged?.call();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.addedToSchedule(course.courseName)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _filterCourses(String query) {
    setState(() {
      _filteredCourses = query.isEmpty
          ? _allCourses
          : _allCourses.where((course) {
              return course.courseName.contains(query) ||
                  course.courseCode.contains(query) ||
                  course.departmentName.contains(query) ||
                  course.teachers.any((t) => t.contains(query));
            }).toList();
      _currentPage = 0;
    });
  }

  void _goToPage(int page) {
    setState(() => _currentPage = page);
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final paged = _pagedCourses;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.courses),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SearchBar(
              controller: _searchController,
              hintText: l10n.searchCourses,
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
              l10n.showingCourses(_filteredCourses.length, widget.totalCount),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: paged.length,
              itemBuilder: (context, index) {
                final course = paged[index];
                final inSchedule = _scheduledCourseIds.contains(course.id);
                return _CourseCard(
                  course: course,
                  isInSchedule: inSchedule,
                  hasConflict: !inSchedule && _hasConflict(course),
                  onToggleSchedule: () => _toggleSchedule(course),
                );
              },
            ),
          ),
          _PaginationBar(
            currentPage: _currentPage,
            totalPages: _totalPages,
            onPrev: _currentPage > 0 ? () => _goToPage(_currentPage - 1) : null,
            onNext: _currentPage < _totalPages - 1 ? () => _goToPage(_currentPage + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const _PaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton.outlined(
            onPressed: onPrev,
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            l10n.pageOf(currentPage + 1, totalPages),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          IconButton.outlined(
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Course course;
  final bool isInSchedule;
  final bool hasConflict;
  final VoidCallback onToggleSchedule;

  const _CourseCard({
    required this.course,
    required this.isInSchedule,
    this.hasConflict = false,
    required this.onToggleSchedule,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

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
                    l10n.teachingGoal,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(course.teachingGoal),
                  const SizedBox(height: 16),
                ],
                _InfoRow(
                  label: l10n.teachers,
                  value: course.teachers.join(', '),
                ),
                _InfoRow(
                  label: l10n.credits,
                  value: '${course.credits1} / ${course.credits2}',
                ),
                _InfoRow(
                  label: l10n.targetClass,
                  value: course.basicInfo.targetClass,
                ),
                _InfoRow(
                  label: l10n.targetGrade,
                  value: course.basicInfo.targetGrade,
                ),
                if (course.gradingItems.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.grading,
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
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                ],
                if (course.selectionRecords.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.selectionRecords,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.latestSelection(
                      course.selectionRecords.last.enrolled,
                      course.selectionRecords.last.remaining,
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: isInSchedule
                      ? OutlinedButton.icon(
                          onPressed: onToggleSchedule,
                          icon: const Icon(Icons.remove),
                          label: Text(l10n.removeFromSchedule),
                        )
                      : FilledButton.icon(
                          onPressed: hasConflict ? null : onToggleSchedule,
                          icon: Icon(hasConflict ? Icons.block : Icons.add),
                          label: Text(hasConflict
                              ? l10n.timeConflict
                              : l10n.addToSchedule),
                        ),
                ),
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
