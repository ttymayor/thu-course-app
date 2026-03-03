import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/auth_service.dart';
import 'course_list_page.dart';
import 'schedule_page.dart';
import 'settings_page.dart';
import 'onboarding_page.dart';

class HomePage extends StatefulWidget {
  final List<Course> initialCourses;
  final int totalCount;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const HomePage({
    super.key,
    required this.initialCourses,
    required this.totalCount,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;
  int _scheduleVersion = 0;

  Future<void> _handleLogout() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => OnboardingPage(
            themeMode: widget.themeMode,
            onThemeChanged: widget.onThemeChanged,
          ),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          CourseListPage(
            initialCourses: widget.initialCourses,
            totalCount: widget.totalCount,
            onScheduleChanged: () {
              setState(() => _scheduleVersion++);
            },
          ),
          SchedulePage(key: ValueKey(_scheduleVersion)),
          SettingsPage(
            key: ValueKey(widget.themeMode),
            themeMode: widget.themeMode,
            onThemeChanged: widget.onThemeChanged,
            onLogout: _handleLogout,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
