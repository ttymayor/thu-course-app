import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../services/schedule_service.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late Future<ScheduleService> _scheduleServiceFuture;
  List<ScheduleCourse> _courses = [];

  static const List<String> _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  static const List<String> _periodLabels = [
    'A', '1', '2', '3', '4', 'B', '5', '6', '7', '8', '9', '10', '11', '12', '13'
  ];

  static const double _rowHeight = 48.0;
  static const double _headerHeight = 36.0;
  static const double _periodColWidth = 32.0;
  static const double _dayColWidth = 80.0;

  @override
  void initState() {
    super.initState();
    _scheduleServiceFuture = ScheduleService.create();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCourses();
  }

  @override
  void didUpdateWidget(SchedulePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    final service = await _scheduleServiceFuture;
    setState(() {
      _courses = service.getScheduleCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        centerTitle: true,
      ),
      body: _courses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 64,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No courses added',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add courses from the Courses tab',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: _buildTimetable(context),
              ),
            ),
    );
  }

  Widget _buildTimetable(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final int rows = _periodLabels.length;
    final int cols = _dayLabels.length;
    final double totalHeight = _headerHeight + rows * _rowHeight;
    final double totalWidth = _periodColWidth + cols * _dayColWidth;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: totalWidth,
        height: totalHeight,
        child: Stack(
          children: [
            _buildGrid(rows, cols, colorScheme),
            ..._buildCourseBlocks(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(int rows, int cols, ColorScheme colorScheme) {
    final border = BorderSide(color: colorScheme.outlineVariant);

    return Column(
      children: [
        // Header row
        Row(
          children: [
            Container(
              width: _periodColWidth,
              height: _headerHeight,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                border: Border(bottom: border, right: border),
              ),
            ),
            ..._dayLabels.map(
              (day) => Container(
                width: _dayColWidth,
                height: _headerHeight,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  border: Border(bottom: border, right: border),
                ),
                alignment: Alignment.center,
                child: Text(
                  day,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ],
        ),
        // Period rows
        ...List.generate(
          rows,
          (rowIndex) => Row(
            children: [
              Container(
                width: _periodColWidth,
                height: _rowHeight,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.4),
                  border: Border(bottom: border, right: border),
                ),
                alignment: Alignment.center,
                child: Text(
                  _periodLabels[rowIndex],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              ...List.generate(
                cols,
                (_) => Container(
                  width: _dayColWidth,
                  height: _rowHeight,
                  decoration: BoxDecoration(
                    border: Border(bottom: border, right: border),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCourseBlocks(ColorScheme colorScheme) {
    return _courses.map((course) {
      final top = _headerHeight + course.startPeriod * _rowHeight;
      final spanRows = (course.endPeriod - course.startPeriod + 1).clamp(1, _periodLabels.length);
      final height = spanRows * _rowHeight;
      final left = _periodColWidth + course.dayOfWeek * _dayColWidth;

      return Positioned(
        top: top,
        left: left,
        width: _dayColWidth,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: colorScheme.secondary.withOpacity(0.4),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.courseName,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSecondaryContainer,
                  ),
                  maxLines: (spanRows * 2).clamp(1, 6),
                  overflow: TextOverflow.ellipsis,
                ),
                if (course.location.isNotEmpty && spanRows >= 2) ...[
                  const SizedBox(height: 2),
                  Text(
                    course.location,
                    style: TextStyle(
                      fontSize: 8,
                      color: colorScheme.onSecondaryContainer.withOpacity(0.75),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
