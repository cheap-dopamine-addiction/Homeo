import 'package:flutter/foundation.dart';

/// Facts the coach may mention. Anything null/zero is simply not claimed.
@immutable
class CoachFacts {
  const CoachFacts({
    this.bestWindowStartHour,
    this.topAppToday,
    this.topAppTodayCount = 0,
    this.streak = 0,
  });

  final int? bestWindowStartHour;
  final String? topAppToday;
  final int topAppTodayCount;
  final int streak;
}

/// Suggested prompts shown as chips (design: `SUGGESTED_PROMPTS`).
const List<(String th, String en)> coachSuggestedPrompts = [
  ('ช่วยดูรูปแบบการโฟกัสของฉัน', 'Look at my focus pattern'),
  ('ช่วยวาง session วันนี้', "Help me plan today's sessions"),
  ('ทำไมวันนี้ฉันหลุดโฟกัสบ่อย?', 'Why do I keep losing focus today?'),
  ('ลด session ช่วงบ่ายได้อย่างไร?', 'How can I shorten afternoon sessions?'),
];

/// Local rule-based answers. The design's canned replies quoted fixed
/// numbers; here every number comes from [CoachFacts] or is left out.
abstract final class CoachResponder {
  static String reply(String userText, CoachFacts f, {required bool thai}) {
    final text = userText.trim();
    final idx = coachSuggestedPrompts.indexWhere(
      (p) => p.$1 == text || p.$2 == text,
    );
    String t(String th, String en) => thai ? th : en;

    String window(int h) =>
        '${h.toString().padLeft(2, '0')}:00–${((h + 2) % 24).toString().padLeft(2, '0')}:00';

    switch (idx) {
      case 0:
        final h = f.bestWindowStartHour;
        if (h == null) {
          return t(
            'ตอนนี้ยังมีข้อมูล session ในช่วง 7 วันไม่พอที่จะเห็นรูปแบบ ลองทำ session สักสองสามครั้งแล้วกลับมาถามอีกนะ\n\nอยากให้ช่วยวางแผน session แรกไหม?',
            "There isn't enough session data from the last 7 days to see a pattern yet. Try a few sessions and ask again.\n\nWant help planning your first one?",
          );
        }
        return t(
          'จากข้อมูล 7 วันที่ผ่านมา คุณโฟกัสได้มากที่สุดช่วง ${window(h)}\n\nข้อมูลนี้ยังไม่มากพอที่จะสรุปแน่ชัด แต่เป็นสัญญาณที่น่าสังเกต อยากลองจัดงานสำคัญไว้ช่วงนี้ไหม?',
          'Over the last 7 days you focused most around ${window(h)}.\n\nThat is not enough data to be certain, but it is worth noticing. Want to try putting important work in that window?',
        );
      case 1:
        final h = f.bestWindowStartHour ?? 9;
        final start = '${h.toString().padLeft(2, '0')}:00';
        return t(
          'ขอแนะนำ:\n\n$start — Deep work (60–90 นาที)\nพักสั้น ๆ\nต่อด้วย session อ่านหรือรีวิว (45 นาที)\n\nช่วงบ่ายถ้ายังมีงาน ลอง session 25 นาทีก่อน เพื่อดูว่าสมาธิยังไหวไหม\n\nอยากปรับตรงไหนไหม?',
          'Suggestion:\n\n$start — Deep work (60–90 min)\nShort break\nThen a reading or review session (45 min)\n\nIf you still have work in the afternoon, start with 25 minutes to see how your focus holds.\n\nWant to adjust anything?',
        );
      case 2:
        final app = f.topAppToday;
        if (app == null || f.topAppTodayCount == 0) {
          return t(
            'Homeo ยังไม่เห็นการพยายามเปิดแอปที่ระวังในวันนี้ บางครั้งมันเป็นเรื่องของวัน ไม่ใช่ความล้มเหลว — พักก็ได้ แล้วค่อยกลับมา\n\nอยากลองทำ session สั้น ๆ 15 นาทีดูไหม?',
            "Homeo hasn't seen any attempts to open watched apps today. Some days are just like that, not a failure — rest if you need to, then come back.\n\nWant to try a short 15-minute session?",
          );
        }
        return t(
          'ไม่แน่ใจอย่างแน่ชัด แต่จากข้อมูลใน Homeo: วันนี้คุณพยายามเปิด $app ${f.topAppTodayCount} ครั้ง\n\nบางครั้งมันเป็นเรื่องของวัน ไม่ใช่ความล้มเหลว — พักก็ได้ แล้วค่อยกลับมา อยากลองทำ session สั้น ๆ 15 นาทีดูไหม?',
          "I'm not certain, but from your Homeo data: you tried to open $app ${f.topAppTodayCount} times today.\n\nSome days are just like that, not a failure — rest if you need to, then come back. Want to try a short 15-minute session?",
        );
      case 3:
        return t(
          'ลองสิ่งเหล่านี้ดูนะ:\n\n1. ลด session จาก 45 เหลือ 25 นาที ในช่วง 14:00–16:00\n2. เพิ่ม friction ให้แอปที่มักเปิดในช่วงนี้\n3. ตั้ง intention ก่อน session สั้น ๆ ว่าจะทำอะไร\n\nอยากให้ช่วยตั้งค่า friction สำหรับช่วงนี้ไหม?',
          'Try these:\n\n1. Shorten sessions from 45 to 25 minutes between 14:00 and 16:00\n2. Add friction to the apps you tend to open then\n3. Write a short intention before each session\n\nWant help setting up friction for that time?',
        );
      default:
        return t(
          'ขอบคุณที่แชร์นะ ฉันเข้าใจแล้ว\n\nถ้าต้องการ คุณสามารถดูรายละเอียดใน Insights ได้เลย หรืออยากให้ช่วยเรื่องอื่นไหม?',
          'Thanks for sharing — I understand.\n\nYou can see the details in Insights, or tell me if you want help with something else.',
        );
    }
  }
}
