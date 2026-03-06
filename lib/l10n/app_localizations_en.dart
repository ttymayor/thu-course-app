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
  String get language => 'Language';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get languageZh => '中文';

  @override
  String get languageEn => 'English';

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
  String get developer => 'Developer';

  @override
  String get projectSourceCode => 'Project Source Code';

  @override
  String get license => 'License';

  @override
  String get mitLicense => 'MIT License';

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

  @override
  String get courseDetail => 'Course Detail';

  @override
  String get swipeToAdd => 'Swipe to Add/Remove';

  @override
  String get swipeToAddDescription =>
      'Left swipe on course tiles to quickly add or remove from schedule';

  @override
  String get courseListBehavior => 'Course List';

  @override
  String get removeData => 'Remove Schedule Data';

  @override
  String get removeDataConfirm =>
      'Are you sure you want to remove all schedule data? This action cannot be undone.';

  @override
  String get removeDataSuccess => 'All schedule data has been removed';

  @override
  String get dataManagement => 'Data';

  @override
  String get allCourses => 'All';

  @override
  String get selectedCourses => 'Selected';

  @override
  String get noSelectedCourses => 'No courses selected yet';

  @override
  String get tutorial => 'Tutorial';

  @override
  String get swipeTutorialTitle => 'Swipe to Add Course';

  @override
  String get swipeTutorialDescription =>
      'Swipe the card below to the left to try adding a course to your schedule.';

  @override
  String get swipeTutorialSuccess =>
      'Great! You\'ve learned how to swipe to add courses.';

  @override
  String get swipeTutorialReset => 'Try Again';

  @override
  String get gotIt => 'Got It';

  @override
  String get exampleCourse => 'Example Course';

  @override
  String get exampleDepartment => 'Computer Science';

  @override
  String get exampleClassTime => 'Mon 1-2';
}
