import 'package:flutter/material.dart';
import 'pages/onboarding_page.dart';
import 'pages/home_page.dart';
import 'pages/loading_page.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  bool loggedIn = false;

  if (await authService.isSessionValid()) {
    final account = await authService.signInSilently();
    loggedIn = account != null;
    if (!loggedIn) await authService.clearSession();
  }

  runApp(MainApp(loggedIn: loggedIn));
}

class MainApp extends StatefulWidget {
  final bool loggedIn;

  const MainApp({super.key, required this.loggedIn});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _handleThemeChanged(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'THU Course App',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: widget.loggedIn
          ? LoadingPage(
              themeMode: _themeMode,
              onThemeChanged: _handleThemeChanged,
            )
          : OnboardingPage(
              themeMode: _themeMode,
              onThemeChanged: _handleThemeChanged,
            ),
    );
  }

  void navigateToHomePage(courses, totalCount) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(
          initialCourses: courses,
          totalCount: totalCount,
          themeMode: _themeMode,
          onThemeChanged: _handleThemeChanged,
        ),
      ),
    );
  }
}
