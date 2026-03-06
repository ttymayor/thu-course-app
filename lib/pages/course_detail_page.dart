import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/course.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;
  final bool isInSchedule;
  final bool hasConflict;
  final VoidCallback onToggleSchedule;

  const CourseDetailPage({
    super.key,
    required this.course,
    required this.isInSchedule,
    required this.hasConflict,
    required this.onToggleSchedule,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.courseDetail),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.courseName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${course.departmentName} • ${course.basicInfo.classTime}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
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
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: isInSchedule
                  ? OutlinedButton.icon(
                      onPressed: () {
                        onToggleSchedule();
                        Navigator.pop(context, true);
                      },
                      icon: const Icon(Icons.remove),
                      label: Text(l10n.removeFromSchedule),
                    )
                  : FilledButton.icon(
                      onPressed: hasConflict
                          ? null
                          : () {
                              onToggleSchedule();
                              Navigator.pop(context, true);
                            },
                      icon: Icon(hasConflict ? Icons.block : Icons.add),
                      label: Text(hasConflict
                          ? l10n.timeConflict
                          : l10n.addToSchedule),
                    ),
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
