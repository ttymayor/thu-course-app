import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/onboarding_page.dart';
import 'pages/loading_page.dart';
import 'services/auth_service.dart';

const _themeKey = 'theme_mode';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  bool loggedIn = false;

  if (await authService.isSessionValid()) {
    final account = await authService.signInSilently();
    loggedIn = account != null;
    if (!loggedIn) await authService.clearSession();
  }

  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString(_themeKey);
  final themeMode = switch (savedTheme) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  runApp(MainApp(loggedIn: loggedIn, initialThemeMode: themeMode));
}

class MainApp extends StatefulWidget {
  final bool loggedIn;
  final ThemeMode initialThemeMode;

  const MainApp({super.key, required this.loggedIn, required this.initialThemeMode});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
  }

  void _handleThemeChanged(ThemeMode mode) {
    setState(() => _themeMode = mode);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(_themeKey, mode.name);
    });
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

}
