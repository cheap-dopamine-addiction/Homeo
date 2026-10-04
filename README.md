# Homeo

**แอปพลิเคชันลดการเสพติด Dopamine และเสริมสร้าง Focus**

Homeo คือแอปมือถือแบบ cross-platform (Flutter, iOS + Android) ที่ช่วยให้ผู้ใช้ลดพฤติกรรมเสพติดสิ่งเร้าที่ให้ dopamine แบบฉับพลัน (short-form video, social feed, เกมมือถือ, notification loop) และสร้างความสามารถในการโฟกัสอย่างยั่งยืน ผ่านกลไก behavioral design ที่มีหลักฐานทางวิทยาศาสตร์รองรับ

> ดูรายละเอียดทั้งหมดใน [PRD](./docs/prd/PRD.md) — วิสัยทัศน์, งานวิจัยเชิงพฤติกรรมศาสตร์, สถาปัตยกรรม, และ roadmap

---

## Core Features

| ฟีเจอร์ | คำอธิบาย |
| --- | --- |
| **Focus Session** | จับเวลาโฟกัสพร้อม intention setting และบล็อกแอปกลุ่มเสี่ยงระหว่าง session |
| **Friction-based Intervention** | แรงเสียดทานแบบ adaptive (L0–L4) ก่อนเปิดแอปกลุ่มเสี่ยง แทนการบล็อกเบ็ดเสร็จ |
| **Vault Partner** | ระบบ accountability ที่มีเพื่อน/คนใกล้ตัวช่วยอนุมัติ/ปฏิเสธคำขอ override |
| **Distraction Logging & Analytics** | บันทึกและวิเคราะห์พฤติกรรม พร้อม Dopamine Load Index |
| **AI Coach** | คำแนะนำเชิงพฤติกรรมโดยอ้างอิงข้อมูลการใช้งานจริงของผู้ใช้ |
| **Offline-first** | ฟีเจอร์หลักทั้งหมดทำงานได้แบบ offline เต็มรูปแบบ |

**Philosophy:** Friction, not prohibition · Layered control, not absolute control · Progress over perfection · Transparency by design · Privacy-first accountability

---

## Tech Stack

| Layer | เทคโนโลยี |
| --- | --- |
| Mobile Client | Flutter (Dart) |
| State Management | Riverpod 2.x (code-gen) |
| Local DB | Drift (SQLite) + Hive |
| Backend | NestJS (Node.js/TypeScript) — modular monolith |
| Database | PostgreSQL |
| Cache/Queue | Redis + BullMQ |
| Auth | Firebase Authentication |
| Push Notification | FCM (Android) / APNs (iOS) |
| API Style | REST + WebSocket (real-time approval flow) |
| CI/CD | GitHub Actions, Codemagic (iOS) |
| Monitoring | Sentry |

---

## Project Structure (Monorepo)

```
dopamine-focus/
├── apps/
│   ├── mobile/            # Flutter app
│   └── backend/           # NestJS app
├── packages/
│   ├── api-contracts/     # OpenAPI spec + generated types (TS + Dart)
│   └── shared-config/     # eslint, tsconfig, prettier
├── infra/                 # docker, terraform/IaC, ci
├── docs/
│   └── prd/                # PRD และเอกสารประกอบ
└── .github/workflows/
```

Mobile app ใช้ Feature-first + pragmatic Clean Architecture (`data / domain / presentation` ต่อ feature) ดูรายละเอียดใน [หมวด 27 ของ PRD](./docs/prd/PRD.md#27-flutter-project-structure)

---

## Friction / Notification Module — ขอบเขตปัจจุบัน

> เอกสารเต็ม: [`Homeo — Friction_Notification Module_ Implementation Guide.md`](./Homeo%20—%20Friction_Notification%20Module_%20Implementation%20Guide.md)

PRD หลัก (หมวด 11, 17–21) อธิบายกรอบ friction แบบเต็มรูปแบบ (L0–L4, บล็อกแอปจริง, Vault Partner แบบ real-time) ซึ่งเป็นเป้าหมายระยะยาวของโปรดักต์ แต่สำหรับรอบงานปัจจุบัน (โครงงานจบ) เราตัดขอบเขตให้แคบลงเหลือเฉพาะ **ระบบแจ้งเตือน** และยังไม่มีการบล็อกแอปจริง เพื่อให้ demo ได้ภายในเวลาที่มี

### ทำอะไร (What)

ขอบเขตล่าสุดมีแค่ 3 อย่าง:

1. **แจ้งเตือนเมื่อเปิดแอปกลุ่มเสี่ยง** — ตรวจจับว่าแอปที่ผู้ใช้เลือกไว้ถูกเปิด แล้วยิง local notification เตือน
2. **แจ้งเตือน timer ของ focus session** — session เริ่ม/จบ
3. **แจ้งเตือนทั่วไป** — เช่น weekly summary

ไม่มี: การบล็อกแอปจริง (full block), friction gate ที่หน่วงเวลาจริงบนหน้าจอแอปอื่น, หรือ Vault Partner แบบเต็มรูปแบบ — สิ่งเหล่านี้ยังอยู่ในแผน แต่ไม่ได้อยู่ใน build รอบนี้

### เปลี่ยนอะไร (What changes)

| ส่วน | เดิม (ตาม PRD เต็ม) | ใหม่ (scope นี้) |
| --- | --- | --- |
| การตรวจจับการเปิดแอป | native blocker บล็อกจริง (ดู `BlockerBridge`) | ตรวจจับอย่างเดียว แล้วแจ้งเตือน ไม่บล็อก |
| Android | Accessibility Service + บล็อกแอป | Accessibility Service **อ่านแค่ `packageName`** (`canRetrieveWindowContent="false"`) ยิง notification ตรงจาก Kotlin |
| iOS | native screen-time/blocking API | ไม่มี native API ให้ third-party ใช้ (ต้อง FamilyControls entitlement) → ใช้ **Shortcuts Automation** เป็น workaround แทน |
| ไฟล์ที่ต้องแก้/สร้างใหม่ | — | ดูรายการทั้งหมดในหมวด 1 ของ implementation guide (`MainActivity.kt`, `accessibility_service_config.xml`, `friction_service_ios.dart`, `ios_shortcuts_guide_screen.dart`, `notification_service.dart` ฯลฯ) |
| Dependency ใหม่ | — | `flutter_local_notifications`, `shared_preferences`, `app_links`, `permission_handler` |

### ทำไมถึงเปลี่ยน (Why)

- **เวลาจำกัดของโครงงาน** — การบล็อกแอปจริงต้องใช้ native integration ที่ซับซ้อนและทดสอบยากทั้งสอง platform ส่วนระบบแจ้งเตือนพิสูจน์แนวคิด friction ได้โดยความเสี่ยงต่ำกว่ามาก
- **ข้อจำกัดทางเทคนิคของ iOS** — Apple ไม่เปิด public API ให้ third-party ตรวจจับ foreground app โดยไม่มี FamilyControls entitlement (ต้องมี paid Developer account) จึงไม่สามารถบล็อกแอปจริงบน iOS ได้ในสโคปนี้ ต้องใช้ Shortcuts Automation แทน ซึ่งเป็น workaround ที่ user ตั้งเองและลบได้ตลอดเวลา (พึ่ง willpower ไม่ใช่การล็อกจริง)
- **Data minimization (PRD หมวด 24.1)** — Accessibility Service ขอสิทธิ์ให้น้อยที่สุด (`canRetrieveWindowContent="false"`) คือรู้แค่ว่าแอปไหนถูกเปิด ไม่อ่านเนื้อหาบนจอ ลดความน่ากลัวตอนขอสิทธิ์และตรงกับหลัก privacy-first ของโปรดักต์
- **ความทนทานเมื่อแอปโดน kill** — เดิมพึ่ง Flutter engine (EventChannel) ส่งต่อให้ Dart ยิง notification ซึ่งพังถ้าแอปโดน background-kill จึงเปลี่ยนให้ Kotlin ยิง notification ตรงจาก native เลย ทำงานได้แม้ Flutter ไม่ตื่น

### ทำยังไง (How)

**Android (กลไกหลัก, ทำงานได้เต็มรูปแบบ):**
1. เพิ่ม dependencies ใน `pubspec.yaml`
2. สร้าง `notification_service.dart` (wrapper รอบ `flutter_local_notifications`) และทดสอบยิง notification พื้นฐานก่อน
3. สร้าง `res/xml/accessibility_service_config.xml` + แก้ `AndroidManifest.xml` ให้ประกาศ service
4. เขียน `MainActivity.kt` ใหม่ทั้งหมด — register `MethodChannel` (`isAccessibilityEnabled`, `openAccessibilitySettings`, `setBlockedPackages`) และอ่าน/เขียน `SharedPreferences` ให้ตรง key กับที่ Flutter ใช้ (ระวัง prefix `flutter.`)
5. แก้ `FocusAccessibilityService.kt` 2 จุด: อ่าน blocked list จาก `SharedPreferences` ทุกครั้งที่ `onServiceConnected()` แทนพึ่ง static var, และยิง `NotificationCompat` ตรงจาก Kotlin แทนรอ Flutter
6. สร้าง `blocked_apps_setup_screen.dart` (เลือก/พิมพ์ package id ของแอปที่จะติดตาม) + `friction_provider.dart` (Riverpod notifier เชื่อม UI กับ native layer)
7. ทดสอบบนเครื่องจริงเท่านั้น (ไม่ใช่ emulator) และเตรียม onboarding แนะนำปิด battery optimization เฉพาะยี่ห้อ (Xiaomi/Oppo/Vivo มักจะ kill background service)

**iOS (demo ใช้งานได้จริงแต่ไม่ 100%):**
1. ลงทะเบียน custom URL scheme `homeo://` ใน `Info.plist` (`CFBundleURLTypes`)
2. แก้ `friction_service_ios.dart` ให้ `onBlockedAppOpened` รับค่าจริงจาก deep link ผ่าน `app_links` แทน stub เดิม
3. เพิ่ม deep link listener ใน `main.dart` — parse `homeo://distraction-event?app=<id>` แล้วบันทึกลง local DB (`distraction_events`, offline-first) และยิง notification
4. สร้าง `ios_shortcuts_guide_screen.dart` สอน user ตั้งค่า Shortcuts Automation ทีละขั้น (เลือกแอป → "Is Opened" → ปิด "Ask Before Running" → Action "Open URLs" ไปยัง deep link ของแอปนั้น) ต้องทำซ้ำทีละแอป ไม่มีทาง bulk setup
5. สื่อสารข้อจำกัดให้ user เห็นชัดในแอป: Automation ลบเองได้ตลอดเวลา, อาจมี delay เล็กน้อย, ไม่ใช่การล็อกจริง

ลำดับขั้นตอนแบบเต็ม (12 ขั้น ทั้ง Android/iOS/เอกสาร) และตารางสรุปข้อจำกัดของแต่ละ platform สำหรับใช้เขียนรายงาน อยู่ในหมวด 6–7 ของ implementation guide

---

## Getting Started

> โปรเจกต์อยู่ระหว่างการพัฒนา (moving from Figma prototype → production Flutter build) ขั้นตอนด้านล่างเป็น placeholder เบื้องต้น ปรับตามการตั้งค่าจริงของทีม

### Prerequisites

- Flutter SDK (เวอร์ชันล่าสุดที่ stable)
- Node.js + npm/pnpm
- Docker (สำหรับ local PostgreSQL/Redis)
- Firebase project (Auth + FCM)

### Backend

```bash
cd apps/backend
npm install
npm run start:dev
```

### Mobile

```bash
cd apps/mobile
flutter pub get
flutter run
```

---

## Testing

- Unit tests: `flutter_test` (mobile), `jest` (backend) — เป้าหมาย ≥80% coverage ของ business logic
- Widget tests: `flutter_test`
- Integration tests: `jest` + testcontainers (Postgres)
- E2E: Patrol/Maestro — เฉพาะ critical flow (onboarding, focus session, vault override)

ดูรายละเอียดเต็มใน [หมวด 30 ของ PRD](./docs/prd/PRD.md#30-testing-strategy)

---

## Roadmap

- **MVP** — Auth, Onboarding, Focus Session, Distraction Logging, Streak, Friction L0–L2, Analytics พื้นฐาน, Offline-first
- **V1 (Public Launch)** — Vault Partner เต็มรูปแบบ, Friction L3–L4, Emergency Recovery, AI Coach เวอร์ชันแรก
- **V2** — AI Coach แบบ conversational, adaptive friction ขั้นสูง, multi-partner support
- **Long-term** — Web Companion Dashboard, integrations (calendar/task manager), enterprise mode, wearable support

ดูรายละเอียดใน [หมวด 36 ของ PRD](./docs/prd/PRD.md#36-mvp--v1--v2--long-term-roadmap)

หมายเหตุ: Friction/Notification module ในสโคปปัจจุบัน (ดูหัวข้อด้านบน) เป็น subset ที่ตัดขอบเขตเฉพาะรอบงานนี้ — การบล็อกแอปจริงแบบเต็มรูปแบบ (L3 full block, Vault Partner แบบ real-time) ยังอยู่ใน roadmap ของ V1 ตาม PRD

---

## Privacy & Security

- Privacy-by-design และ data minimization — ไม่เก็บเนื้อหาที่ผู้ใช้เสพ เก็บเฉพาะ app package + เวลา
- Encryption at rest/in transit, column-level encryption สำหรับข้อมูล sensitive (เช่น reflection entries)
- Consent-based visibility สำหรับ Vault Partner — granular, ไม่ใช่ all-or-nothing

ดูรายละเอียดใน [หมวด 23–24 ของ PRD](./docs/prd/PRD.md#23-security-model)

---

## License

TBD

## Contributing

โปรเจกต์อยู่ในช่วงพัฒนา — แนวทาง contribution
