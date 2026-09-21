// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appName => 'Homeo';

  @override
  String get tabFocus => 'Focus';

  @override
  String get tabVault => 'Vault';

  @override
  String get tabInsights => 'Insights';

  @override
  String get tabAiCoach => 'AI Coach';

  @override
  String get tabSettings => 'Settings';

  @override
  String get comingSoon => 'ส่วนนี้กำลังพัฒนา';

  @override
  String get greetingMorning => 'สวัสดีตอนเช้า';

  @override
  String get greetingAfternoon => 'สวัสดีตอนบ่าย';

  @override
  String get greetingEvening => 'สวัสดีตอนเย็น';

  @override
  String streakDays(int count) {
    return '$count วันติดต่อกัน';
  }

  @override
  String streakBest(int count) {
    return 'สูงสุด $count วัน';
  }

  @override
  String get streakNone => 'เริ่ม streak ใหม่ได้วันนี้';

  @override
  String get focusPrompt => 'วันนี้อยากทำอะไรให้เสร็จหนึ่งอย่าง?';

  @override
  String get focusStartCta => 'เริ่ม Focus Session';

  @override
  String get statFocusToday => 'โฟกัสวันนี้';

  @override
  String get statFocusWeek => 'โฟกัสสัปดาห์นี้';

  @override
  String get statSessionsToday => 'Session วันนี้';

  @override
  String lastSessionTitle(String duration) {
    return 'Session ล่าสุด: $duration';
  }

  @override
  String get lastSessionNoIntention => 'ไม่ได้ระบุเป้าหมาย';

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours ชม. $minutes น.';
  }

  @override
  String durationHoursOnly(int hours) {
    return '$hours ชม.';
  }

  @override
  String durationMinutesOnly(int minutes) {
    return '$minutes น.';
  }

  @override
  String durationPresetMinutes(int minutes) {
    return '$minutes นาที';
  }

  @override
  String get durationCustom => 'กำหนดเอง';

  @override
  String get setupTitle => 'ตั้งค่า Session';

  @override
  String get setupClose => 'ปิด';

  @override
  String get setupDurationLabel => 'ระยะเวลา';

  @override
  String get setupIntentionLabel => 'เป้าหมายของ session นี้';

  @override
  String get setupIntentionHint => 'เช่น เขียนรายงาน Chapter 3 ให้เสร็จ';

  @override
  String get setupIntentionHelper =>
      'ไม่จำเป็นต้องระบุ — เพื่อเตือนความจำของคุณเอง';

  @override
  String setupStartButton(String duration) {
    return 'เริ่ม Session $duration';
  }

  @override
  String get pickerTitle => 'กำหนดระยะเวลาเอง';

  @override
  String get pickerConfirm => 'ตกลง';

  @override
  String get pickerCancel => 'ยกเลิก';

  @override
  String get activeStatusFocusing => 'กำลังโฟกัส';

  @override
  String get activeStatusPaused => 'หยุดชั่วคราว';

  @override
  String get activeExit => 'ออกจาก Session';

  @override
  String get activeGoalLabel => 'เป้าหมาย';

  @override
  String get activePause => 'พัก';

  @override
  String get activeResume => 'กลับมาโฟกัส';

  @override
  String activePausesUsed(int used, int total) {
    return 'พัก $used/$total ครั้งวันนี้';
  }

  @override
  String activeTimerSemantics(String status, String time) {
    return '$status เหลือ $time';
  }

  @override
  String get exitGateTitle => 'ต้องการออกจาก session จริงๆ ไหม?';

  @override
  String get exitGateSubtitle => 'ไม่เป็นไร — บอกเหตุผลได้ถ้าอยากบอก';

  @override
  String get exitReasonEmergency => 'เหตุฉุกเฉิน';

  @override
  String get exitReasonTired => 'เหนื่อยเกินไป';

  @override
  String get exitReasonDistracted => 'ไม่มีสมาธิ';

  @override
  String get exitReasonOther => 'อื่นๆ';

  @override
  String get commonBackToFocus => 'กลับไปโฟกัส';

  @override
  String get exitGateLeave => 'ออกจาก session';

  @override
  String exitGateLeaveWait(int seconds) {
    return 'ออกจาก session (${seconds}s)';
  }

  @override
  String pauseLimitTitle(int used, int total) {
    return 'ใช้ครบจำนวนพักวันนี้แล้ว ($used/$total)';
  }

  @override
  String get pauseLimitBody =>
      'ลองหายใจเข้าลึกๆ แล้วกลับไปโฟกัสได้เลย\nคุณทำได้ดีมากมาถึงตรงนี้แล้ว';

  @override
  String get summaryCompletedTitle => 'เยี่ยมมากเลย!';

  @override
  String get summaryAbortedTitle => 'ขอบคุณที่พยายาม';

  @override
  String summaryFocused(String duration) {
    return 'คุณโฟกัสได้ $duration';
  }

  @override
  String get summaryAbortedNote => 'Session ถูกยกเลิกก่อนเวลา';

  @override
  String get summaryMoodQuestion => 'ระหว่าง session รู้สึกอย่างไร?';

  @override
  String get moodHard => 'ยาก';

  @override
  String get moodOkay => 'ปกติ';

  @override
  String get moodGood => 'ดี';

  @override
  String get moodGreat => 'ยอดเยี่ยม';

  @override
  String get summarySave => 'บันทึกและกลับหน้าหลัก';

  @override
  String get summarySkip => 'ข้าม';

  @override
  String gateAwarenessTitle(String app, int count) {
    return 'เปิด $app ครั้งที่ $count วันนี้';
  }

  @override
  String get gateMicroTitle => 'ยืนยันก่อนเปิด';

  @override
  String gateMicroBody(String app) {
    return 'ยืนยันว่าต้องการเปิด $app จริงๆ ลองพิจารณาดูก่อนนะ';
  }

  @override
  String get gateReflectiveTitle => 'หยุดสักครู่ — กลับไปโฟกัสกันไหม?';

  @override
  String get gateReflectiveBody =>
      'ตอนนี้เป็นช่วงที่คุณตั้งใจปกป้องไว้ ถ้ายังอยากเปิด บอกเราได้ว่าเพราะอะไร';

  @override
  String get gateReasonLabel => 'เหตุผลที่ต้องการเปิด';

  @override
  String get gateReasonHint => 'พิมพ์สั้นๆ ก็พอ';

  @override
  String get gateReasonRest => 'อยากพัก';

  @override
  String get gateReasonTask => 'มีเรื่องต้องทำ';

  @override
  String get gateBlockTitle => 'ตอนนี้เป็นช่วง Focus ของคุณ';

  @override
  String get gateBlockBody =>
      'ลองกลับไปทำสิ่งที่ตั้งใจไว้ก่อนนะ\nคุณทำได้แน่นอน';

  @override
  String get gatePartnerTitle => 'ปกป้องร่วมกับ Partner';

  @override
  String get gatePartnerBody =>
      'แอปนี้อยู่ระดับ L4 การเปิดต้องผ่านการอนุมัติจาก Vault Partner ของคุณ';

  @override
  String get gatePartnerRequest => 'ส่งคำขอ Override';

  @override
  String get gatePartnerPending => 'ส่งคำขอแล้ว — รอ Partner ตอบ';

  @override
  String gatePartnerCoolingOff(String time) {
    return 'ถ้า Partner ไม่ตอบ จะปลดบล็อกอัตโนมัติใน $time';
  }

  @override
  String get gatePartnerDenied => 'Partner ยังไม่อนุมัติ — กลับไปโฟกัสก่อนนะ';

  @override
  String gateOpenApp(String app) {
    return 'เปิด $app';
  }

  @override
  String gateOpenAppWait(String app, int seconds) {
    return 'เปิด $app (${seconds}s)';
  }

  @override
  String get gateConfirm => 'ยืนยัน';

  @override
  String gateConfirmWait(int seconds) {
    return 'ยืนยัน ($seconds)';
  }

  @override
  String get gateEscalatedNote =>
      'เพิ่มระดับอัตโนมัติ เพราะพยายามเปิดหลายครั้งในเวลาสั้นๆ';

  @override
  String get gateSessionNote => 'กำลังอยู่ในช่วง Focus session';

  @override
  String get emergencyLink => 'ฉุกเฉิน?';

  @override
  String get emergencyTitle => 'ต้องการปลดบล็อกทันทีเพื่อเหตุฉุกเฉินใช่ไหม?';

  @override
  String emergencyUsage(int used, int max) {
    return 'ใช้ฉุกเฉินไปแล้ว $used/$max ครั้งเดือนนี้';
  }

  @override
  String emergencyBody(int minutes) {
    return 'การใช้ฉุกเฉินจะปลดบล็อกทันที $minutes นาที และบันทึกการใช้งานไว้';
  }

  @override
  String get emergencyConfirm => 'ใช้ฉุกเฉิน';

  @override
  String get emergencyExhaustedTitle => 'ใช้ครบโควต้าฉุกเฉินเดือนนี้แล้ว';

  @override
  String get emergencyExhaustedBody =>
      'หากเป็นเหตุฉุกเฉินจริง โทร 1669 (การแพทย์ฉุกเฉิน) หรือ 191 (ตำรวจ) ได้ทันที';

  @override
  String emergencyDone(int minutes) {
    return 'ปลดบล็อกแล้ว $minutes นาที';
  }

  @override
  String get settingsTitle => 'ตั้งค่า';

  @override
  String get settingsFrictionTile => 'Friction และแอปที่ระวัง';

  @override
  String get settingsFrictionTileSubtitle => 'ปรับว่าการเปิดแอปเสี่ยงยากแค่ไหน';

  @override
  String get frictionScreenTitle => 'Friction';

  @override
  String get frictionDefaultSection => 'ระดับเริ่มต้น';

  @override
  String get frictionAppsSection => 'แอปที่ระวังเป็นพิเศษ';

  @override
  String get frictionAppsHint =>
      'เปิดสวิตช์เพื่อให้แอปนั้นต้องผ่าน friction ก่อนเปิด';

  @override
  String get frictionL0Name => 'L0 — Awareness';

  @override
  String get frictionL0Desc => 'แบนเนอร์เตือนเงียบๆ';

  @override
  String get frictionL1Name => 'L1 — Micro-friction';

  @override
  String get frictionL1Desc => 'รอสักครู่แล้วยืนยัน';

  @override
  String get frictionL2Name => 'L2 — Reflective pause';

  @override
  String get frictionL2Desc => 'บอกเหตุผลก่อนเปิด';

  @override
  String get frictionL3Name => 'L3 — Full block';

  @override
  String get frictionL3Desc => 'บล็อกเต็มรูปแบบ (เปิดได้ด้วยฉุกเฉินเท่านั้น)';

  @override
  String get frictionL4Name => 'L4 — Partner-gated';

  @override
  String get frictionL4Desc => 'ต้องผ่านการอนุมัติจาก Partner';

  @override
  String get frictionL4Locked => 'ใช้ได้เมื่อเชื่อมต่อ Vault Partner';

  @override
  String get frictionEmergencySection => 'ฉุกเฉิน';

  @override
  String get frictionDebugSection => 'ทดสอบ (เฉพาะ debug)';

  @override
  String frictionDebugSimulate(String app) {
    return 'จำลองการเปิด $app';
  }

  @override
  String recoveryTitle(int days) {
    return 'streak ของคุณหยุดที่ $days วัน';
  }

  @override
  String get recoveryBody => 'ไม่เป็นไร — ทุกคนมีวันแบบนี้';

  @override
  String recoveryBest(int best) {
    return 'streak ที่ดีที่สุดของคุณคือ $best วัน และยังอยู่ตรงนั้นเสมอ';
  }

  @override
  String get recoveryQuestion => 'บอกเราได้ถ้าอยากแชร์';

  @override
  String get recoveryReasonTired => 'เหนื่อยเกินไป';

  @override
  String get recoveryReasonEmergency => 'มีเหตุฉุกเฉิน';

  @override
  String get recoveryReasonMotivation => 'ไม่มีแรงจูงใจ';

  @override
  String get recoveryRestart => 'เริ่มต้นใหม่วันนี้';

  @override
  String get recoveryLater => 'ไว้ทีหลัง';

  @override
  String get alarmTitle => 'Session จบแล้ว';

  @override
  String alarmBody(String duration) {
    return 'คุณโฟกัสครบ $duration แล้ว — กลับมาดูสรุปได้เลย';
  }

  @override
  String get alarmChannelName => 'Focus session';

  @override
  String get alarmChannelDescription => 'แจ้งเตือนเมื่อ session จบ';
}
