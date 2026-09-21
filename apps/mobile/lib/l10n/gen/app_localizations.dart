import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('th'),
  ];

  /// No description provided for @appName.
  ///
  /// In th, this message translates to:
  /// **'Homeo'**
  String get appName;

  /// No description provided for @tabFocus.
  ///
  /// In th, this message translates to:
  /// **'Focus'**
  String get tabFocus;

  /// No description provided for @tabVault.
  ///
  /// In th, this message translates to:
  /// **'Vault'**
  String get tabVault;

  /// No description provided for @tabInsights.
  ///
  /// In th, this message translates to:
  /// **'Insights'**
  String get tabInsights;

  /// No description provided for @tabAiCoach.
  ///
  /// In th, this message translates to:
  /// **'AI Coach'**
  String get tabAiCoach;

  /// No description provided for @tabSettings.
  ///
  /// In th, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @comingSoon.
  ///
  /// In th, this message translates to:
  /// **'ส่วนนี้กำลังพัฒนา'**
  String get comingSoon;

  /// No description provided for @greetingMorning.
  ///
  /// In th, this message translates to:
  /// **'สวัสดีตอนเช้า'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In th, this message translates to:
  /// **'สวัสดีตอนบ่าย'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In th, this message translates to:
  /// **'สวัสดีตอนเย็น'**
  String get greetingEvening;

  /// No description provided for @streakDays.
  ///
  /// In th, this message translates to:
  /// **'{count} วันติดต่อกัน'**
  String streakDays(int count);

  /// No description provided for @streakBest.
  ///
  /// In th, this message translates to:
  /// **'สูงสุด {count} วัน'**
  String streakBest(int count);

  /// No description provided for @streakNone.
  ///
  /// In th, this message translates to:
  /// **'เริ่ม streak ใหม่ได้วันนี้'**
  String get streakNone;

  /// No description provided for @focusPrompt.
  ///
  /// In th, this message translates to:
  /// **'วันนี้อยากทำอะไรให้เสร็จหนึ่งอย่าง?'**
  String get focusPrompt;

  /// No description provided for @focusStartCta.
  ///
  /// In th, this message translates to:
  /// **'เริ่ม Focus Session'**
  String get focusStartCta;

  /// No description provided for @statFocusToday.
  ///
  /// In th, this message translates to:
  /// **'โฟกัสวันนี้'**
  String get statFocusToday;

  /// No description provided for @statFocusWeek.
  ///
  /// In th, this message translates to:
  /// **'โฟกัสสัปดาห์นี้'**
  String get statFocusWeek;

  /// No description provided for @statSessionsToday.
  ///
  /// In th, this message translates to:
  /// **'Session วันนี้'**
  String get statSessionsToday;

  /// No description provided for @lastSessionTitle.
  ///
  /// In th, this message translates to:
  /// **'Session ล่าสุด: {duration}'**
  String lastSessionTitle(String duration);

  /// No description provided for @lastSessionNoIntention.
  ///
  /// In th, this message translates to:
  /// **'ไม่ได้ระบุเป้าหมาย'**
  String get lastSessionNoIntention;

  /// No description provided for @durationHoursMinutes.
  ///
  /// In th, this message translates to:
  /// **'{hours} ชม. {minutes} น.'**
  String durationHoursMinutes(int hours, int minutes);

  /// No description provided for @durationHoursOnly.
  ///
  /// In th, this message translates to:
  /// **'{hours} ชม.'**
  String durationHoursOnly(int hours);

  /// No description provided for @durationMinutesOnly.
  ///
  /// In th, this message translates to:
  /// **'{minutes} น.'**
  String durationMinutesOnly(int minutes);

  /// No description provided for @durationPresetMinutes.
  ///
  /// In th, this message translates to:
  /// **'{minutes} นาที'**
  String durationPresetMinutes(int minutes);

  /// No description provided for @durationCustom.
  ///
  /// In th, this message translates to:
  /// **'กำหนดเอง'**
  String get durationCustom;

  /// No description provided for @setupTitle.
  ///
  /// In th, this message translates to:
  /// **'ตั้งค่า Session'**
  String get setupTitle;

  /// No description provided for @setupClose.
  ///
  /// In th, this message translates to:
  /// **'ปิด'**
  String get setupClose;

  /// No description provided for @setupDurationLabel.
  ///
  /// In th, this message translates to:
  /// **'ระยะเวลา'**
  String get setupDurationLabel;

  /// No description provided for @setupIntentionLabel.
  ///
  /// In th, this message translates to:
  /// **'เป้าหมายของ session นี้'**
  String get setupIntentionLabel;

  /// No description provided for @setupIntentionHint.
  ///
  /// In th, this message translates to:
  /// **'เช่น เขียนรายงาน Chapter 3 ให้เสร็จ'**
  String get setupIntentionHint;

  /// No description provided for @setupIntentionHelper.
  ///
  /// In th, this message translates to:
  /// **'ไม่จำเป็นต้องระบุ — เพื่อเตือนความจำของคุณเอง'**
  String get setupIntentionHelper;

  /// No description provided for @setupStartButton.
  ///
  /// In th, this message translates to:
  /// **'เริ่ม Session {duration}'**
  String setupStartButton(String duration);

  /// No description provided for @pickerTitle.
  ///
  /// In th, this message translates to:
  /// **'กำหนดระยะเวลาเอง'**
  String get pickerTitle;

  /// No description provided for @pickerConfirm.
  ///
  /// In th, this message translates to:
  /// **'ตกลง'**
  String get pickerConfirm;

  /// No description provided for @pickerCancel.
  ///
  /// In th, this message translates to:
  /// **'ยกเลิก'**
  String get pickerCancel;

  /// No description provided for @activeStatusFocusing.
  ///
  /// In th, this message translates to:
  /// **'กำลังโฟกัส'**
  String get activeStatusFocusing;

  /// No description provided for @activeStatusPaused.
  ///
  /// In th, this message translates to:
  /// **'หยุดชั่วคราว'**
  String get activeStatusPaused;

  /// No description provided for @activeExit.
  ///
  /// In th, this message translates to:
  /// **'ออกจาก Session'**
  String get activeExit;

  /// No description provided for @activeGoalLabel.
  ///
  /// In th, this message translates to:
  /// **'เป้าหมาย'**
  String get activeGoalLabel;

  /// No description provided for @activePause.
  ///
  /// In th, this message translates to:
  /// **'พัก'**
  String get activePause;

  /// No description provided for @activeResume.
  ///
  /// In th, this message translates to:
  /// **'กลับมาโฟกัส'**
  String get activeResume;

  /// No description provided for @activePausesUsed.
  ///
  /// In th, this message translates to:
  /// **'พัก {used}/{total} ครั้งวันนี้'**
  String activePausesUsed(int used, int total);

  /// No description provided for @activeTimerSemantics.
  ///
  /// In th, this message translates to:
  /// **'{status} เหลือ {time}'**
  String activeTimerSemantics(String status, String time);

  /// No description provided for @exitGateTitle.
  ///
  /// In th, this message translates to:
  /// **'ต้องการออกจาก session จริงๆ ไหม?'**
  String get exitGateTitle;

  /// No description provided for @exitGateSubtitle.
  ///
  /// In th, this message translates to:
  /// **'ไม่เป็นไร — บอกเหตุผลได้ถ้าอยากบอก'**
  String get exitGateSubtitle;

  /// No description provided for @exitReasonEmergency.
  ///
  /// In th, this message translates to:
  /// **'เหตุฉุกเฉิน'**
  String get exitReasonEmergency;

  /// No description provided for @exitReasonTired.
  ///
  /// In th, this message translates to:
  /// **'เหนื่อยเกินไป'**
  String get exitReasonTired;

  /// No description provided for @exitReasonDistracted.
  ///
  /// In th, this message translates to:
  /// **'ไม่มีสมาธิ'**
  String get exitReasonDistracted;

  /// No description provided for @exitReasonOther.
  ///
  /// In th, this message translates to:
  /// **'อื่นๆ'**
  String get exitReasonOther;

  /// No description provided for @commonBackToFocus.
  ///
  /// In th, this message translates to:
  /// **'กลับไปโฟกัส'**
  String get commonBackToFocus;

  /// No description provided for @exitGateLeave.
  ///
  /// In th, this message translates to:
  /// **'ออกจาก session'**
  String get exitGateLeave;

  /// No description provided for @exitGateLeaveWait.
  ///
  /// In th, this message translates to:
  /// **'ออกจาก session ({seconds}s)'**
  String exitGateLeaveWait(int seconds);

  /// No description provided for @pauseLimitTitle.
  ///
  /// In th, this message translates to:
  /// **'ใช้ครบจำนวนพักวันนี้แล้ว ({used}/{total})'**
  String pauseLimitTitle(int used, int total);

  /// No description provided for @pauseLimitBody.
  ///
  /// In th, this message translates to:
  /// **'ลองหายใจเข้าลึกๆ แล้วกลับไปโฟกัสได้เลย\nคุณทำได้ดีมากมาถึงตรงนี้แล้ว'**
  String get pauseLimitBody;

  /// No description provided for @summaryCompletedTitle.
  ///
  /// In th, this message translates to:
  /// **'เยี่ยมมากเลย!'**
  String get summaryCompletedTitle;

  /// No description provided for @summaryAbortedTitle.
  ///
  /// In th, this message translates to:
  /// **'ขอบคุณที่พยายาม'**
  String get summaryAbortedTitle;

  /// No description provided for @summaryFocused.
  ///
  /// In th, this message translates to:
  /// **'คุณโฟกัสได้ {duration}'**
  String summaryFocused(String duration);

  /// No description provided for @summaryAbortedNote.
  ///
  /// In th, this message translates to:
  /// **'Session ถูกยกเลิกก่อนเวลา'**
  String get summaryAbortedNote;

  /// No description provided for @summaryMoodQuestion.
  ///
  /// In th, this message translates to:
  /// **'ระหว่าง session รู้สึกอย่างไร?'**
  String get summaryMoodQuestion;

  /// No description provided for @moodHard.
  ///
  /// In th, this message translates to:
  /// **'ยาก'**
  String get moodHard;

  /// No description provided for @moodOkay.
  ///
  /// In th, this message translates to:
  /// **'ปกติ'**
  String get moodOkay;

  /// No description provided for @moodGood.
  ///
  /// In th, this message translates to:
  /// **'ดี'**
  String get moodGood;

  /// No description provided for @moodGreat.
  ///
  /// In th, this message translates to:
  /// **'ยอดเยี่ยม'**
  String get moodGreat;

  /// No description provided for @summarySave.
  ///
  /// In th, this message translates to:
  /// **'บันทึกและกลับหน้าหลัก'**
  String get summarySave;

  /// No description provided for @summarySkip.
  ///
  /// In th, this message translates to:
  /// **'ข้าม'**
  String get summarySkip;

  /// No description provided for @gateAwarenessTitle.
  ///
  /// In th, this message translates to:
  /// **'เปิด {app} ครั้งที่ {count} วันนี้'**
  String gateAwarenessTitle(String app, int count);

  /// No description provided for @gateMicroTitle.
  ///
  /// In th, this message translates to:
  /// **'ยืนยันก่อนเปิด'**
  String get gateMicroTitle;

  /// No description provided for @gateMicroBody.
  ///
  /// In th, this message translates to:
  /// **'ยืนยันว่าต้องการเปิด {app} จริงๆ ลองพิจารณาดูก่อนนะ'**
  String gateMicroBody(String app);

  /// No description provided for @gateReflectiveTitle.
  ///
  /// In th, this message translates to:
  /// **'หยุดสักครู่ — กลับไปโฟกัสกันไหม?'**
  String get gateReflectiveTitle;

  /// No description provided for @gateReflectiveBody.
  ///
  /// In th, this message translates to:
  /// **'ตอนนี้เป็นช่วงที่คุณตั้งใจปกป้องไว้ ถ้ายังอยากเปิด บอกเราได้ว่าเพราะอะไร'**
  String get gateReflectiveBody;

  /// No description provided for @gateReasonLabel.
  ///
  /// In th, this message translates to:
  /// **'เหตุผลที่ต้องการเปิด'**
  String get gateReasonLabel;

  /// No description provided for @gateReasonHint.
  ///
  /// In th, this message translates to:
  /// **'พิมพ์สั้นๆ ก็พอ'**
  String get gateReasonHint;

  /// No description provided for @gateReasonRest.
  ///
  /// In th, this message translates to:
  /// **'อยากพัก'**
  String get gateReasonRest;

  /// No description provided for @gateReasonTask.
  ///
  /// In th, this message translates to:
  /// **'มีเรื่องต้องทำ'**
  String get gateReasonTask;

  /// No description provided for @gateBlockTitle.
  ///
  /// In th, this message translates to:
  /// **'ตอนนี้เป็นช่วง Focus ของคุณ'**
  String get gateBlockTitle;

  /// No description provided for @gateBlockBody.
  ///
  /// In th, this message translates to:
  /// **'ลองกลับไปทำสิ่งที่ตั้งใจไว้ก่อนนะ\nคุณทำได้แน่นอน'**
  String get gateBlockBody;

  /// No description provided for @gatePartnerTitle.
  ///
  /// In th, this message translates to:
  /// **'ปกป้องร่วมกับ Partner'**
  String get gatePartnerTitle;

  /// No description provided for @gatePartnerBody.
  ///
  /// In th, this message translates to:
  /// **'แอปนี้อยู่ระดับ L4 การเปิดต้องผ่านการอนุมัติจาก Vault Partner ของคุณ'**
  String get gatePartnerBody;

  /// No description provided for @gatePartnerRequest.
  ///
  /// In th, this message translates to:
  /// **'ส่งคำขอ Override'**
  String get gatePartnerRequest;

  /// No description provided for @gatePartnerPending.
  ///
  /// In th, this message translates to:
  /// **'ส่งคำขอแล้ว — รอ Partner ตอบ'**
  String get gatePartnerPending;

  /// No description provided for @gatePartnerCoolingOff.
  ///
  /// In th, this message translates to:
  /// **'ถ้า Partner ไม่ตอบ จะปลดบล็อกอัตโนมัติใน {time}'**
  String gatePartnerCoolingOff(String time);

  /// No description provided for @gatePartnerDenied.
  ///
  /// In th, this message translates to:
  /// **'Partner ยังไม่อนุมัติ — กลับไปโฟกัสก่อนนะ'**
  String get gatePartnerDenied;

  /// No description provided for @gateOpenApp.
  ///
  /// In th, this message translates to:
  /// **'เปิด {app}'**
  String gateOpenApp(String app);

  /// No description provided for @gateOpenAppWait.
  ///
  /// In th, this message translates to:
  /// **'เปิด {app} ({seconds}s)'**
  String gateOpenAppWait(String app, int seconds);

  /// No description provided for @gateConfirm.
  ///
  /// In th, this message translates to:
  /// **'ยืนยัน'**
  String get gateConfirm;

  /// No description provided for @gateConfirmWait.
  ///
  /// In th, this message translates to:
  /// **'ยืนยัน ({seconds})'**
  String gateConfirmWait(int seconds);

  /// No description provided for @gateEscalatedNote.
  ///
  /// In th, this message translates to:
  /// **'เพิ่มระดับอัตโนมัติ เพราะพยายามเปิดหลายครั้งในเวลาสั้นๆ'**
  String get gateEscalatedNote;

  /// No description provided for @gateSessionNote.
  ///
  /// In th, this message translates to:
  /// **'กำลังอยู่ในช่วง Focus session'**
  String get gateSessionNote;

  /// No description provided for @emergencyLink.
  ///
  /// In th, this message translates to:
  /// **'ฉุกเฉิน?'**
  String get emergencyLink;

  /// No description provided for @emergencyTitle.
  ///
  /// In th, this message translates to:
  /// **'ต้องการปลดบล็อกทันทีเพื่อเหตุฉุกเฉินใช่ไหม?'**
  String get emergencyTitle;

  /// No description provided for @emergencyUsage.
  ///
  /// In th, this message translates to:
  /// **'ใช้ฉุกเฉินไปแล้ว {used}/{max} ครั้งเดือนนี้'**
  String emergencyUsage(int used, int max);

  /// No description provided for @emergencyBody.
  ///
  /// In th, this message translates to:
  /// **'การใช้ฉุกเฉินจะปลดบล็อกทันที {minutes} นาที และบันทึกการใช้งานไว้'**
  String emergencyBody(int minutes);

  /// No description provided for @emergencyConfirm.
  ///
  /// In th, this message translates to:
  /// **'ใช้ฉุกเฉิน'**
  String get emergencyConfirm;

  /// No description provided for @emergencyExhaustedTitle.
  ///
  /// In th, this message translates to:
  /// **'ใช้ครบโควต้าฉุกเฉินเดือนนี้แล้ว'**
  String get emergencyExhaustedTitle;

  /// No description provided for @emergencyExhaustedBody.
  ///
  /// In th, this message translates to:
  /// **'หากเป็นเหตุฉุกเฉินจริง โทร 1669 (การแพทย์ฉุกเฉิน) หรือ 191 (ตำรวจ) ได้ทันที'**
  String get emergencyExhaustedBody;

  /// No description provided for @emergencyDone.
  ///
  /// In th, this message translates to:
  /// **'ปลดบล็อกแล้ว {minutes} นาที'**
  String emergencyDone(int minutes);

  /// No description provided for @settingsTitle.
  ///
  /// In th, this message translates to:
  /// **'ตั้งค่า'**
  String get settingsTitle;

  /// No description provided for @settingsFrictionTile.
  ///
  /// In th, this message translates to:
  /// **'Friction และแอปที่ระวัง'**
  String get settingsFrictionTile;

  /// No description provided for @settingsFrictionTileSubtitle.
  ///
  /// In th, this message translates to:
  /// **'ปรับว่าการเปิดแอปเสี่ยงยากแค่ไหน'**
  String get settingsFrictionTileSubtitle;

  /// No description provided for @frictionScreenTitle.
  ///
  /// In th, this message translates to:
  /// **'Friction'**
  String get frictionScreenTitle;

  /// No description provided for @frictionDefaultSection.
  ///
  /// In th, this message translates to:
  /// **'ระดับเริ่มต้น'**
  String get frictionDefaultSection;

  /// No description provided for @frictionAppsSection.
  ///
  /// In th, this message translates to:
  /// **'แอปที่ระวังเป็นพิเศษ'**
  String get frictionAppsSection;

  /// No description provided for @frictionAppsHint.
  ///
  /// In th, this message translates to:
  /// **'เปิดสวิตช์เพื่อให้แอปนั้นต้องผ่าน friction ก่อนเปิด'**
  String get frictionAppsHint;

  /// No description provided for @frictionL0Name.
  ///
  /// In th, this message translates to:
  /// **'L0 — Awareness'**
  String get frictionL0Name;

  /// No description provided for @frictionL0Desc.
  ///
  /// In th, this message translates to:
  /// **'แบนเนอร์เตือนเงียบๆ'**
  String get frictionL0Desc;

  /// No description provided for @frictionL1Name.
  ///
  /// In th, this message translates to:
  /// **'L1 — Micro-friction'**
  String get frictionL1Name;

  /// No description provided for @frictionL1Desc.
  ///
  /// In th, this message translates to:
  /// **'รอสักครู่แล้วยืนยัน'**
  String get frictionL1Desc;

  /// No description provided for @frictionL2Name.
  ///
  /// In th, this message translates to:
  /// **'L2 — Reflective pause'**
  String get frictionL2Name;

  /// No description provided for @frictionL2Desc.
  ///
  /// In th, this message translates to:
  /// **'บอกเหตุผลก่อนเปิด'**
  String get frictionL2Desc;

  /// No description provided for @frictionL3Name.
  ///
  /// In th, this message translates to:
  /// **'L3 — Full block'**
  String get frictionL3Name;

  /// No description provided for @frictionL3Desc.
  ///
  /// In th, this message translates to:
  /// **'บล็อกเต็มรูปแบบ (เปิดได้ด้วยฉุกเฉินเท่านั้น)'**
  String get frictionL3Desc;

  /// No description provided for @frictionL4Name.
  ///
  /// In th, this message translates to:
  /// **'L4 — Partner-gated'**
  String get frictionL4Name;

  /// No description provided for @frictionL4Desc.
  ///
  /// In th, this message translates to:
  /// **'ต้องผ่านการอนุมัติจาก Partner'**
  String get frictionL4Desc;

  /// No description provided for @frictionL4Locked.
  ///
  /// In th, this message translates to:
  /// **'ใช้ได้เมื่อเชื่อมต่อ Vault Partner'**
  String get frictionL4Locked;

  /// No description provided for @frictionEmergencySection.
  ///
  /// In th, this message translates to:
  /// **'ฉุกเฉิน'**
  String get frictionEmergencySection;

  /// No description provided for @frictionDebugSection.
  ///
  /// In th, this message translates to:
  /// **'ทดสอบ (เฉพาะ debug)'**
  String get frictionDebugSection;

  /// No description provided for @frictionDebugSimulate.
  ///
  /// In th, this message translates to:
  /// **'จำลองการเปิด {app}'**
  String frictionDebugSimulate(String app);

  /// No description provided for @recoveryTitle.
  ///
  /// In th, this message translates to:
  /// **'streak ของคุณหยุดที่ {days} วัน'**
  String recoveryTitle(int days);

  /// No description provided for @recoveryBody.
  ///
  /// In th, this message translates to:
  /// **'ไม่เป็นไร — ทุกคนมีวันแบบนี้'**
  String get recoveryBody;

  /// No description provided for @recoveryBest.
  ///
  /// In th, this message translates to:
  /// **'streak ที่ดีที่สุดของคุณคือ {best} วัน และยังอยู่ตรงนั้นเสมอ'**
  String recoveryBest(int best);

  /// No description provided for @recoveryQuestion.
  ///
  /// In th, this message translates to:
  /// **'บอกเราได้ถ้าอยากแชร์'**
  String get recoveryQuestion;

  /// No description provided for @recoveryReasonTired.
  ///
  /// In th, this message translates to:
  /// **'เหนื่อยเกินไป'**
  String get recoveryReasonTired;

  /// No description provided for @recoveryReasonEmergency.
  ///
  /// In th, this message translates to:
  /// **'มีเหตุฉุกเฉิน'**
  String get recoveryReasonEmergency;

  /// No description provided for @recoveryReasonMotivation.
  ///
  /// In th, this message translates to:
  /// **'ไม่มีแรงจูงใจ'**
  String get recoveryReasonMotivation;

  /// No description provided for @recoveryRestart.
  ///
  /// In th, this message translates to:
  /// **'เริ่มต้นใหม่วันนี้'**
  String get recoveryRestart;

  /// No description provided for @recoveryLater.
  ///
  /// In th, this message translates to:
  /// **'ไว้ทีหลัง'**
  String get recoveryLater;

  /// No description provided for @alarmTitle.
  ///
  /// In th, this message translates to:
  /// **'Session จบแล้ว'**
  String get alarmTitle;

  /// No description provided for @alarmBody.
  ///
  /// In th, this message translates to:
  /// **'คุณโฟกัสครบ {duration} แล้ว — กลับมาดูสรุปได้เลย'**
  String alarmBody(String duration);

  /// No description provided for @alarmChannelName.
  ///
  /// In th, this message translates to:
  /// **'Focus session'**
  String get alarmChannelName;

  /// No description provided for @alarmChannelDescription.
  ///
  /// In th, this message translates to:
  /// **'แจ้งเตือนเมื่อ session จบ'**
  String get alarmChannelDescription;
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
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
