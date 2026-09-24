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

โปรเจกต์อยู่ในช่วงพัฒนาภายในทีม — แนวทาง contribution จะประกาศเพิ่มเติมเมื่อ repo พร้อม public
