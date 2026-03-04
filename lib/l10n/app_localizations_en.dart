// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'THU Course App';

  @override
  String get manageCoursesEasily => 'Manage your courses easily';

  @override
  String get signingIn => 'Signing in...';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get courses => 'Courses';

  @override
  String get schedule => 'Schedule';

  @override
  String get settings => 'Settings';

  @override
  String get loadingCourses => 'Loading courses...';

  @override
  String get failedToLoadCourses => 'Failed to load courses';

  @override
  String get retry => 'Retry';

  @override
  String get searchCourses => 'Search courses...';

  @override
  String showingCourses(int count, int total) {
    return 'Showing $count / $total courses';
  }

  @override
  String pageOf(int num, int total) {
    return 'Page $num of $total';
  }

  @override
  String get teachingGoal => 'Teaching Goal';

  @override
  String get teachers => 'Teachers';

  @override
  String get credits => 'Credits';

  @override
  String get targetClass => 'Target Class';

  @override
  String get targetGrade => 'Target Grade';

  @override
  String get grading => 'Grading';

  @override
  String get selectionRecords => 'Selection Records';

  @override
  String latestSelection(int enrolled, int remaining) {
    return 'Latest: $enrolled enrolled, $remaining remaining';
  }

  @override
  String get removeFromSchedule => 'Remove from Schedule';

  @override
  String get addToSchedule => 'Add to Schedule';

  @override
  String get timeConflict => 'Time Conflict';

  @override
  String addedToSchedule(String name) {
    return 'Added $name to schedule';
  }

  @override
  String removedFromSchedule(String name) {
    return 'Removed $name from schedule';
  }

  @override
  String get noCoursesAdded => 'No courses added';

  @override
  String get addCoursesFromTab => 'Add courses from the Courses tab';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get chooseTheme => 'Choose Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get about => 'About';

  @override
  String get appVersion => 'App Version';

  @override
  String get ok => 'OK';

  @override
  String get thuEmailOnly =>
      'Only THU email addresses (@go.thu.edu.tw or @thu.edu.tw) are allowed';

  @override
  String get privacyIntro =>
      'THU Course App respects your privacy. This policy explains how we handle your information.\n';

  @override
  String get privacyAuthTitle => 'Authentication';

  @override
  String get privacyAuthBody =>
      'We use Firebase Authentication with Google Sign-In. Only your email address is used to verify that you are a Tunghai University member (@go.thu.edu.tw or @thu.edu.tw). We do not store your Google password.\n';

  @override
  String get privacyDataCollectionTitle => 'Data Collection';

  @override
  String get privacyDataCollectionBody =>
      'We collect minimal data necessary for the app to function:\n- Email address (for THU domain verification)\n- Display name and profile photo (from your Google account)\n- Course selections you make within the app\n';

  @override
  String get privacyDataStorageTitle => 'Data Storage';

  @override
  String get privacyDataStorageBody =>
      'Authentication state is managed by Firebase and stored locally on your device. Course data is fetched from university sources and cached locally.\n';

  @override
  String get privacyThirdPartyTitle => 'Third-Party Services';

  @override
  String get privacyThirdPartyBody =>
      'This app uses Google Sign-In and Firebase, which are governed by Google\'s Privacy Policy.\n';

  @override
  String get privacyDataDeletionTitle => 'Data Deletion';

  @override
  String get privacyDataDeletionBody =>
      'You can sign out at any time from Settings. This clears your local session. To delete your Firebase account data, contact the app maintainer.';
}
