import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'THU 選課 App'**
  String get appTitle;

  /// No description provided for @manageCoursesEasily.
  ///
  /// In zh, this message translates to:
  /// **'輕鬆管理你的課程'**
  String get manageCoursesEasily;

  /// No description provided for @signingIn.
  ///
  /// In zh, this message translates to:
  /// **'登入中...'**
  String get signingIn;

  /// No description provided for @signInWithGoogle.
  ///
  /// In zh, this message translates to:
  /// **'使用 Google 登入'**
  String get signInWithGoogle;

  /// No description provided for @privacyPolicy.
  ///
  /// In zh, this message translates to:
  /// **'隱私權政策'**
  String get privacyPolicy;

  /// No description provided for @courses.
  ///
  /// In zh, this message translates to:
  /// **'課程'**
  String get courses;

  /// No description provided for @schedule.
  ///
  /// In zh, this message translates to:
  /// **'課表'**
  String get schedule;

  /// No description provided for @settings.
  ///
  /// In zh, this message translates to:
  /// **'設定'**
  String get settings;

  /// No description provided for @loadingCourses.
  ///
  /// In zh, this message translates to:
  /// **'載入課程中...'**
  String get loadingCourses;

  /// No description provided for @failedToLoadCourses.
  ///
  /// In zh, this message translates to:
  /// **'載入課程失敗'**
  String get failedToLoadCourses;

  /// No description provided for @retry.
  ///
  /// In zh, this message translates to:
  /// **'重試'**
  String get retry;

  /// No description provided for @searchCourses.
  ///
  /// In zh, this message translates to:
  /// **'搜尋課程...'**
  String get searchCourses;

  /// No description provided for @showingCourses.
  ///
  /// In zh, this message translates to:
  /// **'顯示 {count} / {total} 門課程'**
  String showingCourses(int count, int total);

  /// No description provided for @pageOf.
  ///
  /// In zh, this message translates to:
  /// **'第 {num} / {total} 頁'**
  String pageOf(int num, int total);

  /// No description provided for @teachingGoal.
  ///
  /// In zh, this message translates to:
  /// **'教學目標'**
  String get teachingGoal;

  /// No description provided for @teachers.
  ///
  /// In zh, this message translates to:
  /// **'授課教師'**
  String get teachers;

  /// No description provided for @credits.
  ///
  /// In zh, this message translates to:
  /// **'學分'**
  String get credits;

  /// No description provided for @targetClass.
  ///
  /// In zh, this message translates to:
  /// **'修課班級'**
  String get targetClass;

  /// No description provided for @targetGrade.
  ///
  /// In zh, this message translates to:
  /// **'修課年級'**
  String get targetGrade;

  /// No description provided for @grading.
  ///
  /// In zh, this message translates to:
  /// **'評分方式'**
  String get grading;

  /// No description provided for @selectionRecords.
  ///
  /// In zh, this message translates to:
  /// **'選課紀錄'**
  String get selectionRecords;

  /// No description provided for @latestSelection.
  ///
  /// In zh, this message translates to:
  /// **'最新：已選 {enrolled} 人，剩餘 {remaining} 名'**
  String latestSelection(int enrolled, int remaining);

  /// No description provided for @removeFromSchedule.
  ///
  /// In zh, this message translates to:
  /// **'從課表移除'**
  String get removeFromSchedule;

  /// No description provided for @addToSchedule.
  ///
  /// In zh, this message translates to:
  /// **'加入課表'**
  String get addToSchedule;

  /// No description provided for @timeConflict.
  ///
  /// In zh, this message translates to:
  /// **'時間衝突'**
  String get timeConflict;

  /// No description provided for @addedToSchedule.
  ///
  /// In zh, this message translates to:
  /// **'已將 {name} 加入課表'**
  String addedToSchedule(String name);

  /// No description provided for @removedFromSchedule.
  ///
  /// In zh, this message translates to:
  /// **'已將 {name} 從課表移除'**
  String removedFromSchedule(String name);

  /// No description provided for @noCoursesAdded.
  ///
  /// In zh, this message translates to:
  /// **'尚未加入課程'**
  String get noCoursesAdded;

  /// No description provided for @addCoursesFromTab.
  ///
  /// In zh, this message translates to:
  /// **'從「課程」分頁加入課程'**
  String get addCoursesFromTab;

  /// No description provided for @mon.
  ///
  /// In zh, this message translates to:
  /// **'一'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In zh, this message translates to:
  /// **'二'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In zh, this message translates to:
  /// **'三'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In zh, this message translates to:
  /// **'四'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In zh, this message translates to:
  /// **'五'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In zh, this message translates to:
  /// **'六'**
  String get sat;

  /// No description provided for @appearance.
  ///
  /// In zh, this message translates to:
  /// **'外觀'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In zh, this message translates to:
  /// **'主題'**
  String get theme;

  /// No description provided for @chooseTheme.
  ///
  /// In zh, this message translates to:
  /// **'選擇主題'**
  String get chooseTheme;

  /// No description provided for @themeSystem.
  ///
  /// In zh, this message translates to:
  /// **'跟隨系統'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In zh, this message translates to:
  /// **'淺色'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In zh, this message translates to:
  /// **'深色'**
  String get themeDark;

  /// No description provided for @logout.
  ///
  /// In zh, this message translates to:
  /// **'登出'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In zh, this message translates to:
  /// **'確定要登出嗎？'**
  String get logoutConfirm;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @about.
  ///
  /// In zh, this message translates to:
  /// **'關於'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In zh, this message translates to:
  /// **'App 版本'**
  String get appVersion;

  /// No description provided for @ok.
  ///
  /// In zh, this message translates to:
  /// **'確定'**
  String get ok;

  /// No description provided for @thuEmailOnly.
  ///
  /// In zh, this message translates to:
  /// **'僅限東海大學信箱（@go.thu.edu.tw 或 @thu.edu.tw）登入'**
  String get thuEmailOnly;

  /// No description provided for @privacyIntro.
  ///
  /// In zh, this message translates to:
  /// **'THU 選課 App 尊重您的隱私。本政策說明我們如何處理您的資訊。\n'**
  String get privacyIntro;

  /// No description provided for @privacyAuthTitle.
  ///
  /// In zh, this message translates to:
  /// **'身份驗證'**
  String get privacyAuthTitle;

  /// No description provided for @privacyAuthBody.
  ///
  /// In zh, this message translates to:
  /// **'我們使用 Firebase Authentication 搭配 Google 登入。僅使用您的電子郵件地址來驗證您是否為東海大學成員（@go.thu.edu.tw 或 @thu.edu.tw）。我們不會儲存您的 Google 密碼。\n'**
  String get privacyAuthBody;

  /// No description provided for @privacyDataCollectionTitle.
  ///
  /// In zh, this message translates to:
  /// **'資料蒐集'**
  String get privacyDataCollectionTitle;

  /// No description provided for @privacyDataCollectionBody.
  ///
  /// In zh, this message translates to:
  /// **'我們僅蒐集 App 運作所需的最少資料：\n- 電子郵件地址（用於東海網域驗證）\n- 顯示名稱與大頭貼（來自您的 Google 帳戶）\n- 您在 App 內的選課紀錄\n'**
  String get privacyDataCollectionBody;

  /// No description provided for @privacyDataStorageTitle.
  ///
  /// In zh, this message translates to:
  /// **'資料儲存'**
  String get privacyDataStorageTitle;

  /// No description provided for @privacyDataStorageBody.
  ///
  /// In zh, this message translates to:
  /// **'身份驗證狀態由 Firebase 管理，並儲存在您的裝置上。課程資料從學校來源取得並在本地快取。\n'**
  String get privacyDataStorageBody;

  /// No description provided for @privacyThirdPartyTitle.
  ///
  /// In zh, this message translates to:
  /// **'第三方服務'**
  String get privacyThirdPartyTitle;

  /// No description provided for @privacyThirdPartyBody.
  ///
  /// In zh, this message translates to:
  /// **'本 App 使用 Google 登入與 Firebase，受 Google 隱私權政策規範。\n'**
  String get privacyThirdPartyBody;

  /// No description provided for @privacyDataDeletionTitle.
  ///
  /// In zh, this message translates to:
  /// **'資料刪除'**
  String get privacyDataDeletionTitle;

  /// No description provided for @privacyDataDeletionBody.
  ///
  /// In zh, this message translates to:
  /// **'您可以隨時從設定中登出，這將清除您的本地工作階段。如需刪除 Firebase 帳戶資料，請聯繫 App 維護者。'**
  String get privacyDataDeletionBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
