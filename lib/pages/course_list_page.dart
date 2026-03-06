import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/course.dart';
import '../models/schedule.dart';
import '../services/schedule_service.dart';
import 'course_detail_page.dart';

class CourseListPage extends StatefulWidget {
  final List<Course> initialCourses;
  final int totalCount;
  final VoidCallback? onScheduleChanged;
  final bool swipeToAdd;

  const CourseListPage({
    super.key,
    required this.initialCourses,
    required this.totalCount,
    this.onScheduleChanged,
    this.swipeToAdd = true,
  });

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage>
    with SingleTickerProviderStateMixin {
  static const int _pageSize = 10;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late Future<ScheduleService> _scheduleServiceFuture;
  late TabController _tabController;
  Set<String> _scheduledCourseIds = {};
  List<ScheduleCourse> _scheduledSlots = [];

  List<Course> _allCourses = [];
  List<Course> _filteredCourses = [];
  int _currentPage = 0;
  bool _showSelectedOnly = false;

  List<Course> get _displayCourses {
    if (_showSelectedOnly) {
      return _filteredCourses
          .where((c) => _scheduledCourseIds.contains(c.id))
          .toList();
    }
    return _filteredCourses;
  }

  int get _totalPages => (_displayCourses.length / _pageSize).ceil().clamp(1, double.maxFinite.toInt());

  List<Course> get _pagedCourses {
    final courses = _displayCourses;
    final start = _currentPage * _pageSize;
    final end = (start + _pageSize).clamp(0, courses.length);
    return courses.sublist(start, end);
  }

  @override
  void initState() {
    super.initState();
    _allCourses = widget.initialCourses;
    _filteredCourses = widget.initialCourses;
    _scheduleServiceFuture = ScheduleService.create();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _showSelectedOnly = _tabController.index == 1;
          _currentPage = 0;
        });
      }
    });
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
    _tabController.dispose();
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
          preferredSize: const Size.fromHeight(108),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: l10n.allCourses),
                  Tab(text: l10n.selectedCourses),
                ],
              ),
            ],
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
              l10n.showingCourses(_displayCourses.length, _showSelectedOnly ? _scheduledCourseIds.length : widget.totalCount),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: paged.isEmpty
                ? Center(
                    child: Text(
                      _showSelectedOnly ? l10n.noSelectedCourses : l10n.noCoursesAdded,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  )
                : ListView.builder(
              controller: _scrollController,
              itemCount: paged.length,
              itemBuilder: (context, index) {
                final course = paged[index];
                final inSchedule = _scheduledCourseIds.contains(course.id);
                final conflict = !inSchedule && _hasConflict(course);

                Widget card = _CourseCard(
                  course: course,
                  isInSchedule: inSchedule,
                  onTap: () async {
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailPage(
                          course: course,
                          isInSchedule: inSchedule,
                          hasConflict: conflict,
                          onToggleSchedule: () => _toggleSchedule(course),
                        ),
                      ),
                    );
                    if (result == true) {
                      _loadScheduledCourses();
                    }
                  },
                );

                if (widget.swipeToAdd) {
                  card = Dismissible(
                    key: ValueKey(course.id),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (_) async {
                      if (!inSchedule && conflict) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.timeConflict),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return false;
                      }
                      await _toggleSchedule(course);
                      return false;
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: inSchedule
                            ? colorScheme.errorContainer
                            : colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        inSchedule ? Icons.remove : Icons.add,
                        color: inSchedule
                            ? colorScheme.onErrorContainer
                            : colorScheme.onPrimaryContainer,
                      ),
                    ),
                    child: card,
                  );
                }

                return card;
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
  final VoidCallback onTap;

  const _CourseCard({
    required this.course,
    required this.isInSchedule,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
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
        trailing: isInSchedule
            ? Icon(Icons.check_circle, color: colorScheme.primary)
            : null,
        onTap: onTap,
      ),
    );
  }
}
