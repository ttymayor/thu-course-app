// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'THU 選課 App';

  @override
  String get manageCoursesEasily => '輕鬆管理你的課程';

  @override
  String get signingIn => '登入中...';

  @override
  String get signInWithGoogle => '使用 Google 登入';

  @override
  String get privacyPolicy => '隱私權政策';

  @override
  String get courses => '課程';

  @override
  String get schedule => '課表';

  @override
  String get settings => '設定';

  @override
  String get loadingCourses => '載入課程中...';

  @override
  String get failedToLoadCourses => '載入課程失敗';

  @override
  String get retry => '重試';

  @override
  String get searchCourses => '搜尋課程...';

  @override
  String showingCourses(int count, int total) {
    return '顯示 $count / $total 門課程';
  }

  @override
  String pageOf(int num, int total) {
    return '第 $num / $total 頁';
  }

  @override
  String get teachingGoal => '教學目標';

  @override
  String get teachers => '授課教師';

  @override
  String get credits => '學分';

  @override
  String get targetClass => '修課班級';

  @override
  String get targetGrade => '修課年級';

  @override
  String get grading => '評分方式';

  @override
  String get selectionRecords => '選課紀錄';

  @override
  String latestSelection(int enrolled, int remaining) {
    return '最新：已選 $enrolled 人，剩餘 $remaining 名';
  }

  @override
  String get removeFromSchedule => '從課表移除';

  @override
  String get addToSchedule => '加入課表';

  @override
  String get timeConflict => '時間衝突';

  @override
  String addedToSchedule(String name) {
    return '已將 $name 加入課表';
  }

  @override
  String removedFromSchedule(String name) {
    return '已將 $name 從課表移除';
  }

  @override
  String get noCoursesAdded => '尚未加入課程';

  @override
  String get addCoursesFromTab => '從「課程」分頁加入課程';

  @override
  String get mon => '一';

  @override
  String get tue => '二';

  @override
  String get wed => '三';

  @override
  String get thu => '四';

  @override
  String get fri => '五';

  @override
  String get sat => '六';

  @override
  String get appearance => '外觀';

  @override
  String get theme => '主題';

  @override
  String get chooseTheme => '選擇主題';

  @override
  String get themeSystem => '跟隨系統';

  @override
  String get themeLight => '淺色';

  @override
  String get themeDark => '深色';

  @override
  String get logout => '登出';

  @override
  String get logoutConfirm => '確定要登出嗎？';

  @override
  String get cancel => '取消';

  @override
  String get about => '關於';

  @override
  String get appVersion => 'App 版本';

  @override
  String get ok => '確定';

  @override
  String get thuEmailOnly => '僅限東海大學信箱（@go.thu.edu.tw 或 @thu.edu.tw）登入';

  @override
  String get privacyIntro => 'THU 選課 App 尊重您的隱私。本政策說明我們如何處理您的資訊。\n';

  @override
  String get privacyAuthTitle => '身份驗證';

  @override
  String get privacyAuthBody =>
      '我們使用 Firebase Authentication 搭配 Google 登入。僅使用您的電子郵件地址來驗證您是否為東海大學成員（@go.thu.edu.tw 或 @thu.edu.tw）。我們不會儲存您的 Google 密碼。\n';

  @override
  String get privacyDataCollectionTitle => '資料蒐集';

  @override
  String get privacyDataCollectionBody =>
      '我們僅蒐集 App 運作所需的最少資料：\n- 電子郵件地址（用於東海網域驗證）\n- 顯示名稱與大頭貼（來自您的 Google 帳戶）\n- 您在 App 內的選課紀錄\n';

  @override
  String get privacyDataStorageTitle => '資料儲存';

  @override
  String get privacyDataStorageBody =>
      '身份驗證狀態由 Firebase 管理，並儲存在您的裝置上。課程資料從學校來源取得並在本地快取。\n';

  @override
  String get privacyThirdPartyTitle => '第三方服務';

  @override
  String get privacyThirdPartyBody =>
      '本 App 使用 Google 登入與 Firebase，受 Google 隱私權政策規範。\n';

  @override
  String get privacyDataDeletionTitle => '資料刪除';

  @override
  String get privacyDataDeletionBody =>
      '您可以隨時從設定中登出，這將清除您的本地工作階段。如需刪除 Firebase 帳戶資料，請聯繫 App 維護者。';
}
