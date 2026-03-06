import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../models/course.dart';
import '../services/auth_service.dart';
import '../services/schedule_service.dart';
import 'course_list_page.dart';
import 'schedule_page.dart';
import 'settings_page.dart';
import 'onboarding_page.dart';

class HomePage extends StatefulWidget {
  final List<Course> initialCourses;
  final int totalCount;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  const HomePage({
    super.key,
    required this.initialCourses,
    required this.totalCount,
    required this.themeMode,
    required this.onThemeChanged,
    required this.locale,
    required this.onLocaleChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;
  int _scheduleVersion = 0;
  late ThemeMode _themeMode;
  late Locale _locale;
  bool _swipeToAdd = true;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.themeMode;
    _locale = widget.locale;
    _loadSwipeToAdd();
  }

  Future<void> _loadSwipeToAdd() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _swipeToAdd = prefs.getBool('swipe_to_add') ?? true;
    });
  }

  Future<void> _handleSwipeToAddChanged(bool value) async {
    setState(() => _swipeToAdd = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('swipe_to_add', value);
  }

  void _handleThemeChanged(ThemeMode mode) {
    setState(() => _themeMode = mode);
    widget.onThemeChanged(mode);
  }

  void _handleLocaleChanged(Locale locale) {
    setState(() => _locale = locale);
    widget.onLocaleChanged(locale);
  }

  Future<void> _handleRemoveData() async {
    final service = await ScheduleService.create();
    await service.clearAll();
    setState(() => _scheduleVersion++);
  }

  Future<void> _handleLogout() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => OnboardingPage(
            themeMode: _themeMode,
            onThemeChanged: widget.onThemeChanged,
            locale: _locale,
            onLocaleChanged: widget.onLocaleChanged,
          ),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          CourseListPage(
            key: ValueKey('courses_swipe_$_swipeToAdd'),
            initialCourses: widget.initialCourses,
            totalCount: widget.totalCount,
            swipeToAdd: _swipeToAdd,
            onScheduleChanged: () {
              setState(() => _scheduleVersion++);
            },
          ),
          SchedulePage(key: ValueKey(_scheduleVersion)),
          SettingsPage(
            key: ValueKey('${_themeMode}_${_locale.languageCode}_$_swipeToAdd'),
            themeMode: _themeMode,
            onThemeChanged: _handleThemeChanged,
            locale: _locale,
            onLocaleChanged: _handleLocaleChanged,
            onLogout: _handleLogout,
            swipeToAdd: _swipeToAdd,
            onSwipeToAddChanged: _handleSwipeToAddChanged,
            onRemoveData: _handleRemoveData,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.school_outlined),
            selectedIcon: const Icon(Icons.school),
            label: l10n.courses,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_today_outlined),
            selectedIcon: const Icon(Icons.calendar_today),
            label: l10n.schedule,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}
