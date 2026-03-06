import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../widgets/privacy_dialog.dart';
import 'swipe_tutorial_page.dart';

class SettingsPage extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;
  final Future<void> Function() onLogout;
  final bool swipeToAdd;
  final ValueChanged<bool> onSwipeToAddChanged;
  final Future<void> Function() onRemoveData;

  const SettingsPage({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
    required this.locale,
    required this.onLocaleChanged,
    required this.onLogout,
    required this.swipeToAdd,
    required this.onSwipeToAddChanged,
    required this.onRemoveData,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings), centerTitle: true),
      body: ListView(
        children: [
          _SectionHeader(title: l10n.appearance),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(_getLocaleText(locale)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context, l10n),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_5),
            title: Text(l10n.theme),
            subtitle: Text(_getThemeModeText(themeMode, l10n)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeDialog(context, l10n),
          ),
          _SectionHeader(title: l10n.courseListBehavior),
          SwitchListTile(
            secondary: const Icon(Icons.swipe_left),
            title: Text(l10n.swipeToAdd),
            subtitle: Text(l10n.swipeToAddDescription),
            value: swipeToAdd,
            onChanged: onSwipeToAddChanged,
          ),
          _SectionHeader(title: l10n.dataManagement),
          ListTile(
            leading: Icon(Icons.delete_outline, color: colorScheme.error),
            title: Text(
              l10n.removeData,
              style: TextStyle(color: colorScheme.error),
            ),
            onTap: () => _showRemoveDataDialog(context, l10n),
          ),
          _SectionHeader(title: l10n.about),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(l10n.tutorial),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SwipeTutorialPage()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.appVersion),
            subtitle: const Text('0.6.0'),
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: Text(l10n.appTitle),
            subtitle: Text(l10n.manageCoursesEasily),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const _AboutPage()),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: colorScheme.error),
            title: Text(
              l10n.logout,
              style: TextStyle(color: colorScheme.error),
            ),
            onTap: () => _showLogoutDialog(context, l10n),
          ),
        ],
      ),
    );
  }

  String _getLocaleText(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'zh':
        return '中文';
      default:
        return locale.languageCode;
    }
  }

  void _showLanguageDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.chooseLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l10n.languageZh),
              value: 'zh',
              groupValue: locale.languageCode,
              onChanged: (value) {
                onLocaleChanged(Locale(value!));
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.languageEn),
              value: 'en',
              groupValue: locale.languageCode,
              onChanged: (value) {
                onLocaleChanged(Locale(value!));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeModeText(ThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.themeLight;
      case ThemeMode.dark:
        return l10n.themeDark;
      case ThemeMode.system:
        return l10n.themeSystem;
    }
  }

  void _showThemeDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.chooseTheme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(l10n.themeSystem),
              value: ThemeMode.system,
              groupValue: themeMode,
              onChanged: (value) {
                onThemeChanged(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.themeLight),
              value: ThemeMode.light,
              groupValue: themeMode,
              onChanged: (value) {
                onThemeChanged(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.themeDark),
              value: ThemeMode.dark,
              groupValue: themeMode,
              onChanged: (value) {
                onThemeChanged(value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveDataDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.removeData),
        content: Text(l10n.removeDataConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await onRemoveData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.removeDataSuccess),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Text(l10n.removeData),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await onLogout();
            },
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }
}

class _AboutPage extends StatelessWidget {
  const _AboutPage();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.about), centerTitle: true),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(l10n.developer),
            subtitle: const Text('tantuyu'),
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: Text(l10n.projectSourceCode),
            subtitle: const Text('github.com/ttymayor/thu_course_app'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => launchUrl(
              Uri.parse('https://github.com/ttymayor/thu_course_app'),
              mode: LaunchMode.externalApplication,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.license),
            subtitle: Text(l10n.mitLicense),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.privacyPolicy),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showPrivacyDialog(context),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
