Product Requirements Document (PRD)

แอปพลิเคชันลดการเสพติด Dopamine และเสริมสร้าง Focus (Homeo)

Product & Engineering Team

เวอร์ชัน 1.0 — กรกฎาคม 2026
**[v1.1] อัปเดตล่าสุด — ตุลาคม 2026 (รายการการเปลี่ยนแปลงอยู่ในหมวด 0 ด้านล่าง ป้าย [v1.1] ทำเครื่องหมายทุกจุดที่แก้หรือเพิ่ม)**

Table of Contents

# 0. [v1.1] บันทึกการปรับปรุงจาก v1.0

ฉบับ v1.1 ปรับขอบเขตตามข้อจำกัดด้านงบประมาณและแพลตฟอร์ม และปรับสีให้ตรงกับ Prototype (Figma Make, ไฟล์ `Homeo_P-type_.zip`) ซึ่งถือเป็น master reference ด้านดีไซน์

| หัวข้อ | v1.0 | v1.1 | เหตุผล |
|---|---|---|---|
| กลไกหลักการคุมแอป | บล็อกแอปจริง (enforcement) | **การแจ้งเตือนเมื่อเปิดแอปที่เลือก (warning-only)** ไม่บล็อก ไม่ปิดแอป | งบประมาณ: iOS ต้องใช้ FamilyControls ซึ่งต้องมี paid Apple Developer account |
| การตรวจจับการเปิดแอป | ไม่ได้ระบุวิธีเฉพาะ | Android: AccessibilityService (native) / iOS: Shortcuts Automation → deep link | ไม่มีค่าใช้จ่าย และสอดคล้องกับ platform |
| Friction L0–L4 | ระดับการบล็อกที่บังคับใช้ | ระดับการเตือนและหยุดคิด (L3 ไม่ล็อก, L4 เลื่อนไป v1.1) | สอดคล้องกับ scope ใหม่ |
| Vault Partner / L4 | MVP ถึง V1 | เลื่อนไป v1.1 | ต้องมี backend และการอนุมัติที่บังคับใช้ไม่ได้ใน scope ปัจจุบัน |
| Backend / Cloud | NestJS, PostgreSQL, Firebase Auth, FCM, AWS ECS | MVP เป็น local-first ทั้งหมด (Drift) | งบประมาณ |
| Emergency | ปลดบล็อกทันที | หยุดการเตือนชั่วคราว 15 นาที (โควต้าเดิม 3 ครั้ง/เดือน) | ไม่มีการบล็อกให้ปลด |
| AI Coach | LLM | MVP เป็น rule-based ประมวลผลในเครื่อง | ค่าใช้จ่าย API และการพึ่งพาเครือข่าย |
| Export | CSV / PDF | MVP: CSV / JSON | PDF ไม่ทำงานตาม audit |
| สี (Design tokens) | Indigo #3730A3, Amber #F59E0B, Muted Red #DC2626 | ชุดสีจาก Prototype (หมวด 12.2.1) | Prototype เป็น master reference |
| ฟอนต์ | Inter | Nunito (Prototype) + Noto Sans Thai (fallback ภาษาไทย) | Prototype ใช้ Nunito |

---

# 1. Executive Summary

**Homeo** คือแอปพลิเคชันมือถือแบบ cross-platform (Flutter, iOS + Android) ที่ออกแบบมาเพื่อช่วยให้ผู้ใช้ลดพฤติกรรมเสพติดสิ่งเร้าที่ให้ dopamine แบบฉับพลัน (short-form video, social feed, เกมมือถือ, notification loop) และสร้างความสามารถในการโฟกัสอย่างยั่งยืนขึ้นมาใหม่ ผ่านกลไก behavioral design ที่มีหลักฐานทางวิทยาศาสตร์รองรับ (evidence-informed), ระบบเพื่อนช่วยรับผิดชอบ (Vault Partner), การสร้างแรงเสียดทานเชิงกลยุทธ์ (intentional friction), การสะท้อนตนเอง (reflection), และการวิเคราะห์ข้อมูลพฤติกรรม (analytics)

**[v1.1] การเปลี่ยนแปลงสำคัญ:** ในเวอร์ชัน 1.1 Homeo ทำหน้าที่ **เตือน ไม่ล็อก** คือเมื่อผู้ใช้เปิดแอปที่เลือกไว้ ระบบจะตรวจจับและแจ้งเตือนพร้อมจำนวนครั้งที่เปิดในวันนั้น และเปิดหน้า reflective pause ให้ผู้ใช้เลือกเอง Homeo ไม่บล็อก ไม่ปิด และไม่ควบคุมแอปของผู้ใช้ ข้อจำกัดนี้แสดงให้ผู้ใช้เห็นในแอปอย่างชัดเจน (หมวด 11.4, 21.4)

โปรเจกต์นี้เริ่มต้นจาก MVP มือถือเป็นหลัก (mobile-first) โดยไม่มีเว็บแพลตฟอร์มในระยะแรก และไม่มีแผนสร้างรายได้ (monetization) ในช่วงเริ่มต้น — เป้าหมายหลักคือการพิสูจน์คุณค่าของผลิตภัณฑ์ (product-value validation) และสร้างฐานผู้ใช้ที่มีพฤติกรรมเปลี่ยนแปลงจริง (behavior change) ก่อนพิจารณาโมเดลรายได้ในอนาคต

เอกสารฉบับนี้เป็น PRD แบบครบวงจร ครอบคลุมตั้งแต่กลยุทธ์ผลิตภัณฑ์ งานวิจัยเชิงพฤติกรรมศาสตร์ การวิเคราะห์คู่แข่ง สถาปัตยกรรมระบบ ฐานข้อมูล API ความปลอดภัย ไปจนถึงแผนการพัฒนาและ roadmap ระยะยาว เพื่อใช้เป็นเอกสารอ้างอิงหลักสำหรับทีมวิศวกรรมที่จะสร้างผลิตภัณฑ์นี้จริง

**สิ่งที่ไม่ได้อยู่ในขอบเขต (Out of Scope) ของเวอร์ชัน 1.0:**
- เว็บแพลตฟอร์ม (จะกล่าวถึงเป็น future strategy เท่านั้น)
- โมเดลรายได้/การชำระเงิน (ไม่มีแผนตอนนี้ ทุก feature เปิดให้ใช้ฟรี)
- Enterprise/Team mode
- **[v1.1] การบล็อกแอปจริง (app enforcement) ทุกระดับ** — ดูหมวด 39

---

# 2. Vision / Mission / Product Philosophy

## 2.1 Vision

“ช่วยให้ทุกคนสามารถควบคุมความสนใจของตัวเองคืนมาได้ ไม่ใช่ด้วยการห้ามเทคโนโลยี แต่ด้วยการออกแบบสภาพแวดล้อมที่สนับสนุนเจตจำนงที่แท้จริงของผู้ใช้”

เราเชื่อว่าปัญหาไม่ได้อยู่ที่ “เทคโนโลยีเป็นสิ่งไม่ดี” แต่อยู่ที่ระบบสิ่งเร้าจำนวนมากถูกออกแบบมาให้ใช้ประโยชน์จากกลไก dopamine ของสมองมนุษย์เพื่อดึงความสนใจให้นานที่สุดโดยไม่คำนึงถึงสวัสดิภาพผู้ใช้ (attention economy) เป้าหมายของเราคือสร้างเครื่องมือที่ “เอียงสนามแข่ง” กลับมาให้ผู้ใช้ได้เปรียบอีกครั้ง

## 2.2 Mission

สร้างระบบ behavioral infrastructure ที่ช่วยให้ผู้ใช้:
1. ตระหนักรู้พฤติกรรมของตนเอง (self-awareness) ผ่านการติดตามและสะท้อนผล
2. ลดแรงกระตุ้นจาก cheap dopamine ด้วยการเตือนและจังหวะหยุดคิดที่ออกแบบมาอย่างมีเหตุผล
3. สร้างนิสัยการโฟกัสที่ยั่งยืนผ่านการทำซ้ำ การเสริมแรงเชิงบวก และอัตลักษณ์ตนเอง (identity-based habits)
4. ได้รับการสนับสนุนทางสังคมผ่านระบบ accountability partner แบบที่เคารพความเป็นส่วนตัว (v1.1)

## 2.3 Product Philosophy

| หลักการ | ความหมาย |
| --- | --- |
| **Friction, not prohibition** | **[v1.1] Nudge and friction, not prohibition:** เราไม่บล็อกแบบเบ็ดเสร็จ แต่เพิ่มการเตือนและแรงเสียดทานที่เหมาะสมเพื่อให้ผู้ใช้ “หยุดคิด” ก่อนกระทำ |
| **Layered control, not absolute control** | ผู้ใช้ยังคงมี autonomy สูงสุด ระบบไม่ล็อกจนใช้งานไม่ได้ในกรณีฉุกเฉิน |
| **Progress over perfection** | เน้นความสม่ำเสมอระยะยาวมากกว่าความสมบูรณ์แบบระยะสั้น (ไม่ลงโทษเมื่อ streak ขาด) |
| **Transparency by design** | ผู้ใช้ (และ Vault Partner) ต้องเข้าใจว่าเหตุใดระบบจึงทำงานแบบนั้นเสมอ ไม่มี dark pattern **[v1.1] รวมถึงข้อจำกัดของระบบ (เช่น ระบบเตือนแต่ไม่บล็อก)** |
| **Privacy-first accountability** | การแชร์ข้อมูลกับ Vault Partner ต้องเป็นไปโดยสมัครใจ ควบคุมได้ และย้อนกลับได้ |
| **Evidence-informed, not gimmick-driven** | ทุกกลไกพฤติกรรมต้องอ้างอิงงานวิจัยที่ตรวจสอบได้ |

---

# 3. Scientific Research & Behavioral Science

การออกแบบผลิตภัณฑ์นี้อ้างอิงกรอบแนวคิดและงานวิจัยด้านจิตวิทยาพฤติกรรมและประสาทวิทยาศาสตร์ ดังนี้

## 3.1 กลไกทางประสาทวิทยาของ Dopamine

Dopamine ไม่ใช่ “สารแห่งความสุข” โดยตรง แต่เป็นสารสื่อประสาทที่เกี่ยวข้องกับ **การคาดการณ์รางวัล (reward prediction)** และแรงจูงใจในการแสวงหา (wanting) มากกว่าความพึงพอใจ (liking) งานของ Wolfram Schultz เกี่ยวกับ reward prediction error อธิบายว่าสมองปล่อย dopamine สูงสุดเมื่อรางวัลนั้น “คาดเดาไม่ได้” (variable/unpredictable) ซึ่งเป็นหลักการเดียวกับที่ระบบ social media feed, short-form video และเกมมือถือใช้ในการออกแบบ infinite scroll และ notification

จิตแพทย์ Anna Lembke (Stanford, ผู้เขียน *Dopamine Nation*) เสนอแนวคิด “dopamine balance” ว่าสมองพยายามรักษาสมดุลระหว่างความสุขและความเจ็บปวด (pleasure-pain balance) การเสพสิ่งเร้าที่ให้ dopamine สูงซ้ำ ๆ ทำให้เกิด tolerance และ “dopamine deficit state” ซึ่งลดความสามารถในการรู้สึกพอใจกับกิจกรรมที่ให้ dopamine ต่ำแต่ยั่งยืน (เช่น งานที่ต้องใช้สมาธิลึก) แนวคิด “dopamine fasting/detox” ที่เธอเสนอเป็นพื้นฐานของฟีเจอร์ friction และ recovery mode ในแอปนี้

## 3.2 Habit Loop และ Behavior Change Models

- **Habit Loop (Charles Duhigg / BJ Fogg):** ประกอบด้วย Cue → Routine → Reward การเปลี่ยนนิสัยที่ยั่งยืนต้องแทรกแซงที่ cue หรือเปลี่ยน routine ไม่ใช่พึ่งพา willpower เพียงอย่างเดียว
- **Fogg Behavior Model (B=MAP):** พฤติกรรมจะเกิดขึ้นเมื่อ Motivation, Ability และ Prompt มาบรรจบกันพร้อมกัน **[v1.1]** การเตือนเมื่อเปิดแอปทำหน้าที่เป็น Prompt ในจังหวะที่ผู้ใช้กำลังจะทำพฤติกรรมที่ไม่พึงประสงค์ ส่วน reflective pause ลด Ability ชั่วคราวด้วยการบังคับให้หยุดคิด ขณะที่ระบบ nudge เพิ่ม prompt ให้กับพฤติกรรมที่พึงประสงค์
- **Implementation Intentions (Peter Gollwitzer):** การตั้งเป้าหมายแบบ “if-then” (ถ้าเกิด X ฉันจะทำ Y) เพิ่มโอกาสสำเร็จของเป้าหมายอย่างมีนัยสำคัญ นำมาใช้ในฟีเจอร์ตั้งเป้า focus session
- **Temptation Bundling (Katy Milkman):** การผูกกิจกรรมที่อยากทำเข้ากับกิจกรรมที่ควรทำ ใช้เป็นแนวคิดในฟีเจอร์ reward pairing
- **Self-Determination Theory (Deci & Ryan):** แรงจูงใจภายใน (intrinsic motivation) ยั่งยืนกว่าแรงจูงใจภายนอก ต้องอาศัย 3 องค์ประกอบ: Autonomy, Competence, Relatedness — เป็นหลักการที่กำกับการออกแบบ gamification ไม่ให้กลายเป็นการควบคุมจากภายนอกมากเกินไป
- **Identity-Based Habits (James Clear, *Atomic Habits*):** นิสัยที่ยั่งยืนเกิดจากการเปลี่ยนความเชื่อเกี่ยวกับตัวตน (“ฉันเป็นคนที่โฟกัสได้”) มากกว่าผลลัพธ์ระยะสั้น ใช้ในการออกแบบข้อความ reflection และ progress narrative

## 3.3 Friction และ Commitment Devices

งานวิจัยด้าน behavioral economics (Thaler & Sunstein, *Nudge*) แสดงให้เห็นว่าการเพิ่ม “แรงเสียดทานเล็กน้อยแต่มีความหมาย” (small meaningful friction) สามารถลดพฤติกรรมอัตโนมัติ (automatic behavior) ได้อย่างมีประสิทธิภาพโดยไม่ลดทอน autonomy ของผู้ใช้ ตรงข้ามกับหนังสือ *Hooked* ของ Nir Eyal ที่อธิบายว่าผลิตภัณฑ์เสพติดใช้ variable reward และลด friction ให้เหลือน้อยที่สุด — แอปนี้ทำสิ่งตรงข้ามโดยเจตนา (Anti-Hooked design)

**Commitment devices** เช่นระบบ Vault Partner อ้างอิงงานวิจัยของ Dean Karlan และ John Beshears เกี่ยวกับการที่ผู้คนยินยอมผูกมัดตนเองล่วงหน้ากับผลลัพธ์เชิงลบ (self-binding) เพื่อเพิ่มโอกาสบรรลุเป้าหมาย **[v1.1] ใน MVP ใช้ self-commitment (การตั้งเป้าและเลือกระดับเอง) ส่วน Vault Partner เลื่อนไป v1.1**

## 3.4 ข้อจำกัดของแนวทาง Digital Detox แบบเดิม

Cal Newport (*Digital Minimalism*) ชี้ว่าการเลิกใช้แบบเบ็ดเสร็จ (cold turkey) มักล้มเหลวในระยะยาว เพราะไม่ได้แก้ที่รากของปัญหาคือการขาดกิจกรรมทดแทนที่มีความหมาย (high-value replacement activities) แอปนี้จึงออกแบบ reflection และ focus session ให้เชื่อมโยงกับเป้าหมายที่มีความหมายของผู้ใช้ ไม่ใช่แค่ “บล็อกแอป”

## 3.5 หลักการที่นำมาปรับใช้ในผลิตภัณฑ์ (สรุป)

| งานวิจัย/ทฤษฎี | นำไปใช้ในฟีเจอร์ |
| --- | --- |
| Reward Prediction Error | **[v1.1]** การเตือนเมื่อเปิดแอปเสี่ยง (Friction gate → Warning + reflective pause) |
| Fogg Behavior Model | Prompt/nudge ที่จับจังหวะ high-motivation moment |
| Implementation Intentions | Focus session planning (“if-then” goal setting) |
| Identity-Based Habits | Reflection journal, progress narrative |
| Commitment Devices | **[v1.1]** Self-commitment (MVP) / Vault Partner, Partner-gated (v1.1) |
| Self-Determination Theory | Gamification ที่เน้น mastery ไม่ใช่ external reward เพียงอย่างเดียว |
| Pleasure-Pain Balance | Analytics แสดง “dopamine load” (proxy ใน MVP) และช่วงพักฟื้น |

---

# 4. Market Research & Competitive Analysis

## 4.1 ภาพรวมตลาด

ตลาดแอปด้าน digital wellbeing / focus / screen-time management เติบโตต่อเนื่องจากความตระหนักรู้เรื่องผลกระทบของ social media ต่อสุขภาพจิต โดยเฉพาะกลุ่ม Gen Z และคนทำงานที่ต้องทำงานเชิงลึก (deep work) กลุ่มผลิตภัณฑ์ในตลาดแบ่งได้เป็น 4 กลุ่มหลัก:

- **App/Screen Blockers** — บล็อกแอปตามเวลา (เช่น Freedom, Cold Turkey, One Sec)
- **Focus Timer / Gamified Productivity** — จับเวลาโฟกัสแบบเกม (เช่น Forest, Flora)
- **Screen Time Analytics ของระบบปฏิบัติการ** — iOS Screen Time, Android Digital Wellbeing
- **Accountability-based Apps** — ผูกกับเพื่อน/โค้ชเพื่อสร้างความรับผิดชอบ (เช่น Opal, BeReal-style social accountability)

## 4.2 การวิเคราะห์คู่แข่งหลัก

| ผลิตภัณฑ์ | จุดแข็ง | จุดอ่อน | โอกาสของเรา |
| --- | --- | --- | --- |
| **Opal** | UI สวย, บล็อกแอปมีประสิทธิภาพ, มี “Deep Focus” mode | ไม่มีระบบ accountability partner ที่แท้จริง, friction ตายตัวไม่ปรับตาม context | เพิ่ม friction แบบ adaptive + Vault Partner ที่มีมนุษย์จริงร่วมตัดสินใจ (v1.1) |
| **Forest** | Gamification สนุก, กลไกปลูกต้นไม้จูงใจดี | ไม่มี behavioral science เชิงลึก, ไม่มี reflection/analytics เชิงพฤติกรรม | ผสาน gamification เข้ากับ data-driven insight และ CBT-style reflection |
| **Freedom** | บล็อกข้าม device ได้ (cross-device sync) | UX ล้าสมัย, ไม่มี social accountability, ตั้งค่าซับซ้อน | Vault Partner + friction ที่ตอบสนอง real-time พร้อม UX ทันสมัย |
| **One Sec** | Friction ก่อนเปิดแอป (breathing pause) มีประสิทธิภาพสูง | ฟีเจอร์จำกัดเฉพาะ friction เดียว ไม่มี ecosystem ของ habit-building | ขยาย friction เป็น framework หลายระดับ + ผูกกับเป้าหมายระยะยาว |
| **iOS/Android native Screen Time** | ติดตั้งมาแล้ว ฟรี | Friction ต่ำมาก (ปิดง่าย), ไม่มี social accountability, analytics ตื้น | ความลึกของ behavioral design และ accountability ที่ native ทำไม่ได้ |

## 4.3 Positioning

“แอปเดียวที่รวม Friction Science + Human Accountability + Behavioral Analytics เข้าด้วยกัน แทนที่จะเป็นแค่ตัวบล็อกแอปหรือเกมจับเวลา”

**Differentiators หลัก:**
1. Vault Partner — ระบบ accountability ที่มีมนุษย์จริงเป็นผู้ตรวจสอบ ไม่ใช่แค่ AI/algorithm (v1.1)
2. Friction-based Intervention Framework ที่ปรับระดับตาม context (adaptive friction)
3. รากฐานทางวิทยาศาสตร์พฤติกรรมที่อธิบายได้และตรวจสอบได้ ไม่ใช่ gimmick
4. Layered control philosophy — ไม่ล็อกผู้ใช้แบบเบ็ดเสร็จ เคารพ autonomy

## 4.4 Risks ทางการตลาด

- ตลาดมีผู้เล่นที่ established แล้ว (switching cost ของผู้ใช้)
- Digital wellbeing เป็น “vitamin” ไม่ใช่ “painkiller” โดยธรรมชาติ — ต้องอาศัย onboarding ที่ดีเพื่อสร้าง perceived value ตั้งแต่แรก
- ฟีเจอร์ friction คล้ายกับคู่แข่งได้ง่าย (low technical moat) — moat ที่แท้จริงคือคุณภาพของ behavioral design และ community/accountability network effect
- **[v1.1]** ผู้ใช้ที่ต้องการการบล็อกจริงอาจไม่พอใจกับการเตือน ต้องสื่อสาร positioning นี้ตั้งแต่ onboarding

---

# 5. User Personas

## 5.1 Persona A — “น้องปูน” นักศึกษาปี 3 (Student, อายุ 20)

- **บริบท:** เรียนวิศวกรรม ต้องอ่านหนังสือสอบแต่เปิด TikTok/Instagram ทุก 5-10 นาทีระหว่างอ่าน
- **Pain Points:** เสียเวลาไปกับ short-form video หลายชั่วโมงต่อวัน, รู้สึกผิดหลังเล่นนาน, สอบตกเพราะเวลาไม่พอ
- **เป้าหมาย:** อยากอ่านหนังสือได้ต่อเนื่อง 45-90 นาทีโดยไม่หยิบมือถือ
- **แรงจูงใจ:** กลัวสอบตก, อยากพิสูจน์ตัวเองกับครอบครัว
- **ความสัมพันธ์กับ Vault Partner:** ให้เพื่อนสนิทหรือรุ่นพี่เป็น Vault Partner (v1.1)

## 5.2 Persona B — “พี่เอก” Senior Developer (อายุ 29)

- **บริบท:** ทำงาน remote ต้องเขียนโค้ดแบบ deep work แต่ context-switch ไป Twitter/X, HackerNews, Slack บ่อย
- **Pain Points:** เสีย flow state บ่อย, productivity ต่ำกว่าที่ควร, รู้สึกเหนื่อยล้าทางสมองแม้ทำงานไม่มาก (dopamine fatigue)
- **เป้าหมาย:** สร้าง deep work block 2-3 ชั่วโมงต่อวันแบบไม่ขาดตอน
- **แรงจูงใจ:** ต้องการ career growth, ไม่อยากให้ทีมรอ
- **ความสัมพันธ์กับ Vault Partner:** ให้คู่ชีวิตหรือเพื่อนร่วมทีมเป็น partner แบบ mutual accountability (v1.1)

## 5.3 Persona C — “คุณมิ้นท์” Content Creator (อายุ 25)

- **บริบท:** งานต้องใช้ social media ตลอดเวลา (ทั้งเสพและสร้าง) ทำให้เส้นแบ่งระหว่าง “งาน” กับ “เสพติด” เลือนราง
- **Pain Points:** ต้องอยู่ในแอปที่ตัวเองพยายามเลี่ยง, ตั้งเวลาบล็อกไม่ได้เพราะติดใช้งานจริง
- **เป้าหมาย:** แยกโหมด “สร้างคอนเทนต์” กับ “เสพเพื่อความบันเทิง” ออกจากกันชัดเจน
- **แรงจูงใจ:** สุขภาพจิต, สร้างสมดุลชีวิต

## 5.4 Persona D — “คุณสมชาย” Entrepreneur (อายุ 35)

- **บริบท:** บริหารสตาร์ทอัพ ต้องตัดสินใจสำคัญหลายเรื่องต่อวัน มือถือเต็มไปด้วย notification
- **Pain Points:** Decision fatigue, notification overload, ไม่มีเวลาคิดเชิงกลยุทธ์อย่างลึก
- **เป้าหมาย:** สร้างช่วงเวลา “strategic thinking” ที่ปลอด distraction ทุกเช้า
- **แรงจูงใจ:** ธุรกิจอยู่รอด, ครอบครัว

---

# 6. Jobs To Be Done (JTBD)

| # | Job Statement | Trigger | Desired Outcome |
| --- | --- | --- | --- |
| JTBD-1 | เมื่อฉันต้องโฟกัสงาน/เรียน ฉันต้องการลดสิ่งรบกวนจากมือถือ เพื่อให้ทำงานเสร็จตามเวลา | เริ่มงานสำคัญ, ใกล้ deadline | Focus session ที่สมบูรณ์โดยไม่ถูกขัดจังหวะ |
| JTBD-2 | เมื่อฉันรู้สึกอยากเปิดแอปโดยไม่มีเหตุผล ฉันต้องการให้มีอะไรมาช่วยหยุดฉันไว้ก่อน เพื่อให้ฉันได้คิดก่อนทำ | **[v1.1]** ได้รับการเตือนเมื่อเปิดแอปที่เลือก, ความเบื่อ | ผ่าน reflective pause แล้วตัดสินใจอย่างมีสติ |
| JTBD-3 | เมื่อฉันพยายามเปลี่ยนพฤติกรรมคนเดียวไม่สำเร็จ ฉันต้องการให้มีคนช่วยตรวจสอบ เพื่อเพิ่มความรับผิดชอบ | ล้มเหลวซ้ำหลายครั้ง | **[v1.1]** มี Vault Partner ที่ช่วย approve/deny การขอ override (v1.1) |
| JTBD-4 | เมื่อฉันอยากรู้ว่าพฤติกรรมตัวเองดีขึ้นไหม ฉันต้องการเห็นข้อมูลที่ชัดเจน เพื่อประเมินความก้าวหน้า | สิ้นสัปดาห์/สิ้นเดือน | Dashboard วิเคราะห์แนวโน้มพฤติกรรม |
| JTBD-5 | เมื่อฉันหลุด (relapse) ฉันต้องการพื้นที่ปลอดภัยในการกลับมาโดยไม่รู้สึกผิดจนเลิกใช้แอป | หลัง streak ขาด | Recovery flow ที่ไม่ shaming ตั้งต้นใหม่ได้ง่าย |
| JTBD-6 | เมื่อฉันอยู่ในสถานการณ์ฉุกเฉินจริง ฉันต้องการหยุดการเตือนชั่วคราวได้ เพื่อไม่ให้ระบบรบกวนชีวิตจริง | เหตุฉุกเฉิน, สายด่วนงาน | **[v1.1]** Emergency pause ที่บันทึกและจำกัดจำนวนครั้ง |

---

# 7. User Journey Maps

## 7.1 Journey: First-Time User (Onboarding → First Focus Session)

| ขั้นตอน | การกระทำ | ความรู้สึก | Touchpoint | Opportunity |
| --- | --- | --- | --- | --- |
| Discover | เห็นแอปจาก App Store/เพื่อนแนะนำ | สงสัย อยากลองแก้ปัญหา | App Store listing | คำอธิบายที่เน้นวิทยาศาสตร์ ไม่ gimmick |
| Onboarding | **[v1.1]** ตอบ Triggers, Goal (6 ขั้นตอนตาม Prototype) | อยากรู้ว่าแอปเข้าใจปัญหาตัวเองไหม | Onboarding flow | Personalize คำแนะนำทันที |
| Setup | **[v1.1]** เลือกแอปที่จะเตือน, ตั้งระดับ friction, ให้สิทธิ์ Accessibility และ Notifications | กังวลเรื่องตั้งค่าซับซ้อน | Setup wizard | Default ที่ฉลาด ปรับทีหลังได้ |
| First Session | เริ่ม focus session แรก | ตื่นเต้น/กังวลว่าจะทำไม่ได้ | Focus timer screen | Micro-encouragement ระหว่าง session |
| Completion | จบ session แรกสำเร็จ | ภูมิใจ | Completion + reflection | Positive reinforcement ชวนตั้ง session ถัดไป |

## 7.2 Journey: Vault Partner Invitation (v1.1)

| ขั้นตอน | การกระทำ | ความรู้สึก | Touchpoint | Opportunity |
| --- | --- | --- | --- | --- |
| Decide | ตัดสินใจอยากมี accountability partner | ลังเล กลัวเสียหน้า | In-app prompt | อธิบาย privacy model ให้ชัดก่อนเชิญ |
| Invite | ส่งคำเชิญเพื่อน/คู่ชีวิต | หวังว่าอีกฝ่ายจะตอบรับ | Invite flow (deep link) | ข้อความเชิญอธิบายบทบาทชัดเจน |
| Accept | Partner ยอมรับและตั้งค่าสิทธิ์ | อยากช่วยแต่ไม่อยากรับผิดชอบมากไป | Partner onboarding | ให้ partner เลือกระดับความรับผิดชอบเอง |
| Daily Use | Partner รับ notification เมื่อมี override request | เป็นกลาง/ห่วงใย | Push notification | Approve/deny ใช้เวลา <10 วินาที |
| Review | ทั้งคู่ดู progress ร่วมกันรายสัปดาห์ | รู้สึกเป็นทีมเดียวกัน | Shared summary screen | Framing เชิงบวก ไม่ใช่รายงานความผิด |

## 7.3 Journey: Relapse & Recovery

| ขั้นตอน | การกระทำ | ความรู้สึก | Touchpoint | Opportunity |
| --- | --- | --- | --- | --- |
| Relapse | streak ขาด ใช้แอปต้องห้ามเกินกำหนด | รู้สึกผิด อับอาย | Streak break screen | ข้อความไม่ตัดสิน เน้น progress ไม่ perfection |
| Reflect | ระบบถามสาเหตุ | อยากเข้าใจตัวเอง | Reflection prompt | คำถามแบบ CBT-informed ไม่ guilt-trip |
| Reset | ตั้ง session ใหม่ | มีความหวัง | Reset flow | แสดง streak history แบบไม่ลบ เก็บ momentum เดิม |

---

# 8. Information Architecture

```
Homeo
├── Onboarding
│   ├── Welcome / Value Prop
│   ├── Behavioral Assessment (Triggers, Goal)
│   ├── App Selection (แอปกลุ่มเสี่ยง)
│   ├── Friction Level (ค่าเริ่มต้น)
│   └── Permissions (Accessibility, Notifications)   [v1.1]
├── Home (Dashboard)
│   ├── Today's Focus Summary
│   ├── Quick Start Focus Session
│   ├── Streak Status
│   └── Insight of the Day
├── Focus
│   ├── Session Setup (duration, intention)
│   ├── Active Session Timer
│   ├── Session Complete / Reflection
│   └── Session History
├── Vault Partner   [v1.1]
│   ├── Partner List
│   ├── Invite Partner
│   ├── Override Request Flow
│   ├── Approval Inbox (สำหรับ Partner)
│   └── Shared Progress View
├── Analytics
│   ├── Weekly/Monthly Trends
│   ├── Distraction Event Log
│   ├── Dopamine Load Index
│   └── Export Data (CSV/JSON ใน MVP)   [v1.1]
├── Interventions (Friction)
│   ├── Watched App List (แอปที่เตือน)   [v1.1]
│   ├── Friction Level Settings
│   ├── Emergency Pause (หยุดการเตือนชั่วคราว)   [v1.1]
│   └── Recovery Mode
├── AI Coach
│   ├── Chat Interface (rule-based ใน MVP)   [v1.1]
│   ├── Personalized Insights
│   └── Suggested Actions
├── Profile & Settings
│   ├── Account
│   ├── Notification Preferences
│   ├── Privacy & Data
│   ├── Vault Partner Management   [v1.1]
│   ├── Appearance (สว่าง/มืด/ตามระบบ)   [v1.1]
│   └── App Permissions (Accessibility, Notifications, Battery)   [v1.1]
└── Support
    ├── FAQ
    ├── Crisis/Wellbeing Resources
    └── Feedback
```

---

# 9. Complete Feature Specification

## 9.1 Focus Session

| Spec | รายละเอียด |
| --- | --- |
| Session Types | Timed (25/45/60/90 นาที, custom), Open-ended |
| Intention Setting | ผู้ใช้พิมพ์เป้าหมายของ session ก่อนเริ่ม (implementation intention) |
| **[v1.1] การเตือนระหว่าง session** | **แทนการบล็อกอัตโนมัติ:** แอปกลุ่มเสี่ยงที่เลือกไว้จะถูกเตือนในระดับ L3 (Focus reminder) ทุกครั้งที่เปิดระหว่าง session ที่กำลังทำงาน ไม่มีการบล็อก |
| Interruption Handling | หากออกจาก session ก่อนกำหนด ต้องผ่าน exit gate (เหตุผล + countdown 5 วินาที) |
| Pause | อนุญาต pause ได้ **สูงสุด 3 ครั้ง/วัน** (นับรวมทุก session) เพื่อป้องกันการใช้เป็นช่องโหว่ |
| Completion Reward | animation (ไม่มี confetti), streak +1, บันทึกลง analytics, แจ้งเตือนว่า session จบแม้แอปอยู่เบื้องหลัง |
| Reflection | คำถามสั้นหลังจบ session (“รู้สึกอย่างไร”: ยาก/ปกติ/ดี/ยอดเยี่ยม) |
| **[v1.1] Timer** | คำนวณจาก timestamp ไม่นับ tick ทนต่อการ suspend และการฆ่าแอป ระบบกู้คืน session เมื่อเปิดใหม่ |

## 9.2 Habit Tracking

- ติดตามพฤติกรรมเป้าหมาย (เช่น “ไม่เปิด TikTok ก่อนเที่ยง”)
- Streak counter แบบ non-punishing (แสดง “best streak” คู่กับ “current streak” ไม่ลบประวัติเมื่อขาด)
- **[v1.1]** Streak นับวันที่มี session ที่ completed อย่างน้อย 1 ครั้ง current streak คงอยู่จนจบวันถัดไปที่ไม่มี session
- Weekly habit review อัตโนมัติทุกวันอาทิตย์

## 9.3 Distraction Logging

- บันทึกทุกครั้งที่ผู้ใช้เปิดแอปกลุ่มเสี่ยง (ไม่ว่าจะกลับไปโฟกัสหรือเปิดต่อ)
- แท็ก context (เวลา, ระหว่าง session หรือไม่, ก่อนหน้าทำอะไรอยู่ ถ้าอนุญาต)
- **[v1.1] วิธีตรวจจับ:**
  - **Android:** AccessibilityService (`typeWindowStateChanged`) เปรียบเทียบ package name กับรายการที่เลือก ไม่อ่านเนื้อหาบนหน้าจอ (`canRetrieveWindowContent = false`) เหตุการณ์เก็บในคิวฝั่ง native และ Flutter นำเข้าเมื่อกลับมาทำงาน (ดูหมวด 21.4)
  - **iOS:** Shortcuts Automation “App is Opened” → เปิด deep link `homeo://distraction-event?app=<id>` (ผู้ใช้ตั้งทีละแอป)
- **[v1.1] Dedup (proposed):** เปิดแอปเดิมซ้ำภายใน 30 วินาทีนับเป็นเหตุการณ์เดียว

## 9.4 Analytics Dashboard

- Dopamine Load Index (ดัชนีคำนวณจากความถี่ + ระยะเวลาของการเสพสิ่งเร้าสูง)
  - **[v1.1]** ใน MVP ใช้จำนวนครั้งที่เปิดแอปที่เลือกเป็นตัวแทน (proxy) จนกว่าจะมีข้อมูลเวลาใช้งาน
- แนวโน้มรายวัน/สัปดาห์/เดือน
- เปรียบเทียบช่วงก่อน-หลังใช้แอป
- **[v1.1] Export เป็น CSV/JSON ใน MVP** (PDF/PNG เลื่อนไป v1.1)
- **[v1.1] การใช้งานรายแอปแบบเวลา (usage time):** ต้องใช้สิทธิ์ Usage Access (Android) ซึ่งไม่อยู่ใน MVP — MVP แสดงจำนวนครั้งที่พยายามเปิดและจำนวนครั้งที่ได้รับการเตือนแทน เวลาใช้งานรวมจะเพิ่มใน v1.1 หลังผู้ใช้เปิดสิทธิ์เอง

## 9.5 AI Coach

- Chat interface ที่ให้คำแนะนำเชิงพฤติกรรมโดยอ้างอิงข้อมูลการใช้งานจริงของผู้ใช้
- **[v1.1]** MVP ใช้กฎ (rule-based) ประมวลผลในเครื่อง ไม่ส่งข้อมูลออกนอกเครื่อง LLM เลื่อนไป v2
- Insight เชิงรุก (proactive insight) เช่น “คุณมักหลุดโฟกัสช่วง 14:00-15:00 ลองย้าย deep work มาช่วงเช้าไหม”
- ไม่ให้คำแนะนำทางการแพทย์/จิตเวช — มีการ disclaim ชัดเจนและแนะนำผู้เชี่ยวชาญเมื่อพบสัญญาณเสี่ยง **[v1.1]** มีสายด่วนสุขภาพจิต 1323 เมื่อพบสัญญาณทำร้ายตนเอง

## 9.6 Accountability (Vault Partner) — ดูรายละเอียดในหมวดที่ 10 **[v1.1] เลื่อนไป v1.1**

## 9.7 Emergency Recovery

- **[v1.1]** ปุ่ม “ฉุกเฉิน” **หยุดการเตือนชั่วคราว 15 นาที** (ไม่มีการปลดบล็อก เพราะระบบไม่บล็อก) สำหรับสถานการณ์จำเป็นจริง (เช่น ต้องโทร/ใช้แผนที่)
- จำกัดจำนวนครั้ง (ค่าเริ่มต้น 3 ครั้ง/เดือน ปรับได้ 1–10) และบันทึกทุกครั้ง
- v1.1: แจ้ง Vault Partner หลังใช้งาน (transparency)
- แยกจาก “override request” ปกติที่ต้องรอ approval (v1.1)
- เมื่อใช้ครบโควต้า แสดงหมายเลขฉุกเฉิน **1669** (การแพทย์ฉุกเฉิน) และ **191** (ตำรวจ) เสมอ

## 9.8 Notifications

- Nudge เชิงบวก (ไม่ shame), reminder เริ่ม session, weekly summary
- ผู้ใช้ปรับความถี่ได้ทั้งหมด (respect autonomy)
- **[v1.1] ช่องทางแจ้งเตือนในเครื่อง (local notifications เท่านั้นใน MVP ไม่มี push จาก server)** รายละเอียดหมวด 20.4

## 9.9 Personalization

- Onboarding assessment กำหนด default friction level และ app list
- ระบบเรียนรู้ pattern การใช้งานเพื่อปรับ nudge timing (Phase 2)

## 9.10 Offline Support

- Focus session, การตรวจจับ, การเตือน, logging ทำงานได้แบบ offline เต็มรูปแบบ แล้ว sync เมื่อออนไลน์ (ดูหมวด 21-22; sync เลื่อนไป Phase 2)

---

# 10. Vault Partner System (Flow, Edge Cases, Security) — **[v1.1] เลื่อนไป v1.1 ทั้งหมด**

> **[v1.1] หมายเหตุ:** ทั้งหมวดนี้เป็น specification สำหรับ v1.1 ใน MVP ไม่มีการทำงานของ Vault Partner และ L4 ยังคง UI ตาม prototype (ดูหมวด 12.2.1 และภาคผนวก A) เพื่อเป็นต้นแบบ

## 10.1 แนวคิด

Vault Partner คือบุคคลที่ผู้ใช้ไว้วางใจ (เพื่อน, ครอบครัว, คู่ชีวิต) ซึ่งได้รับสิทธิ์จำกัดในการ **อนุมัติ/ปฏิเสธคำขอ override** ข้อจำกัดที่ผู้ใช้ตั้งไว้เอง เป็นกลไก commitment device ที่ทำให้การ “โกงตัวเอง” ยากขึ้น เพราะต้องผ่านบุคคลที่สาม

**[v1.1] ข้อจำกัด:** เมื่อระบบไม่บล็อก การอนุมัติจาก Partner จะมีผลเป็นการยืนยันทางสังคมเท่านั้น ระบบบังคับใช้ไม่ได้ จึงต้องออกแบบให้ Partner เป็นการแจ้งเตือนและบันทึก (audit) ไม่ใช่กลไกล็อก

## 10.2 Core Flow

- **Invite:** ผู้ใช้ (Owner) ส่งคำเชิญผ่าน deep link/รหัสเชิญให้ Partner
- **Accept & Configure:** Partner ยอมรับ และร่วมตั้งค่าระดับสิทธิ์ (เช่น อนุมัติ override ได้ทุกกรณี / เฉพาะบางแอป / ต้องระบุเหตุผลก่อนเสมอ)
- **Active Monitoring (Consent-based):** Partner เห็นเฉพาะข้อมูลสรุป (session completion, streak) ไม่เห็นเนื้อหาที่ใช้ เว้นแต่ Owner เปิดสิทธิ์เพิ่ม
- **Override Request:** เมื่อ Owner ต้องการเปิดแอปที่ L4 ระบบส่งคำขอไปยัง Partner พร้อมเหตุผลที่ Owner กรอก
- **Approval Decision:** Partner กด Approve / Deny ภายในเวลาที่กำหนด (มี timeout)
- **Recovery Delay:** หาก Partner ไม่ตอบสนอง ระบบเข้าสู่ “cooling-off period” (ค่าเริ่มต้น 10-30 นาที) แล้วปลดอัตโนมัติแบบมีเงื่อนไข (ป้องกัน Owner ติดค้างเพราะ Partner ไม่ว่าง)
- **Audit Log:** ทุก request/response ถูกบันทึกและทั้งสองฝ่ายดูย้อนหลังได้

## 10.3 Edge Cases

| กรณี | การจัดการ |
| --- | --- |
| Partner ไม่ตอบสนองเลย | Cooling-off period แล้วปลดอัตโนมัติ พร้อมแจ้ง Partner ภายหลัง |
| Owner สแปม override request | Rate limit คำขอ (เช่น สูงสุด 3 ครั้ง/วัน) เกินกว่านั้นต้องรอ cooling-off ยาวขึ้น |
| Partner ใช้สิทธิ์ในทางที่ผิด (เช่น deny ตลอดเวลาโดยไม่มีเหตุผล/harassment) | Owner สามารถยกเลิกสิทธิ์ Partner ได้ทันทีทุกเมื่อ (Owner มีอำนาจสูงสุดเสมอ) |
| Owner ต้องการยกเลิกความสัมพันธ์ | ทำได้ฝ่ายเดียว ไม่ต้องขอความยินยอมจาก Partner |
| หลาย Partner พร้อมกัน | รองรับ multi-partner, ตั้งกฎ “ต้องได้รับอนุมัติจากอย่างน้อย 1 ใน N คน” |
| Emergency จริง (ปลอดภัยชีวิต) | ใช้ Emergency Pause แยกต่างหาก ไม่ผ่าน Partner approval |
| Partner บล็อก/ลบบัญชี | ระบบแจ้งเตือน Owner และเสนอเชิญ Partner คนใหม่ |

## 10.4 Security & Privacy

- **Consent-based visibility:** Partner เห็นเฉพาะข้อมูลที่ Owner อนุญาตอย่างชัดเจน (granular permission, ไม่ใช่ all-or-nothing)
- **Owner-controlled revocation:** Owner ยกเลิกสิทธิ์ Partner ได้เสมอ โดยไม่ต้องมี approval จาก Partner
- **End-to-end scoped data:** Override request payload ส่งเฉพาะข้อมูลจำเป็น (แอปที่ขอ, เหตุผล, เวลา) ไม่ส่งเนื้อหาการใช้งานละเอียด
- **Anti-abuse safeguards:** ตรวจจับ pattern การใช้ Vault Partner เป็นเครื่องมือ coercive control — มี in-app resource แนะนำหากตรวจพบ pattern เข้าข่ายความสัมพันธ์ที่ไม่ดีต่อสุขภาพ
- **Audit immutability:** log การอนุมัติ/ปฏิเสธ เก็บแบบ append-only ป้องกันการแก้ไขย้อนหลัง

---

# 11. Friction-based Intervention Framework

## 11.1 หลักการออกแบบ

Friction ต้อง “สัดส่วนกับความเสี่ยง” (proportional friction) — ไม่ใช่ยิ่งมากยิ่งดี เพราะ friction ที่มากเกินไปจะสร้างความหงุดหงิดจนผู้ใช้เลิกใช้แอปทั้งระบบ (uninstall risk)

**[v1.1] ขอบเขตของ framework:** ทุกระดับเป็นการ “เตือนและเปิดให้ผู้ใช้เลือกเอง” ระบบไม่บังคับใช้ผลลัพธ์ใด ๆ กับแอปของผู้ใช้

## 11.2 ระดับ Friction (Adaptive Friction Levels)

| ระดับ | กลไก (v1.0) | ใช้เมื่อ | **[v1.1] การทำงานจริงใน MVP** |
| --- | --- | --- | --- |
| **L0 — Awareness** | แสดง banner เตือนก่อนเปิดแอป (“นี่คือครั้งที่ 5 วันนี้”) | พฤติกรรมปกติ ยังไม่เกินเป้า | Notification + แบนเนอร์ในแอปเมื่อ Homeo อยู่หน้าจอ หายเองใน 3.5 วินาที |
| **L1 — Micro-friction** | หน่วงเวลา 5-10 วินาที + ปุ่ม “ยืนยันว่าต้องการจริงๆ” | เกินเป้ารายวันเล็กน้อย | Notification → เปิด Homeo → Modal นับถอยหลัง 8 วินาที (ไม่มีการกันการเปิดแอป) |
| **L2 — Reflective Pause** | ให้พิมพ์เหตุผลก่อนเข้าแอป (breathing exercise ทางเลือก) | ใกล้ focus session หรือช่วงเวลาที่ตั้งเป็น protected time | Notification → เปิด Homeo → เลือกเหตุผล/พิมพ์ (อย่างน้อย 3 ตัวอักษร) → นับถอยหลัง 5 วินาที บันทึกเหตุผล |
| **L3 — Full Block** | บล็อกสมบูรณ์ระหว่าง active session | Focus session กำลังทำงาน | **[v1.1] เปลี่ยนเป็น Focus reminder:** การเตือนความสำคัญสูงระหว่าง session และหน้า “ตอนนี้เป็นช่วง Focus ของคุณ” ไม่มีการบล็อก |
| **L4 — Partner-gated** | ต้องผ่านการอนุมัติจาก Vault Partner จึงเข้าได้ | ผู้ใช้เปิดใช้งานระดับสูงสุดด้วยตนเอง (opt-in) | **[v1.1] เลื่อนไป v1.1** (UI ตาม prototype ใช้เป็น reference) ไม่มี Partner จะถูกลดเป็น L3 |

**[v1.1] หมายเหตุสำคัญ:** เนื่องจากระบบไม่บล็อก ความแรงของ friction ขึ้นกับการตอบสนองของผู้ใช้ต่อการเตือน ซึ่งวัดได้ด้วย warning return rate (หมวด 32)

## 11.3 Context-aware Escalation

ระบบปรับระดับ friction อัตโนมัติตาม:
- เวลาในแผนที่ตั้งไว้ (protected hours) — *Phase 2*
- ความถี่การพยายามเปิดแอปในช่วงเวลาสั้น ๆ (burst detection) — **[v1.1] MVP: 3 ครั้งใน 10 นาที → ยกระดับ 1 ขั้น ไม่เกิน L3**
- แนวโน้มพฤติกรรมสัปดาห์ก่อนหน้า (ถ้าดีขึ้นต่อเนื่อง ลด friction ลงเป็นรางวัล — “de-escalation as reward”) — *Phase 2*
- **[v1.1]** Focus session ที่กำลังทำงาน → L3 เสมอ

## 11.4 หลักการป้องกัน Dark Pattern

- Friction ทุกระดับต้องมี “ทางออกที่ชัดเจนเสมอ” ห้ามออกแบบให้ผู้ใช้หาทางปิดไม่เจอ (ตรงข้ามกับ dark pattern ทั่วไปที่ทำให้ “ยกเลิก” หายาก)
- ไม่ใช้ guilt/shame message — ใช้ neutral, factual language เท่านั้น
- ผู้ใช้ตั้งค่า friction level เองได้เสมอ (ไม่ hard-code โดยไม่ให้ผู้ใช้รู้)
- **[v1.1] ไม่มีการบล็อกหรือปิดแอปของผู้ใช้ในทุกกรณี** และข้อความ “Homeo เตือนเท่านั้น ไม่ได้บล็อกหรือปิดแอปของคุณ” แสดงในหน้าการตั้งค่าการตรวจจับ

---

# 12. UX Principles & Design System

## 12.1 UX Principles

- **Low friction for productive actions** — เริ่ม focus session ต้องทำได้ภายใน 2 tap
- **Intentional friction for impulsive actions** — เปิดแอปกลุ่มเสี่ยงต้องผ่านขั้นตอนที่ออกแบบมาให้ “ช้าลงอย่างมีเหตุผล”
- **Transparency** — ผู้ใช้ต้องเข้าใจเสมอว่าทำไมระบบถึงทำงานแบบนั้น (ไม่มี black-box restriction)
- **Accessibility** — รองรับ WCAG 2.1 AA, screen reader, dynamic type, color contrast ≥4.5:1 **[v1.1] ดูข้อยกเว้นของ prototype ในหมวด 12.2.2**
- **Autonomy** — ทุกข้อจำกัดต้องมีทางปรับ/ยกเลิกโดยผู้ใช้เอง

## 12.2 Design System — Foundations

| Token | ค่า (v1.0) | **[v1.1] ค่าที่ใช้จริง (Prototype = master)** |
| --- | --- | --- |
| Primary Color | Deep Indigo #3730A3 | **#6C63E0** (Primary) / #5550C8 (Primary dark) / #EAE8FB (Primary soft) — ดูหมวด 12.2.1 |
| Accent Color | Warm Amber #F59E0B (reward/streak เท่านั้น) | **#FF9F7A** (Coral accent) — ใช้กับ reward/streak เท่านั้น |
| Danger/Friction Color | Muted Red #DC2626 | **#C1443B** (Danger) ใช้เฉพาะ friction gate และปุ่มยืนยันอันตราย |
| Neutral Scale | Gray 50–900 | **Canvas #FDFBF6 / Ink #1C1635 / Ink muted #716D96 / Rule #E8E4F5** — ดูหมวด 12.2.1 |
| Typography | Heading: Inter SemiBold / Body: Inter Regular | **[v1.1] Nunito** (400–900) ตาม prototype, fallback ภาษาไทย **Noto Sans Thai** (Nunito ไม่มีอักษรไทย) |
| Spacing Scale | 4 / 8 / 12 / 16 / 24 / 32 / 48 (px, 8pt grid) | ไม่เปลี่ยน + **[v1.1]** page margin 24px ตาม prototype |
| Corner Radius | 12px (card), 8px (button), 999px (pill/badge) | **[v1.1]** pill 999 (ปุ่มหลัก สูง 56, chip), 24 (การ์ดหลัก, gate sheet), 18–20 (การ์ดทั่วไป), 14–16 (กล่องย่อย, input), 8–12 (chip เล็ก) |
| Elevation | 3 ระดับเงา (card, modal, floating action) | ไม่เปลี่ยน + **[v1.1]** ปุ่มหลัก `0 8px 24px rgba(108,99,224,0.35)`, การ์ด `0 2px 8px rgba(28,22,53,0.04)` |
| Motion | ease-out 200-300ms สำหรับ transition, ไม่ใช้ motion ที่กระตุ้น dopamine เกินจำเป็น (ห้ามใช้ confetti/celebration แบบ over-the-top ที่เข้าข่าย variable reward) | ไม่เปลี่ยน + **[v1.1]** press scale 0.95, เคารพ “ลดการเคลื่อนไหว” ของระบบ |

### 12.2.1 [v1.1] โทเค็นสีจาก Prototype (Master Reference)

ค่าจากไฟล์ `src/index.css` และ `src/contexts/ThemeContext.tsx` ของ prototype

| Token | Light | Dark | การใช้งาน |
| --- | --- | --- | --- |
| canvas | `#FDFBF6` | `#0D0C18` | พื้นหลังหน้า |
| surface | `#FFFFFF` | `#17162A` | การ์ด, input (dark) |
| surfaceAlt / panel | `#F5F4FE` (panel `#F0EEFF`, panel-soft `#FAF9FF`) | `#1F1E35` | ช่องย่อย, sheet ย่อย, inputBg |
| surfaceRaised | `#FFFFFF` | `#252342` | Modal |
| ink | `#1C1635` | `#EDEAF8` | ตัวอักษรหลัก |
| inkMuted | `#716D96` (CSS: `#7B7899`) | `#9D9ABE` | ตัวอักษรรอง |
| inkFaint | `#C5C1D8` | `#4E4B6A` | Placeholder/label จาง (ดูคำเตือนด้านล่าง) |
| border | `#E8E4F5` | `#2A2740` | เส้นขอบการ์ด |
| rule | `#F2F0FA` | `#1E1C30` | เส้นคั่นบาง |
| primary | `#6C63E0` | `#8078F2` | ปุ่มหลัก, แท็บที่เลือก, สถานะปกติ |
| primaryDark | `#5550C8` | — | press / hover |
| primarySoft | `#EAE8FB` (ghost `#F5F4FE`) | `#252248` | chip ที่เลือก, badge, พื้นหลังการเลือก |
| primaryText | `#6C63E0` | `#9D97F5` | ลิงก์และข้อความเน้น |
| accent (coral) | `#FF9F7A` (dark `#F07A50`) | `#FF9F7A` | Streak, pause budget, reward เท่านั้น |
| accentSoft | `#FFE8DF` | `#3D2520` | พื้นหลัง accent |
| ok | `#5CB88A` | `#5CB88A` | Session เสร็จ, สถานะสำเร็จ |
| okSoft | `#DFF3EB` | `#1A3328` | |
| warn | `#F0A500` | `#F0A500` | ข้อมูลน่ารู้, ความพยายามเปิดแอป |
| warnSoft | `#FFF3CC` | `#2D2210` | |
| danger | `#C1443B` | `#E06060` | ปุ่มยืนยันอันตราย (ใช้ฉุกเฉิน, ลบ) |
| dangerSoft | `#FDECEA` | `#3D1C1C` | |
| rose / roseSoft | `#F2A6A0` / `#FEF0EF` | — | สถานะ “ยกเลิกแล้ว” (Vault) |
| navBg / headerBg | `#FFFFFF` | `#100F1E` / `#17162A` | แถบล่าง / หัว |
| focusCanvas | `#1C1635` (indigo ink) | `#1C1635` | พื้นหลัง Active session และ L3 (เข้มเสมอ) |
| focusSurface | `rgba(255,255,255,0.08)` | — | track ของ timer ring, กล่องบนพื้นเข้ม |
| Bottom nav inactive | `#B8B4CC` | — | ดูคำเตือนด้านล่าง |
| Scrim | `rgba(28,22,53,0.72)` | — | พื้นหลัง bottom sheet / gate |

**Gradient (ตาม prototype):** ปุ่มและการ์ดหลัก `linear-gradient(135deg, #6C63E0 0%, #8B7FF0 100%)` · พื้นหลังเครื่อง preview ไม่ใช่ UI ของแอป

### 12.2.2 [v1.1] การตรวจสอบ Contrast ของ Prototype (WCAG 2.1 AA)

ค่าประมาณจากอัตราส่วนความสว่าง เกณฑ์ข้อความปกติ 4.5:1

| คู่สี | อัตราส่วน | ผล | ข้อเสนอ |
| --- | --- | --- | --- |
| ink บน white | > 15:1 | ผ่าน | — |
| inkMuted `#716D96` บน white | ~4.8:1 | ผ่าน | — |
| primary `#6C63E0` บน white | ~4.7:1 | ผ่าน | — |
| ขาวบน primary (ปุ่ม) | ~4.7:1 | ผ่าน | — |
| danger `#C1443B` บน white | ~5.0:1 | ผ่าน | — |
| **inkFaint `#C5C1D8` บน white** | ~1.8:1 | **ไม่ผ่าน** | ใช้เฉพาะ decoration/placeholder ที่มี label กำกับ ข้อความอ่านได้ใช้ inkMuted |
| **Bottom nav inactive `#B8B4CC`** | ~1.9:1 | **ไม่ผ่าน** | label ใช้ inkMuted, icon คงสีเดิมได้ |
| **ok `#5CB88A` เป็นตัวอักษร** | ~2.4:1 | **ไม่ผ่าน** | พื้นหรือ icon ใช้ได้ ตัวอักษรใช้ `#2F7A54` (proposed) |
| **warn `#F0A500` เป็นตัวอักษร** | ~2.1:1 | **ไม่ผ่าน** | ตัวอักษรใช้ `#8A5B00` (proposed) |
| **accent `#FF9F7A` เป็นตัวอักษร** | ~2.1:1 | **ไม่ผ่าน** | ใช้เป็น fill หรือ icon เท่านั้น |

**การตัดสินใจที่ต้องยืนยัน:** คงสีจาก prototype สำหรับ fill, icon และ decoration ส่วนตัวอักษรที่ไม่ผ่านให้ใช้ค่า proposed (ดูหมวด 39.5)

## 12.3 Component Library (หลัก)

- Buttons (Primary, Secondary, Ghost, Danger)
- Timer Ring (circular progress สำหรับ focus session)
- Streak Badge
- Friction Modal (มาตรฐานเดียวกันทุกระดับ friction) **[v1.1] ไม่มีการบล็อกใน modal**
- Partner Approval Card (v1.1)
- Insight Card (AI Coach)
- Chart components (line, bar สำหรับ analytics — ใช้ minimal color, ไม่ over-gamify data)
- **[v1.1]** Bottom navigation (64px, 5 แท็บ), Status bar (44px), Toast (4 วินาที), Pill chip, Toggle

## 12.4 Tone of Voice

- ตรงไปตรงมา ไม่ตัดสิน (non-judgmental)
- ใช้ภาษาสนับสนุน (“ลองอีกครั้งได้เสมอ”) แทนภาษาตำหนิ (“คุณทำพลาดอีกแล้ว”)
- หลีกเลี่ยงคำที่กระตุ้นความรู้สึกผิดเกินจำเป็น
- **[v1.1] หลีกเลี่ยงคำว่า “บล็อก” / “ปลดบล็อก” ในข้อความของแอป ใช้ “เตือน” / “หยุดการเตือน” แทน**

---

# 13. Wireframe แนวคิดทุกหน้าจอ

หมายเหตุ: อธิบายเป็น structural wireframe (ASCII/text-based layout description) สำหรับส่งต่อให้ทีมออกแบบ UI ทำ high-fidelity mockup ต่อ **[v1.1] ตัวอ้างอิงหลักคือ prototype (หมวด 12.2.1 และภาคผนวก A) wireframe ด้านล่างเป็นโครงสร้างเบื้องต้นเท่านั้น**

## 13.1 Onboarding — Behavioral Assessment

```
┌───────────────────────────┐
│  ← ...........(4/6)        │  progress indicator
│                             │
│  "คุณมักจะเปิดมือถือ        │
│   เมื่อรู้สึกอย่างไร?"       │  question (single-select)
│                             │
│  ○ เบื่อ                    │
│  ○ เครียด/กังวล             │
│  ○ อยากเลี่ยงงานที่ต้องทำ    │
│  ○ ทำโดยไม่รู้ตัว            │
│                             │
│           [ถัดไป →]         │
└───────────────────────────┘
```

## 13.2 Home Dashboard

```
┌───────────────────────────┐
│ สวัสดี, ปูน  12 วัน  │  greeting + streak
├───────────────────────────┤
│  [ วงกลม progress วันนี้ ]  │  focus minutes today
│     45 / 90 นาที            │
├───────────────────────────┤
│ [▶ เริ่ม Focus Session]     │  primary CTA
├───────────────────────────┤
│ Insight วันนี้:              │
│ "คุณโฟกัสได้ดีที่สุดช่วงเช้า" │
├───────────────────────────┤
│ [Focus][Vault][Analytics][AI][Settings] │ bottom nav
└───────────────────────────┘
```

## 13.3 Focus Session — Active Timer

```
┌───────────────────────────┐
│         25:14              │  countdown, large
│      ╭───────────╮         │
│     │   ⬤ ring    │         │  circular progress
│      ╰───────────╯         │
│  เป้าหมาย: "อ่านบทที่ 4"     │  intention reminder
│                             │
│  [⏸พัก]     [✕ออกจาก session] │
└───────────────────────────┘
```

## 13.4 Friction Gate Modal (L2 — Reflective Pause)

```
┌───────────────────────────┐
│  เดี๋ยวก่อน...            │
│                             │
│  คุณกำลังจะเปิด TikTok       │
│  ตอนนี้เป็นเวลา Focus ของคุณ │
│                             │
│  เหตุผลที่ต้องการเปิด:        │
│  [___________________]      │
│                             │
│  [กลับไปโฟกัส]  [เปิดต่อ (5s)] │
└───────────────────────────┘
```

## 13.5 Vault Partner — Override Request (Partner View) — **[v1.1] v1.1**

```
┌───────────────────────────┐
│  คำขอจาก ปูน                │
│  ต้องการปลดบล็อก Instagram   │
│  เหตุผล: "ต้องเช็คงานกลุ่ม"  │
│  ขอเมื่อ: 2 นาทีที่แล้ว        │
│                             │
│  [อนุมัติ]   [ปฏิเสธ]    │
└───────────────────────────┘
```

## 13.6 Analytics Dashboard

```
┌───────────────────────────┐
│  แนวโน้ม 7 วันล่าสุด          │
│  [ line chart: focus min ]  │
│                             │
│  Dopamine Load Index: 42/100 (ลดลง) │
│                             │
│  เหตุการณ์ distraction: 8 ครั้ง │
│  [ bar chart by app ]       │
└───────────────────────────┘
```

## 13.7 Recovery / Streak Break

```
┌───────────────────────────┐
│  streak ของคุณหยุดที่ 12 วัน │
│  ไม่เป็นไร — ทุกคนมีวันแบบนี้  │
│                             │
│  เกิดอะไรขึ้น?               │
│  ○ เหนื่อยเกินไป             │
│  ○ มีเหตุฉุกเฉิน              │
│  ○ ไม่มีแรงจูงใจ              │
│                             │
│  [เริ่มต้นใหม่วันนี้]          │
└───────────────────────────┘
```

## 13.8 AI Coach Chat

```
┌───────────────────────────┐
│  AI Coach                │
├───────────────────────────┤
│  สัปดาห์นี้คุณโฟกัสเพิ่มขึ้น 20% │
│  จากสัปดาห์ก่อน ลองรักษา      │
│  จังหวะนี้ต่อไหม?              │
├───────────────────────────┤
│  [_______________] [ส่ง]     │  chat input
└───────────────────────────┘
```

---

# 14. Navigation Flow

```
Splash
  └─▶ (first launch?) ─▶ Onboarding Flow ─▶ Home
        │no                                    ▲
        └────────────────────────────────────┘

Home (Tab Root)
 ├─▶ Focus Tab
 │     Session Setup ─▶ Active Timer ─▶ (interrupt?) ─▶ Friction Gate
 │                          │                              │
 │                          ▼                              ▼
 │                    Session Complete ◀────────── (confirm exit / continue)
 │                          │
 │                          ▼
 │                     Reflection ─▶ Home
 │
 ├─▶ Vault Tab   [v1.1]
 │     Partner List ─▶ Partner Detail ─▶ Shared Progress
 │        │                  │
 │        ▼                  ▼
 │     Invite Flow      Override Request History
 │        (Partner side) Approval Inbox ─▶ Approve/Deny ─▶ Confirmation
 │
 ├─▶ Analytics Tab
 │     Trends ─▶ Distraction Log ─▶ Event Detail
 │        │
 │        └─▶ Export
 │
 ├─▶ AI Coach Tab
 │     Chat ─▶ Insight Detail ─▶ Suggested Action ─▶ (deep link to Focus/Settings)
 │
 └─▶ Settings Tab
       Account / Notifications / Privacy / Friction Levels / App Selection / Detection
             │
             └─▶ Emergency Pause (accessible globally via long-press on nav)
```

**Deep link support (v1.1):** `homeo://distraction-event?app=<id>` (iOS Shortcuts), `homeo://focus/start`, `homeo://intervention?app=<id>&level=<0-3>` (สำหรับ push/local notification ที่ต้อง jump ไปหน้าที่เกี่ยวข้อง) — *แก้จาก v1.0 ที่ใช้ `dopaminefocus://` ซึ่งเป็น scheme เดิมที่ไม่ได้ใช้งานจริง*
`dopaminefocus://vault/invite/{token}` และ `dopaminefocus://override/{requestId}` เลื่อนไป v1.1

---

# 15. State Management

## 15.1 แนวทาง (Flutter)

ใช้ **Riverpod 2.x (code-gen)** เป็น state management หลัก ด้วยเหตุผล: type-safety, testability สูง, รองรับ async state (FutureProvider/StreamProvider) ได้ดีสำหรับ sync/offline scenario, และหลีกเลี่ยงปัญหา BuildContext-coupling ของ Provider แบบเดิม

**[v1.1]** โค้ดปัจจุบันใช้ Riverpod 3.x (`flutter_riverpod ^3.0.3`, `riverpod_annotation ^4.0.6`)

## 15.2 State Layers

| Layer | เครื่องมือ | ตัวอย่าง |
| --- | --- | --- |
| **UI State (ephemeral)** | StateProvider / local StatefulWidget | ค่าฟอร์มระหว่างกรอก, animation state |
| **App/Domain State** | NotifierProvider / AsyncNotifierProvider | Active focus session, friction gate, friction settings |
| **Server Cache State** | AsyncNotifierProvider + local cache (Drift) | รายการ Vault Partner (v1.1), analytics data |
| **Persistent Local State** | Drift (SQLite) + SharedPreferences สำหรับ key-value เล็ก | Session queue, cached settings, blocked package list ที่ native อ่าน |
| **Global Auth State** | NotifierProvider<AuthController> | token, session, user profile (v1.1 / Phase 2) |

## 15.3 หลักการ

- **Single source of truth ต่อ domain** — ห้ามมี state ซ้ำซ้อนระหว่าง provider
- **Unidirectional data flow** — UI dispatch action → Notifier update state → UI rebuild
- **Offline-first state** — ทุก mutation (เช่น เริ่ม/จบ session) เขียนลง local DB ก่อนเสมอ แล้วค่อย queue sync ไป backend (ดูหมวด 21-22)
- **Optimistic UI updates** พร้อม rollback mechanism หาก sync ล้มเหลว (Phase 2)

---

# 16. Database Schema (ERD)

## 16.1 ภาพรวม Entity

```
User ──1:N──▶ FocusSession
User ──1:N──▶ DistractionEvent
User ──1:N──▶ HabitGoal
User ──1:1..N──▶ VaultPartnership (as Owner)        [v1.1]
User ──1:1..N──▶ VaultPartnership (as Partner)      [v1.1]
VaultPartnership ──1:N──▶ OverrideRequest           [v1.1]
User ──1:N──▶ BlockedApp  (watch list / แอปที่เตือน)   [v1.1 ชื่อเรียกเปลี่ยน]
User ──1:N──▶ ReflectionEntry
User ──1:1──▶ UserSettings
User ──1:N──▶ NotificationPreference
User ──1:N──▶ AnalyticsSnapshot (daily rollup)      [Phase 2]
User ──1:N──▶ AuditLogEntry                         [v1.1]
User ──1:N──▶ EmergencyOverride                     [v1.1 เพิ่ม]
```

## 16.2 ตาราง (Core Tables)

**users** | Column | Type | Note | |—|—|—| | id | UUID (PK) | | | email | text unique | | | display_name | text | | | auth_provider | enum(email, google, apple) | | | created_at | timestamptz | | | timezone | text | IANA tz name | | onboarding_completed_at | timestamptz null | | | deleted_at | timestamptz null | soft delete |
**[v1.1] MVP:** ไม่มีตาราง users บน server; โปรไฟล์เก็บในเครื่อง (ชื่อ, อีเมล, เบอร์ ตาม prototype)

**focus_sessions** | Column | Type | Note | |—|—|—| | id | UUID (PK) | | | user_id | UUID (FK → users) | | | intention | text | | | planned_duration_sec | int | | | actual_duration_sec | int | | | status | enum(active, completed, aborted) | | | started_at | timestamptz | | | ended_at | timestamptz null | | | local_id | UUID | สำหรับ offline dedup | | synced_at | timestamptz null | | **[v1.1] เพิ่ม:** pause_count, paused_total_sec, paused_at, updated_at

**distraction_events** | Column | Type | Note | |—|—|—| | id | UUID (PK) | | | user_id | UUID (FK) | | | app_package_id | text | | | friction_level | int | L0-L4 | | resolved_action | enum(returned_to_focus, opened_anyway, partner_approved, emergency_override) | | | occurred_at | timestamptz | |
**[v1.1] เพิ่มค่า:** `notified` (การตรวจจับที่เตือนแล้วโดยไม่มี gate), `partner_auto_released` (v1.1) · เพิ่ม `during_session` (bool), `reason_text` (เข้ารหัส)

**vault_partnerships** | Column | Type | Note | |—|—|—| | id | UUID (PK) | | | owner_user_id | UUID (FK) | | | partner_user_id | UUID (FK) | | | status | enum(pending, active, revoked) | | | permission_scope | jsonb | granular visibility flags | | approval_rule | enum(any_partner, all_partners) | สำหรับ multi-partner | | created_at | timestamptz | | | revoked_at | timestamptz null | | **[v1.1] v1.1 เท่านั้น**

**override_requests** | Column | Type | Note | |—|—|—| | id | UUID (PK) | | | partnership_id | UUID (FK) | | | requested_by_user_id | UUID (FK) | | | app_package_id | text | | | reason_text | text | | | status | enum(pending, approved, denied, expired_auto_released) | | | requested_at | timestamptz | | | resolved_at | timestamptz null | | | resolved_by_user_id | UUID null | | **[v1.1] v1.1 เท่านั้น**

**habit_goals** | id, user_id, title, target_type(streak/frequency), target_value, created_at, archived_at |

**blocked_apps** | id, user_id, app_package_id, friction_level, active_hours(jsonb), created_at |
**[v1.1]** ใช้เป็น watch list (รายการแอปที่เตือน) ไม่ใช่รายการบล็อก — ใน MVP เก็บ `app_package_id` (PK), `friction_level` (0–4), `created_at`, `updated_at`, `synced_at` ไม่มี active_hours (เลื่อน Phase 2)

**reflection_entries** | id, user_id, session_id (nullable FK), prompt_key, response_text, mood_tag, created_at |
**[v1.1]** `mood_tag` และ `response_text` เข้ารหัส AES-256-GCM (ดูหมวด 23.2)

**user_settings** | user_id (PK/FK), default_friction_level, quiet_hours(jsonb), locale, theme, emergency_override_limit_per_month |
**[v1.1]** `theme` = light / dark / auto (ค่าเริ่มต้น auto), `streak_break_acked_run_end` เพิ่มสำหรับ Streak Recovery

**emergency_overrides** (ใหม่ v1.1) | id, occurred_at, window_ends_at, partner_notified_at (null ใน MVP), synced_at | append-only

**analytics_snapshots** (daily rollup, materialized สำหรับ dashboard เร็ว) | id, user_id, date, total_focus_min, distraction_count, dopamine_load_index, streak_current, streak_best | **[v1.1] Phase 2** (MVP คำนวณ in-memory)

**audit_log_entries** (append-only) | id, actor_user_id, entity_type, entity_id, action, metadata(jsonb), created_at | v1.1

## 16.3 Indexing Strategy

- focus_sessions(user_id, started_at DESC) — สำหรับ history/analytics query **[v1.1]** ใน MVP ใช้ index บน `started_at`
- distraction_events(user_id, occurred_at DESC) **[v1.1]** ใน MVP ใช้ (app_package_id, occurred_at)
- override_requests(partnership_id, status) — สำหรับ approval inbox query (v1.1)
- vault_partnerships(owner_user_id), vault_partnerships(partner_user_id) (v1.1)
- Partial index บน override_requests WHERE status='pending' เพื่อ query inbox ให้เร็ว (v1.1)

---

# 17. Backend Architecture — **[v1.1] เลื่อนไป Phase 2 (MVP ไม่มี backend)**

## 17.1 ภาพรวม

> **[v1.1] MVP ทำงานทั้งหมดบนเครื่อง (Flutter + Drift + native Android/iOS bridge) ไม่มี API Gateway, Auth Service, Realtime Gateway, PostgreSQL หรือ Redis ใน MVP** สถาปัตยกรรมด้านล่างเป็นแผนสำหรับ Phase 2

```
                      ┌─────────────────┐
                      │   Mobile Apps    │
                      │ (iOS / Android)  │
                      └────────┬─────────┘
                               │ HTTPS/REST + WebSocket
                      ┌────────▼─────────┐
                      │   API Gateway     │  (rate limiting, auth check)
                      └────────┬─────────┘
              ┌────────────────┼────────────────┐
     ┌────────▼──────┐ ┌───────▼───────┐ ┌───────▼────────┐
     │ Auth Service   │ │ Core API      │ │ Realtime Gateway│
     │ (NestJS)       │ │ (NestJS)      │ │ (WebSocket)     │
     └────────┬──────┘ └───────┬───────┘ └───────┬────────┘
              │                 │                  │
     ┌────────▼─────────────────▼──────────────────▼────────┐
     │              PostgreSQL (primary datastore)            │
     └──────────────────────────┬──────────────────────────┘
                                 │
     ┌───────────────┬──────────┴─────────┬──────────────────┐
     │  Redis         │  Job Queue (BullMQ)│  Object Storage   │
     │ (cache/session) │ (notifications,    │ (export files)    │
     │                 │  analytics rollup) │                    │
     └───────────────┴────────────────────┴──────────────────┘
```

## 17.2 Service Breakdown (Modular Monolith → ค่อย extract เป็น microservice เมื่อจำเป็น)

| Module | หน้าที่ |
| --- | --- |
| **AuthModule** | Register/Login, token issuance, OAuth (Google/Apple) — Phase 2 |
| **UserModule** | Profile, settings, onboarding state — Phase 2 |
| **FocusModule** | Session lifecycle, intention, completion logic |
| **FrictionModule** | Friction level calculation, escalation rules (ทำงานในเครื่องใน MVP) |
| **VaultModule** | Partnership management, override request workflow — v1.1 |
| **AnalyticsModule** | Rollup jobs, dopamine load index calculation |
| **NotificationModule** | Push, email, in-app notification dispatch — MVP ใช้ local notification |
| **SyncModule** | Offline delta sync endpoint — Phase 2 |
| **AuditModule** | Immutable audit log writer — v1.1 |

**เหตุผลเลือก Modular Monolith สำหรับ MVP:** ทีมเล็ก, ลด operational overhead ของ microservices ตั้งแต่ต้น, แต่ยังคง module boundary ชัดเจนด้วย NestJS module system เพื่อให้ extract ออกเป็น service แยกได้ในอนาคตโดยไม่ต้อง rewrite

## 17.3 Realtime Requirements — **[v1.1] v1.1**

Override Request ต้องแจ้งเตือน Partner แบบเรียลไทม์ — ใช้ WebSocket gateway (Socket.IO ผ่าน NestJS @WebSocketGateway) ร่วมกับ Push Notification (FCM/APNs) เป็น fallback เมื่อแอปไม่ได้เปิดอยู่

---

# 18. API Specification — **[v1.1] Phase 2 / v1.1**

> **[v1.1] MVP ไม่มี REST API** ข้อมูลทั้งหมดเข้าถึงผ่าน repository ในเครื่อง ส่วนนี้เป็น contract สำหรับ Phase 2

## 18.1 หลักการออกแบบ

REST เป็นหลักสำหรับ CRUD ทั่วไป, ใช้ WebSocket เฉพาะ real-time approval flow เท่านั้น เวอร์ชัน API อยู่ใน path (/v1/...) ทุก response ใช้ envelope มาตรฐาน { data, error, meta }

## 18.2 Endpoint หลัก (ตัวอย่าง)

Auth
POST   /v1/auth/register
POST   /v1/auth/login
POST   /v1/auth/refresh
POST   /v1/auth/oauth/{provider}
POST   /v1/auth/logout

Users
GET    /v1/users/me
PATCH  /v1/users/me
POST   /v1/users/me/onboarding-complete
DELETE /v1/users/me                      (account deletion, GDPR)

Focus Sessions
POST   /v1/focus-sessions                 (start)
PATCH  /v1/focus-sessions/{id}            (pause/resume/abort)
POST   /v1/focus-sessions/{id}/complete
GET    /v1/focus-sessions                 (history, paginated)
POST   /v1/focus-sessions/sync            (batch offline sync)

Friction / Blocked Apps (watch list)
GET    /v1/blocked-apps
PUT    /v1/blocked-apps                   (bulk upsert)
GET    /v1/friction-settings
PATCH  /v1/friction-settings

Distraction Events
POST   /v1/distraction-events             (log event)
POST   /v1/distraction-events/sync        (batch offline sync)

Vault Partner (v1.1)
POST   /v1/vault/invitations
POST   /v1/vault/invitations/{token}/accept
GET    /v1/vault/partnerships
DELETE /v1/vault/partnerships/{id}        (revoke — owner only)
POST   /v1/vault/override-requests
GET    /v1/vault/override-requests?status=pending
POST   /v1/vault/override-requests/{id}/approve
POST   /v1/vault/override-requests/{id}/deny
GET    /v1/vault/audit-log

Emergency
POST   /v1/emergency/override             (rate-limited, logged) — หยุดการเตือนชั่วคราว

Analytics
GET    /v1/analytics/summary?range=7d|30d|90d
GET    /v1/analytics/dopamine-load
GET    /v1/analytics/export?format=csv|json

AI Coach
POST   /v1/ai-coach/messages              (LLM — v2)
GET    /v1/ai-coach/insights

Notifications
GET    /v1/notifications/preferences
PATCH  /v1/notifications/preferences
POST   /v1/notifications/device-token

WebSocket
WS     /v1/ws/vault                        (subscribe: override-request events) (v1.1)

## 18.3 ตัวอย่าง Request/Response (v1.1)

POST /v1/vault/override-requests
{
  "partnershipId": "uuid",
  "appPackageId": "com.instagram.android",
  "reasonText": "ต้องเช็คงานกลุ่มด่วน"
}

201 Created
{
  "data": {
    "id": "uuid",
    "status": "pending",
    "requestedAt": "2026-07-09T10:00:00Z",
    "coolingOffExpiresAt": "2026-07-09T10:20:00Z"
  },
  "error": null,
  "meta": { "requestId": "..." }
}

## 18.4 Error Handling Convention

{
  "data": null,
  "error": {
    "code": "VAULT_PARTNERSHIP_NOT_FOUND",
    "message": "ไม่พบความสัมพันธ์ Vault Partner นี้",
    "httpStatus": 404
  },
  "meta": { "requestId": "..." }
}

Error code namespace แยกตาม module (AUTH_*, VAULT_*, FOCUS_*, SYNC_*, FRICTION_*, DETECT_*) เพื่อให้ client จับ error ได้ชัดเจนและแปลข้อความ localize ได้ง่าย

---

# 19. Authentication & Authorization — **[v1.1] Phase 2**

## 19.1 Authentication

> **[v1.1] MVP ไม่มีบัญชีผู้ใช้ (“ไม่มีบัญชีก็ใช้ได้” ตาม prototype)** ข้อมูลอยู่ในเครื่อง การลบข้อมูลทำผ่านปุ่ม “ลบข้อมูลทั้งหมดในเครื่อง” แทนการลบบัญชี

- **วิธีการ (Phase 2):** Email+Password, Sign in with Apple (บังคับสำหรับ iOS ตามข้อกำหนด App Store), Sign in with Google
- **Provider:** Firebase Authentication (รองรับ OAuth หลายเจ้า, มี SDK Flutter สำเร็จรูป, ลดงาน infra ช่วง MVP) — Backend (NestJS) ตรวจสอบ Firebase ID Token ผ่าน Admin SDK แล้วออก **application-level JWT** (access token อายุสั้น 15 นาที + refresh token อายุยาว 30 วัน เก็บแบบ rotate) เพื่อคุม authorization ภายในระบบเราเอง ไม่ผูกกับ Firebase claim โดยตรง
- **MFA:** ไม่บังคับใน MVP แต่ออกแบบ schema ให้รองรับ TOTP ในอนาคต

## 19.2 Authorization Model (v1.1)

**Role-based + Relationship-based (ReBAC) แบบผสม:**

| Role | ขอบเขตสิทธิ์ |
| --- | --- |
| owner (เจ้าของบัญชี) | เต็มสิทธิ์เหนือข้อมูลตนเองเสมอ, ยกเลิก Vault Partnership ได้ฝ่ายเดียว |
| vault_partner | สิทธิ์จำกัดตาม permission_scope ของ partnership นั้น ๆ เท่านั้น (ไม่ใช่ role ระดับ global) |
| system/service | ใช้สำหรับ internal job (analytics rollup, notification dispatch) ผ่าน service account แยก |

Authorization ตรวจสอบสองชั้นเสมอ: (1) JWT scope/role ระดับ endpoint (NestJS Guard) และ (2) ownership check ระดับ resource เพื่อป้องกัน IDOR

## 19.3 Token Handling (Phase 2)

- Access token: JWT (RS256), ส่งผ่าน Authorization: Bearer
- Refresh token: เก็บใน secure storage ฝั่ง client (flutter_secure_storage), rotate ทุกครั้งที่ใช้
- Revocation list ใน Redis สำหรับ logout/บัญชีถูกลบ

---

# 20. Notification Architecture

## 20.1 ประเภท Notification

| ประเภท | ช่องทาง | Trigger | **[v1.1] สถานะ** |
| --- | --- | --- | --- |
| **การเตือนเปิดแอปที่เลือก (L0–L3)** | Local notification (Android: native, iOS: deep link) | ตรวจจับการเปิดแอป | **MVP (เปลี่ยนจาก override request)** |
| Override request | Push | Owner ส่งคำขอ | v1.1 |
| Focus reminder | Local notification | ตามตารางที่ตั้งไว้ | MVP |
| Session จบ | Local notification (alarm) | ครบเวลาตอนแอปอยู่เบื้องหลัง | MVP |
| Weekly summary | Local (repeating) | อาทิตย์ 20:00 | MVP |
| Streak at risk | Push | ใกล้หมดวันแต่ยังไม่ทำ session | Phase 2 |
| Partner accepted invite | Push | Partner ตอบรับคำเชิญ | v1.1 |
| AI Coach insight | In-app (ไม่ push spam) | เมื่อพบ pattern ที่น่าสนใจ | MVP (rule-based) |

## 20.2 สถาปัตยกรรม

**[v1.1] MVP (local-only):**

```
Android: AccessibilityService ──▶ Native queue + NotificationCompat (ยิงตรงจาก Kotlin)
iOS:     Shortcuts Automation ──▶ homeo://distraction-event ──▶ Flutter ──▶ flutter_local_notifications
Flutter: Session alarm / Focus reminder / Weekly summary ──▶ flutter_local_notifications
```

**Phase 2 / v1.1 (เดิมจาก v1.0):**

```
Event (domain) ──▶ NotificationModule ──▶ BullMQ Job
                                              │
                          ┌───────────────────┼────────────────────┐
                          ▼                   ▼                    ▼
                   FCM (Android)        APNs (iOS)          In-app store (DB)
```

- ใช้ Job Queue (BullMQ + Redis) กัน notification service ล่มเวลาโหลดสูง และรองรับ retry/backoff (Phase 2)
- Override request ใช้คิวความสำคัญสูง (priority queue) แยกจาก notification ทั่วไป เพื่อ latency ต่ำสุด (<3 วินาที) (v1.1)
- Deep-link payload แนบไปกับทุก notification เพื่อให้กด notification แล้วพาไปหน้าที่เกี่ยวข้องทันที (ดู navigation flow หมวด 14)

## 20.3 User Control

ผู้ใช้ตั้งค่า quiet hours และปิด/เปิดแต่ละประเภทได้แยกกัน **[v1.1]** ใน MVP quiet hours ตั้งได้แต่บังคับใช้เต็มรูปแบบใน v1.1 ยกเว้น override request ที่ปิดไม่ได้ทั้งหมด (สามารถลด priority ได้แต่ปิดสนิทไม่ได้) — ต้องแจ้งผู้ใช้อย่างชัดเจนตอน setup

## 20.4 [v1.1] Notification Channels (Android) และการขอสิทธิ์

| Channel ID | ชื่อ (th) | ใช้สำหรับ | ความสำคัญ |
| --- | --- | --- | --- |
| `app_opened_warning` | เตือนเมื่อเปิดแอปที่ระวัง | การเตือนเมื่อเปิดแอปที่เลือก (ID ต่อแอปทับของเดิม) | High |
| `focus_session_events` | Focus session | เริ่ม/จบ session | Default |
| `focus_session_end` | Focus session | alarm เมื่อครบเวลา (ทำงานแม้แอปเบื้องหลัง) | High |
| `weekly_summary` | สรุปประจำสัปดาห์ | อาทิตย์ 20:00 | Default |

- Android 13+ ขอ `POST_NOTIFICATIONS` ผ่าน permission_handler ก่อนใช้งานครั้งแรก มิฉะนั้น Android จะไม่แสดงการแจ้งเตือนโดยไม่แจ้งเตือนผู้ใช้
- iOS ขอสิทธิ์ผ่าน flutter_local_notifications
- การขอสิทธิ์ทำตามบริบท (หน้า Detection / Permissions ใน onboarding) ไม่ขอตอน launch
- Exact alarm (Android 14+) อาจถูกปฏิเสธ จึงใช้ inexact เป็น fallback แทนการพาผู้ใช้ไปหน้า Settings

---

# 21. Offline-first Design

## 21.1 หลักการ

ฟีเจอร์หลัก (focus session, การตรวจจับแอป, การเตือน, distraction logging) ต้อง **ทำงานได้ 100% แบบ offline** เพราะเป็นกลไกป้องกันพฤติกรรมที่เกิดขึ้นได้ทุกที่ ไม่ควรพึ่งพา network

## 21.2 Local Data Layer

- **Drift (SQLite wrapper สำหรับ Flutter)** เป็น local database หลัก — mirror schema ของ core entity (focus_sessions, distraction_events, blocked_apps, reflection_entries, user_settings, emergency_overrides)
- **[v1.1]** SharedPreferences (`flutter.` prefix) สำหรับ key-value เล็ก เช่น รายการแอปที่ native ใช้ตรวจจับ
- **[v1.1]** Hive ที่ระบุใน v1.0 ถูกแทนด้วย SharedPreferences และ native queue ใน MVP เพื่อลด dependency

## 21.3 Local-first Write Pattern

- ทุก mutation เขียนลง local DB ก่อนเสมอ พร้อม local_id (UUID generated client-side) และ synced_at = null
- UI อ่านจาก local DB เสมอ (ไม่รอ network round-trip)
- Background sync worker (WorkManager บน Android, BGTaskScheduler บน iOS) พยายาม push record ที่ synced_at = null ไปยัง backend เมื่อมีเน็ต (Phase 2)

## 21.4 [v1.1] การตรวจจับและการเตือนแบบ Offline (แทน "App Blocking แบบ Offline" ของ v1.0)

> **[v1.1] v1.0 ระบุว่าการบล็อกแอปทำงานผ่าน native platform API และ friction level อยู่ใน Hive เพื่อให้บล็อกได้แม้ปิด network ฉบับนี้เปลี่ยนเป็น “การตรวจจับและการเตือน” ไม่มีการบล็อก**

**Android (ทำงานเต็มรูปแบบ):**
1. `FocusAccessibilityService` รับ `typeWindowStateChanged` และอ่าน `packageName`
2. อ่านรายการแอปที่เลือกจาก SharedPreferences (`flutter.blocked_packages`) ทุกครั้งใน `onServiceConnected` และเมื่อรายการเปลี่ยน (ไม่พึ่ง static variable ที่ RAM หายเมื่อ process ถูกฆ่า)
3. เมื่อพบแอปที่เลือก: ยิง notification ตรงจาก Kotlin (`NotificationCompat`) และเพิ่มเหตุการณ์เข้าคิวฝั่ง native
4. Flutter เรียก `drainPendingEvents` เมื่อ resume แล้วบันทึกลง `distraction_events` (id เป็น deterministic `native_<ts>_<package>` กันซ้ำ) จากนั้นจึง `ackPendingEvents` เสมอหลังบันทึกสำเร็จ
5. `MainActivity` รับคำสั่งจาก Dart ผ่าน MethodChannel `com.cheapdopamine.homeo/friction`: `isAccessibilityEnabled`, `openAccessibilitySettings`, `setBlockedPackages`, `drainPendingEvents`, `ackPendingEvents`, `allow`, `allowAll`, `returnHome`, `isIgnoringBatteryOptimizations`, `requestIgnoreBatteryOptimizations`

**iOS (demo):**
1. ผู้ใช้สร้าง Shortcuts Automation “App is Opened” ทีละแอป (ปิด “Ask Before Running”)
2. Action “Open URLs” เปิด `homeo://distraction-event?app=<id>`
3. Homeo รับลิงก์ผ่าน `app_links` บันทึกเหตุการณ์และแสดง notification
4. ข้อจำกัด: Apple ไม่เปิด public API ให้ตรวจจับ foreground app โดยไม่มี FamilyControls entitlement (ต้องมี paid Developer account) ผู้ใช้ลบ automation เองได้ตลอดเวลา และอาจมีการหน่วงเล็กน้อย

**การปิดการตรวจจับ:** ผู้ใช้ปิด Accessibility Service หรือลบ Automation ได้ทุกเมื่อ แอปแสดงสถานะ On/Off ในหน้า Detection (ไม่มีการบังคับ)

---

# 22. Sync Strategy — **[v1.1] Phase 2**

## 22.1 Sync Model

**Delta sync แบบ client-push, server-merge** — client ส่งเฉพาะ record ที่เปลี่ยนแปลง (synced_at IS NULL หรือ updated_at > last_sync_at) เป็น batch ผ่าน POST /v1/{resource}/sync

> **[v1.1] MVP:** คงฟิลด์ `synced_at` และ `updated_at` ไว้ในทุกตารางเพื่อให้ Phase 2 push ได้โดยไม่ต้อง migrate schema

## 22.2 Conflict Resolution

| ประเภทข้อมูล | กลยุทธ์ |
| --- | --- |
| Append-only (distraction_events, reflection_entries, emergency_overrides) | ไม่มี conflict — insert ตาม local_id (idempotent, server ignore ถ้า local_id ซ้ำ) |
| Mutable (user_settings, blocked_apps) | **Last-Write-Wins ด้วย updated_at timestamp** พร้อมเก็บ conflict log ไว้ตรวจสอบ |
| Session state (focus_sessions) | Server เป็น source of truth หลังจาก sync สำเร็จ — client เชื่อ server response เพื่อ resolve status |

## 22.3 Sync Triggers

- App เข้า foreground
- Network state เปลี่ยนจาก offline → online
- ทุก 15 นาทีเมื่อ app อยู่ foreground (periodic background sync)
- Manual pull-to-refresh

## 22.4 Idempotency

ทุก sync endpoint รับ local_id เป็น idempotency key — server upsert แทน insert ตรงเพื่อป้องกัน duplicate เมื่อ retry (เช่น network หลุดกลางทาง) **[v1.1]** การนำเข้าเหตุการณ์จาก native ใช้ deterministic id เช่นเดียวกัน

---

# 23. Security Model

## 23.1 Application Security

- Input validation ทุก endpoint ด้วย class-validator (NestJS DTO) (Phase 2) **[v1.1]** MVP validate ที่ repository และ UI (เช่น ความยาว intention ไม่เกิน 140 ตัวอักษร, เหตุผลอย่างน้อย 3 ตัวอักษร)
- Rate limiting ระดับ IP + user (@nestjs/throttler + Redis) โดยเฉพาะ endpoint ที่มีความเสี่ยงสูง (auth, override-requests, emergency) (Phase 2)
- CSRF ไม่จำเป็นสำหรับ mobile-only API แต่ยังคง CORS policy รัดกุมสำหรับ future web
- Dependency scanning อัตโนมัติใน CI (Dependabot/Snyk)

## 23.2 Data Security

- Encryption at rest: PostgreSQL ผ่าน disk-level encryption ของ cloud provider (Phase 2)
- Encryption in transit: TLS 1.2+ ทุก endpoint บังคับ HTTPS (Phase 2)
- **[v1.1] Column-level encryption ใน MVP:** `reflection_entries.mood_tag`, `reflection_entries.response_text`, `distraction_events.reason_text` เข้ารหัส AES-256-GCM ผ่าน `FieldCipher` รูปแบบ `v1:` + base64(nonce ‖ ciphertext ‖ mac) คีย์ 256-bit เก็บใน Android Keystore / iOS Keychain (ผ่าน flutter_secure_storage) หากคีย์หาย ข้อมูลนี้อ่านไม่ได้โดยตั้งใจ
- Sensitive field ที่ระบุใน v1.0 (AES-256-GCM ผ่าน KMS) ใช้ KMS เมื่อเข้า Phase 2
- Secrets management ผ่าน environment-based secret manager (ไม่ commit secret ลง repo, ใช้ GitHub Actions secrets)

## 23.3 Vault Partner Security (v1.1)

- Override request payload เป็น scoped data เท่านั้น
- Owner สามารถ revoke สิทธิ์ Partner ได้ทันทีแบบ real-time (ตัด websocket subscription + invalidate token scope)

## 23.4 Abuse Prevention

- Rate limit emergency pause (ค่าเริ่มต้น 3 ครั้ง/เดือน, ปรับได้แต่มี hard ceiling 10)
- **[v1.1]** Anomaly detection (Phase 2) ตรวจ pattern ผิดปกติ เช่น partnership ที่มี deny rate 100% ต่อเนื่อง (v1.1)

---

# 24. Privacy & Compliance

## 24.1 หลักการ

Privacy-by-design และ data minimization — เก็บเฉพาะข้อมูลที่จำเป็นต่อฟีเจอร์จริง ไม่เก็บเนื้อหาที่ผู้ใช้เสพ (เช่น ไม่เก็บว่าผู้ใช้ดูวิดีโออะไร เก็บแค่ app package + เวลา)

**[v1.1]** Accessibility Service อ่านเฉพาะ package name (`canRetrieveWindowContent = false`) ไม่อ่านข้อความบนหน้าจอ และแสดงคำอธิบายนี้ก่อนขอสิทธิ์

## 24.2 ประเด็นตามกฎหมาย/มาตรฐาน (สรุปหลักการทั่วไป — ไม่ใช่คำแนะนำทางกฎหมาย)

- **[v1.1] พ.ร.บ.คุ้มครองข้อมูลส่วนบุคคล (PDPA) ของไทย** เป็นกรอบหลักใน MVP: หลักความยินยอม, การเก็บข้อมูลน้อยที่สุด, สิทธิ์เข้าถึง/แก้ไข/ส่งออก/ลบ (ปุ่ม “ลบข้อมูลทั้งหมดในเครื่อง” และส่งออกเป็น CSV/JSON)
- **GDPR-style rights (Phase 2):** สิทธิ์เข้าถึง (access), แก้ไข (rectification), ลบ (erasure), และ portability — implement ผ่าน DELETE /v1/users/me และ GET /v1/analytics/export
- **Consent management:** ทุกการแชร์ข้อมูลกับ Vault Partner ต้องเป็น explicit opt-in ระดับ field (granular consent) (v1.1)
- **Data retention:** กำหนด retention policy ชัดเจน (เช่น distraction event raw log เก็บ 24 เดือน แล้ว aggregate เป็น summary, ลบ raw record)
- **Minors:** เวอร์ชัน 1.0 กำหนดอายุขั้นต่ำ 16 ปีในเงื่อนไขการใช้งาน ประเมินเพิ่มเติมภายหลัง
- **[v1.1] Privacy Policy** ต้องระบุว่า MVP ไม่มีการส่งข้อมูลออกนอกเครื่อง และไม่มี analytics SDK ภายนอกหรือโฆษณา

## 24.3 Data Sensitivity Classification

| ระดับ | ตัวอย่างข้อมูล | มาตรการ |
| --- | --- | --- |
| High | Reflection entries, mood tags, reason text | Column-level encryption, ไม่แชร์กับ Partner โดยอัตโนมัติ |
| Medium | Distraction event log, override reason text | Scoped visibility ตาม consent (v1.1) |
| Low | Streak count, session completion count | แสดงให้ Partner เห็นเป็นค่า default (แต่ยัง toggle ปิดได้) (v1.1) |

## 24.4 Third-party Data Sharing

ไม่ขายหรือแชร์ข้อมูลผู้ใช้กับบุคคลที่สามเพื่อวัตถุประสงค์โฆษณา **[v1.1]** MVP ไม่มีผู้ให้บริการภายนอกที่รับข้อมูล (ไม่มี Firebase, ไม่มี cloud) ผู้ให้บริการที่ใช้ในอนาคต (Firebase Auth, FCM, cloud hosting) เป็น data processor ภายใต้ data processing agreement เท่านั้น ต้องระบุไว้ใน Privacy Policy

---

# 25. Risk Analysis พร้อมแนวทางลดความเสี่ยง

| ความเสี่ยง | โอกาสเกิด | ผลกระทบ | แนวทางลดความเสี่ยง |
| --- | --- | --- | --- |
| ผู้ใช้ถอนแอปทิ้งเพราะ friction มากไป | สูง | สูง | Adaptive friction, onboarding ที่ตั้งค่า default เหมาะสม, A/B test ระดับ friction |
| ผู้ใช้ปิด permission (Accessibility/Usage Access) เพื่อเลี่ยงระบบ | สูง | สูง | ตรวจจับการปิด permission แล้วแจ้งเตือนเชิงบวก (ไม่บังคับ), ให้ค่าเมื่อเปิดใช้ครบ (streak bonus) |
| ใช้อุปกรณ์/บัญชีสำรองเลี่ยงการเตือน | กลาง | กลาง | เป็นข้อจำกัดโดยธรรมชาติของ mobile OS sandboxing — สื่อสารให้ผู้ใช้เข้าใจว่าแอปช่วยสร้างวินัย ไม่ใช่ “คุก” ที่หนีไม่ได้ 100% |
| Burnout จากการตั้งเป้าหมายเข้มงวดเกินไป | กลาง | สูง | Progressive difficulty, non-punishing streak design, AI Coach แนะนำปรับเป้าหมายเมื่อพบสัญญาณ overload |
| Vault Partner ถูกใช้เป็นเครื่องมือควบคุมเกินขอบเขต (coercive control) | ต่ำ-กลาง | สูงมาก | Owner ยกเลิกสิทธิ์ได้เสมอฝ่ายเดียว, anomaly detection, in-app resource แนะนำเมื่อพบสัญญาณเสี่ยง (v1.1) |
| False positive ในการตรวจจับ (เช่น เปิดแอปเพื่อทำงานจริง) | กลาง | ต่ำ-กลาง | Context-aware allowlist, ให้ผู้ใช้ mark “งานจริง” แล้วระบบเรียนรู้ pattern |
| Privacy breach / data leak | ต่ำ | สูงมาก | Encryption, least-privilege access, security audit สม่ำเสมอ, data minimization |
| Platform policy risk (Apple/Google เข้มงวดเรื่อง Accessibility API) | กลาง | สูง | **[v1.1]** Android ใช้ AccessibilityService อย่างจำกัด (ไม่อ่านเนื้อหา) และไม่เผยแพร่บน Play Store ใน MVP; iOS ใช้ Shortcuts ไม่ใช้ API ที่ถูกจำกัด |
| Scope creep จากฟีเจอร์เยอะเกินไปใน MVP | สูง | กลาง | ยึด MVP scope ตามหมวด 36 และ 39 อย่างเคร่งครัด, ใช้ RICE prioritization สำหรับฟีเจอร์เพิ่มเติม |
| ทีมพัฒนาเล็ก ความเร็วไม่พอ timeline | กลาง | กลาง | Modular monolith ลด overhead, local-first ลด infra, ใช้ managed service แทนสร้างเอง (Phase 2) |
| **[v1.1]** การเตือนไม่มีผลต่อพฤติกรรม (ไม่มีการบังคับ) | กลาง | สูง | วัด warning return rate, ปรับข้อความ/จังหวะ, รายงานข้อจำกัดตรงไปตรงมาในรายงานโครงงาน |
| **[v1.1]** iOS ทดสอบต่อเนื่องไม่ได้ (ไม่มี paid Apple Developer, free Apple ID หมดอายุทุก 7 วัน) | สูง | กลาง | ระบุเป็น demo, ใช้ Codemagic build, บันทึกผลทดสอบเป็นหลักฐาน |

---

# 26. Technical Stack พร้อมเหตุผล

| Layer | เทคโนโลยี | เหตุผล |
| --- | --- | --- |
| Mobile Client | **Flutter (Dart)** | Codebase เดียวสำหรับ iOS/Android, performance ใกล้เคียง native, community/ecosystem แข็งแรง, เหมาะกับทีมเล็กที่ต้อง ship เร็ว |
| State Management | **Riverpod 3.x (code-gen)** | Type-safe, testable, รองรับ async/offline state ได้ดีกว่า Provider/BLoC สำหรับ use case นี้ |
| Local DB | **Drift (SQLite)** + **SharedPreferences** | Drift สำหรับ relational data (session history), SharedPreferences สำหรับ key-value ที่ native ต้องอ่าน (**[v1.1]** แทน Hive) |
| Native Android | **Kotlin AccessibilityService + MethodChannel** | ตรวจจับการเปิดแอปและเตือนแม้ Flutter engine ไม่ทำงาน |
| iOS detection | **Shortcuts Automation + app_links** | ไม่มีค่าใช้จ่ายและไม่ต้องใช้ entitlement |
| Notifications | **flutter_local_notifications** + **permission_handler** | การเตือนในเครื่องโดยไม่ต้องใช้ server (**[v1.1]** แทน FCM ใน MVP) |
| Encryption | **cryptography (AES-GCM)** + **flutter_secure_storage** | เข้ารหัส field ระดับ High โดยคีย์อยู่ใน Keystore/Keychain |
| Backend Framework | **NestJS (Node.js/TypeScript)** | Modular architecture ตรงกับแนวทาง modular monolith — **[v1.1] Phase 2** |
| Database | **PostgreSQL** | ACID compliance, jsonb รองรับ permission_scope แบบยืดหยุ่น — **[v1.1] Phase 2** |
| Auth | **Firebase Authentication** | ลดงาน infra สำหรับ OAuth/social login — **[v1.1] Phase 2** |
| Cache/Queue | **Redis + BullMQ** | Job queue สำหรับ notification/analytics rollup — **[v1.1] Phase 2** |
| Push Notification | **FCM (Android) / APNs (iOS)** | มาตรฐานอุตสาหกรรม — **[v1.1] Phase 2** (MVP ใช้ local notification) |
| CI/CD | **GitHub Actions** | Integrate ตรงกับ GitHub repo — **[v1.1] free tier**; iOS build ผ่าน **Codemagic** เพราะไม่มี macOS |
| Containerization | **Docker** | Consistent environment dev/staging/prod — **[v1.1] Phase 2** |
| Hosting (Backend) | **Managed container platform (เช่น AWS ECS Fargate หรือเทียบเท่า)** | — **[v1.1] Phase 2 และขึ้นกับงบประมาณ** |
| Monitoring | **Sentry (error tracking)** | **[v1.1] free tier หรือ log ในเครื่องใน MVP** |
| API Style | **REST (หลัก) + WebSocket (real-time approval)** | — **[v1.1] Phase 2 / v1.1** |

## 26.1 [v1.1] Flutter Dependencies (MVP)

| Package | ใช้ทำอะไร |
| --- | --- |
| `flutter_riverpod` / `riverpod_annotation` (+ `riverpod_generator`) | State management |
| `go_router` | Routing (5 tab, StatefulShellRoute) |
| `drift` / `drift_flutter` (+ `drift_dev`) | Local database |
| `flutter_local_notifications` | การเตือน, session alarm, weekly summary |
| `timezone` | กำหนดเวลาการแจ้งเตือนแบบ absolute (ใช้ UTC) |
| `permission_handler` | ขอ `POST_NOTIFICATIONS` (Android 13+) |
| `shared_preferences` | รายการแอปที่ native อ่านได้ (`flutter.blocked_packages`) |
| `app_links` | รับ deep link `homeo://` จาก iOS Shortcuts |
| `cryptography` | AES-256-GCM สำหรับ field ระดับ High |
| `flutter_secure_storage` | เก็บคีย์เข้ารหัสใน Keystore / Keychain |
| `characters` | นับตัวอักษรแบบ grapheme (รองรับวรรณยุกต์ภาษาไทย) |
| `intl` / `flutter_localizations` | ภาษาไทยและอังกฤษ (ARB) |
| `uuid` | สร้าง id ฝั่ง client |

---

# 27. Flutter Project Structure

```
lib/
├── main.dart
├── app/
│   ├── app.dart                 # MaterialApp root, theme, routing
│   ├── boot.dart                # start-up (local DB เป็นส่วนที่ต้องสำเร็จ)
│   ├── router/                  # go_router configuration
│   └── shell/                   # Scaffold + bottom navigation (5 tabs)
├── core/
│   ├── constants/
│   ├── theme/                   # design tokens (หมวด 12.2.1)
│   ├── local_db/                # Drift database, tables
│   ├── security/                # FieldCipher (AES-GCM), KeyStore
│   ├── notifications/           # notification_service.dart (local notifications)
│   ├── time/                    # Clock (injectable)
│   ├── utils/                   # duration_format
│   ├── network/                 # dio client (Phase 2)
│   ├── error/                   # error/failure types
│   └── utils/
├── features/
│   ├── onboarding/              # 6 ขั้นตอนตาม prototype
│   ├── focus_session/
│   │   ├── data/                # repositories, session_alarm
│   │   ├── domain/              # entities, rules, streak_calculator
│   │   └── presentation/        # screens, widgets, providers
│   ├── friction/                # [v1.1] การตรวจจับ การเตือน และ friction gate
│   │   ├── data/                # blocker_bridge (MethodChannel), detected_app_ingest, deep_link_service, partner_gateway (stub)
│   │   ├── domain/              # friction_level, friction_policy, friction_rules, app_catalog
│   │   └── presentation/        # friction_gate_overlay, detection_setup_screen, friction_settings_screen
│   ├── vault_partner/           # [v1.1] Placeholder ใน MVP
│   ├── analytics/               # Insights (ใช้ในเครื่อง)
│   ├── ai_coach/                # rule-based ใน MVP
│   ├── notifications/
│   ├── settings/
│   └── auth/                    # Phase 2
├── shared/
│   ├── widgets/                 # choice_pill, remaining_builder, placeholder_screen
│   └── extensions/
└── l10n/                        # localization (th, en) — app_th.arb, app_en.arb

android/app/src/main/kotlin/.../friction/
└── FocusAccessibilityService.kt # [v1.1] AccessibilityService: ตรวจจับ + แจ้งเตือน + คิว
android/app/src/main/res/xml/
└── accessibility_service_config.xml
```

**หลักการ:** Feature-first + Clean Architecture แบบ pragmatic (data/domain/presentation ต่อ feature) — ไม่ over-engineer เป็น full Clean Architecture 4-layer เพราะทีมเล็ก แต่คง separation of concerns ที่เพียงพอให้ test ได้และสลับ implementation (เช่น local vs remote data source) ได้ง่าย

---

# 28. Monorepo Structure

```
dopamine-focus/
├── apps/
│   ├── mobile/                   # Flutter app (โครงสร้างหมวด 27)
│   └── backend/                  # NestJS app — Phase 2
│       ├── src/
│       │   ├── modules/
│       │   │   ├── auth/
│       │   │   ├── users/
│       │   │   ├── focus-sessions/
│       │   │   ├── friction/
│       │   │   ├── vault/
│       │   │   ├── analytics/
│       │   │   ├── notifications/
│       │   │   ├── sync/
│       │   │   └── audit/
│       │   ├── common/           # guards, interceptors, pipes
│       │   └── main.ts
│       └── test/
├── packages/
│   ├── api-contracts/            # OpenAPI spec + generated types — Phase 2
│   └── shared-config/            # eslint, tsconfig, prettier ร่วม
├── infra/
│   ├── docker/
│   ├── terraform/ (หรือ IaC ที่เลือกใช้)
│   └── ci/
├── docs/
│   └── prd/                      # เอกสารนี้และเอกสารประกอบ
├── .github/workflows/
├── turbo.json (หรือ nx.json)     # build orchestration
└── package.json
```

**[v1.1] MVP:** เริ่มจาก `apps/mobile` เพียงอย่างเดียว โครงสร้าง backend และ packages เป็นแผน Phase 2 ไม่ต้องสร้างตั้งแต่ต้น

**เครื่องมือ Monorepo:** ใช้ **Turborepo** สำหรับส่วน backend/TypeScript packages (เบา เรียนรู้ง่าย เหมาะทีมเล็ก) โดย Flutter app อยู่ใน monorepo เดียวกันแต่ build ผ่าน toolchain ของตัวเอง

---

# 29. CI/CD

## 29.1 Pipeline Overview (GitHub Actions)

```
on: pull_request →
  ┌─ lint (dart analyze)
  ├─ unit tests (flutter test)
  ├─ build check (flutter build apk --debug)
  └─ security scan (dependency audit)

on: merge to main →
  ┌─ full test suite (unit + widget)
  ├─ build APK artifact
  └─ publish to GitHub Releases (pre-release)

on: release tag (vX.Y.Z) →
  ┌─ build release APK
  ├─ iOS build via Codemagic (ไม่มี macOS runner ของตัวเอง)
  └─ tag release notes
```

> **[v1.1] หมายเหตุ:** v1.0 วางแผนการ deploy backend, Firebase App Distribution, TestFlight และ fastlane ซึ่งต้องใช้ paid services เลื่อนไป Phase 2 หลังมีงบประมาณ

## 29.2 macOS Runner สำหรับ iOS

เนื่องจากการ build/sign iOS ต้องใช้ macOS toolchain (Xcode) — **[v1.1]** ใช้ **Codemagic** (free tier) เป็น build farm เพราะไม่มี macOS ส่วนตัว การจัดการ signing ด้วย free Apple ID ทำได้เฉพาะ development build บนเครื่องตนเอง (หมดอายุทุก 7 วัน) ส่วน Fastlane Match และการส่งไป App Store ต้องใช้ paid Apple Developer Program จึงเลื่อนไป Phase 2

## 29.3 Environments

| Environment | วัตถุประสงค์ | Deploy Trigger |
| --- | --- | --- |
| dev | ทดสอบระหว่างพัฒนา (เครื่องจริง) | ทุก push branch feature |
| staging | QA, internal testing (APK) | merge to main |
| production | ผู้ใช้จริง (Phase 2) | release tag + manual approval |

**[v1.1]** MVP มี dev และ staging (APK สาธิต) เท่านั้น production เป็น Phase 2

---

# 30. Testing Strategy

## 30.1 Testing Pyramid

```
        ▲  E2E (น้อยที่สุด)
       ╱ ╲   Patrol/Maestro — critical flows เท่านั้น
      ╱   ╲
     ╱     ╲  Integration Tests
    ╱       ╲  API integration, DB integration, sync flow
   ╱─────────╲
  ╱           ╲  Widget Tests (Flutter) / Unit Tests (Nest)
 ╱             ╲  ครอบคลุมมากที่สุด
╱───────────────╲
```

## 30.2 รายละเอียดตามชั้น

| ชั้น | เครื่องมือ | ขอบเขต | เป้าหมาย coverage |
| --- | --- | --- | --- |
| Unit Test (Flutter) | flutter_test, mocktail | Domain logic, use cases, providers | ≥80% ของ business logic |
| Unit Test (Backend) | jest | Services, guards, pipes | ≥80% — Phase 2 |
| Widget Test | flutter_test | Component rendering, interaction | Critical UI components ทั้งหมด |
| Integration Test (Backend) | jest + testcontainers (Postgres) | API endpoint end-to-end ต่อ module | ทุก endpoint หลัก — Phase 2 |
| E2E Mobile | Patrol หรือ Maestro | Onboarding, Focus session flow | Critical path 3–5 flow (**[v1.1]** Vault flow เลื่อน) |
| Offline/Sync Test | Custom test harness จำลอง network toggling | Conflict resolution, idempotency ของ sync | ครอบคลุมทุก conflict scenario ในหมวด 22.2 — Phase 2 |
| **[v1.1] Native Detection Test** | ทดสอบบนเครื่องจริง | AccessibilityService → queue → ingest → ack, การยิง notification ตอนแอปถูกฆ่า | ผ่านทุกเส้นทาง |
| **[v1.1] Visual parity** | Checklist manual | เทียบ screenshot กับ prototype ทุกหน้า (หมวด 12.2.1) | ไม่เกิน 1 รายการผิดเพี้ยนต่อหน้า (ยกเว้นข้อยกเว้น contrast) |
| Security Test | OWASP ZAP (baseline scan), manual pentest ก่อน launch | Auth, authorization, injection | ก่อนทุก major release — Phase 2 |
| Load Test | k6 | Backend endpoint หลัก | ก่อน public launch — Phase 2 |

## 30.3 การทดสอบเฉพาะโดเมน (Behavioral correctness)

เพิ่มจาก testing ปกติ — เนื่องจากผลิตภัณฑ์นี้พึ่งพา “ตรรกะพฤติกรรม” ที่ผิดพลาดได้ง่าย (เช่น friction escalation, streak calculation, timer ที่ผ่านการ suspend) จึงต้องมี **scenario-based test suite** เฉพาะ เช่น
- “Session ครบเวลาขณะแอปอยู่เบื้องหลัง ต้องแจ้งเตือนตรงเวลา” (**[v1.1]** แทน cooling-off)
- “Streak นับข้ามวันโดยมีเพียง session เดียวต่อวัน และไม่ขาดจนกว่าจะผ่านไปหนึ่งวันเต็มโดยไม่มี session”
- “เหตุการณ์จาก native ที่ถูกนำเข้าซ้ำหลัง crash ต้องไม่เกิดรายการซ้ำ”

---

# 31. Release Strategy

## 31.1 Release Cadence

- **Backend:** Continuous deployment สู่ staging ทุก merge, production release แบบ controlled — **[v1.1] Phase 2**
- **Mobile:** **[v1.1]** MVP เผยแพร่เป็น APK ผ่าน GitHub Releases ตามรอบของโครงงาน ไม่อยู่ใน store ในช่วงนี้

## 31.2 Rollout Strategy

- **Backend:** Blue-green หรือ rolling deployment พร้อม health check ก่อน route traffic เต็ม — Phase 2
- **Mobile:** **[v1.1]** Staged rollout ผ่าน Google Play (10% → 50% → 100%) และ App Store phased release เป็น Phase 2 หลังมีบัญชีนักพัฒนา
- **Feature Flags:** **[v1.1]** ใน MVP ใช้ค่า constant ใน `friction_rules.dart` และ `focus_rules.dart` (ปรับได้ที่จุดเดียว) Firebase Remote Config เป็น Phase 2

## 31.3 Rollback Plan

- Backend: เก็บ previous container image พร้อม rollback ได้ภายใน <5 นาที — Phase 2
- Mobile: **[v1.1]** APK เวอร์ชันก่อนหน้าเก็บใน GitHub Releases และติดตั้งทับได้ทันที

---

# 32. KPI / Metrics

## 32.1 North Star Metric

**“Weekly Sustained Focus Minutes”** — จำนวนนาทีรวมของ focus session ที่ผู้ใช้ทำสำเร็จ (ไม่ใช่แค่เริ่ม) ต่อสัปดาห์ ต่อผู้ใช้ที่ active — สะท้อนคุณค่าหลักของผลิตภัณฑ์ (การโฟกัสที่ยั่งยืน) ตรงที่สุด

## 32.2 Metric Framework (HEART-inspired)

| มิติ | Metric | เป้าหมายเชิงทิศทาง |
| --- | --- | --- |
| Happiness | Post-session satisfaction score (1-5) | เฉลี่ย ≥4.0 |
| Engagement | Sessions/สัปดาห์ต่อ active user | เพิ่มขึ้นต่อเนื่อง 8 สัปดาห์แรก |
| Adoption | % ผู้ใช้ใหม่ที่ทำ session แรกสำเร็จภายใน 24 ชม. | ≥60% |
| Retention | D1 / D7 / D30 retention | D7 ≥35%, D30 ≥15% (benchmark อุตสาหกรรม wellbeing app) — **[v1.1]** ใช้เป็นเป้าหมายหลังมี beta |
| Task Success | **[v1.1]** % การเตือนที่ผู้ใช้กลับไปโฟกัส (warning return rate) | ≥40% (proposed) |

## 32.3 Business/Health Metrics เพิ่มเติม

- Distraction event reduction rate (เทียบ baseline สัปดาห์แรกของผู้ใช้แต่ละคน)
- **[v1.1]** Watch list activation rate (% ผู้ใช้ที่เลือกแอปอย่างน้อย 1 แอปใน onboarding)
- Streak median length
- Crash-free session rate (เป้าหมาย ≥99.5%)
- Sync success rate / conflict rate — Phase 2
- **[v1.1]** Detection uptime (% ของวันที่ AccessibilityService เชื่อมต่ออยู่)

---

# 33. Analytics Events

## 33.1 Event Taxonomy (ตัวอย่างหลัก)

```
onboarding_started
onboarding_step_completed        { step_key }
onboarding_completed             { assessment_summary }

focus_session_started            { planned_duration_sec, intention_length }
focus_session_paused             { elapsed_sec }
focus_session_aborted            { elapsed_sec, reason }
focus_session_completed          { actual_duration_sec, completion_pct }
reflection_submitted             { mood_tag, session_id }

friction_gate_shown              { app_package_id, friction_level }
friction_gate_resolved           { action: returned|opened_anyway }
app_opened_warning_shown         { app_package_id, count_today }      [v1.1]

vault_invite_sent                                                       [v1.1]
vault_invite_accepted                                                   [v1.1]
vault_override_requested         { app_package_id, has_reason }        [v1.1]
vault_override_resolved          { outcome: approved|denied|auto_released, resolution_time_sec } [v1.1]
vault_partnership_revoked                                               [v1.1]

streak_incremented               { streak_count }
streak_broken                    { previous_streak }

emergency_pause_used             { monthly_count_so_far }              [v1.1 ชื่อเปลี่ยนจาก emergency_override_used]

ai_coach_message_sent
ai_coach_insight_shown           { insight_type }

app_backgrounded
app_foregrounded
sync_completed                   { records_pushed, records_pulled, conflicts }   [Phase 2]
```

## 33.2 หลักการ

- ทุก event ยึด naming convention noun_verb_past-tense เพื่อ query ง่ายและสม่ำเสมอ
- ไม่เก็บ PII ใน event property (ใช้ user_id แบบ hashed เชื่อมกับ profile แยกต่างหาก)
- Event หมวด behavioral (friction, vault, streak) ต้องมี timestamp ระดับ millisecond เพื่อวิเคราะห์ latency ของ decision moment ได้แม่นยำ
- **[v1.1] MVP ไม่ส่ง event ออกนอกเครื่อง** — บันทึกในตาราง `distraction_events` / `focus_sessions` และคำนวณ KPI ในเครื่อง

---

# 34. Monetization Strategy

## 34.1 สถานะปัจจุบัน — ฟรีทั้งหมด (No Monetization ใน MVP)

ตามที่กำหนดขอบเขต เวอร์ชัน 1.0 **ไม่มีแผนสร้างรายได้** ทุกฟีเจอร์เปิดให้ใช้งานฟรีทั้งหมด เพื่อมุ่งเน้นการพิสูจน์คุณค่าผลิตภัณฑ์ (product-market fit) และสร้างฐานผู้ใช้ที่มีพฤติกรรมเปลี่ยนแปลงจริงก่อน

## 34.2 ผลกระทบต่อสถาปัตยกรรม

แม้ไม่มี monetization ในตอนนี้ แต่ระบบควรออกแบบ **ไม่ปิดกั้นทางเลือกในอนาคต** โดย:
- Database schema ของ users ควรเผื่อ field เช่น tier (default free เพียงค่าเดียวตอนนี้) ไว้เพื่อไม่ต้อง migrate ใหญ่ภายหลัง (Phase 2)
- ไม่ hard-code สมมติฐาน “ไม่มีการชำระเงิน” ลึกเข้าไปใน business logic ของ core feature (เช่น friction/vault) เพื่อให้ปรับเป็น freemium ได้ในอนาคตโดยไม่ต้อง rewrite

## 34.3 ตัวเลือกในอนาคต (สำหรับพิจารณาเมื่อถึงเวลา — ไม่ใช่แผนที่ตัดสินใจแล้ว)

| โมเดล | ข้อดี | ข้อควรระวัง |
| --- | --- | --- |
| Freemium (ฟีเจอร์ขั้นสูง เช่น AI Coach เชิงลึก, analytics ประวัติยาว) | รายได้ต่อเนื่อง, ยังคง core value ฟรี | ต้องระวังไม่ทำให้ friction/safety feature กลายเป็นของมีเงื่อนไขทางการเงิน (จะขัดกับ product philosophy) |
| One-time purchase (unlock full) | เข้าใจง่าย ไม่ subscription fatigue | รายได้ไม่ต่อเนื่อง ยากต่อการ fund การพัฒนาต่อ |
| B2B2C (ผ่านองค์กร/มหาวิทยาลัย) | Ticket size ใหญ่กว่า | ต้องสร้าง enterprise mode ใหม่ (นอกขอบเขต v1.0) |

**ข้อควรระวังสำคัญ:** ฟีเจอร์ safety-critical อย่าง Emergency Pause และ Vault Partner ควรคงความฟรี/เข้าถึงได้เสมอแม้ในอนาคตจะมี paywall ในส่วนอื่น เพื่อรักษาความน่าเชื่อถือด้าน ethics ของผลิตภัณฑ์

---

# 35. Growth Strategy

## 35.1 ช่วงแรก (Pre-launch → Closed Beta)

- สร้าง waitlist ผ่าน landing page เรียบง่าย เน้นสื่อสาร behavioral science angle (ไม่ใช่แค่ “แอปบล็อกมือถือ”) **[v1.1]** — “แอปเตือนและช่วยหยุดคิด”
- ร่วมมือกับ content creator/นักจิตวิทยาที่พูดเรื่อง digital wellbeing เพื่อสร้างความน่าเชื่อถือ
- Closed beta กับกลุ่มเป้าหมายเฉพาะ (นักศึกษา/developer community) เพื่อเก็บ feedback เชิงลึก

## 35.2 หลัง Public Launch

- **Referral loop ผ่าน Vault Partner (v1.1):** การเชิญ Partner เป็นกลไก growth โดยธรรมชาติ (invite-to-use)
- Content marketing: บทความ/สื่อเกี่ยวกับ dopamine science, focus technique — SEO + shareability
- Community: พื้นที่ (เช่น Discord/กลุ่มปิด) สำหรับผู้ใช้แลกเปลี่ยนเทคนิค เพิ่ม retention ผ่าน social proof
- App Store Optimization (ASO): keyword เน้น “focus”, “dopamine detox”, “screen time”, คู่กับ review ที่ดีจาก beta users

## 35.3 Metrics ที่ใช้วัด Growth

- Viral coefficient จาก Vault Partner invite (v1.1)
- Organic vs referral install ratio
- Cost-free acquisition channel effectiveness (content, ASO)

---

# 36. MVP → V1 → V2 → Long-term Roadmap

## 36.1 MVP (เป้าหมาย: พิสูจน์ core loop ทำงานได้จริง)

**[v1.1] ปรับรายการตาม scope ใหม่:**

- Onboarding 6 ขั้นตอนตาม prototype (Welcome, Triggers, Goal, Apps, Friction, Permissions)
- ~~Authentication (email + Google/Apple)~~ → **[v1.1]** ไม่มีบัญชีใน MVP ข้อมูลอยู่ในเครื่อง
- Focus Session (timer, intention, pause 3/วัน, exit gate, summary)
- Detection (Android AccessibilityService, iOS Shortcuts demo) + การเตือนเมื่อเปิดแอปที่เลือก
- Distraction Logging
- Streak (non-punishing) + Streak Recovery
- Friction L0–L3 (การเตือนและ reflective pause; ไม่บล็อก) — **[v1.1]** L4 เลื่อน
- Emergency Pause (หยุดการเตือนชั่วคราว)
- Analytics พื้นฐาน (streak, focus, attempts, timeline, DLI proxy) + Export CSV/JSON
- AI Coach rule-based
- Settings ตาม prototype (appearance, interventions, notifications, privacy)
- Offline-first สำหรับฟีเจอร์ทั้งหมดข้างต้น

## 36.2 V1 (Public Launch) — **[v1.1] เลื่อนไป v1.1**

- Vault Partner System เต็มรูปแบบ (invite, override request, approval, audit log)
- Friction L4
- Emergency แจ้ง Partner
- AI Coach แบบ conversational เบื้องต้น (ถ้ามี LLM)
- Notification architecture เต็มรูปแบบ (quiet hours บังคับใช้)
- Analytics dashboard เต็มรูปแบบ (usage time ต่อแอป, Dopamine Load Index สูตรเต็ม)
- Export PDF / PNG / Markdown

## 36.3 V2

- AI Coach แบบ conversational เต็มรูปแบบ (LLM)
- Personalization ขั้นสูง (adaptive friction ที่เรียนรู้จาก pattern จริง)
- Multi-partner support (approval rule แบบ any/all)
- Sync และ backend (Phase 2)
- Export/Report ขั้นสูง
- Localization เพิ่มภาษา

## 36.4 Long-term

- Web Dashboard (ดูหมวด 38)
- Integrations (calendar, task manager เช่น Notion/Todoist เพื่อผูก focus session กับงานจริง)
- Enterprise/Team mode (สำหรับองค์กร/มหาวิทยาลัย)
- Wearable integration (Apple Watch/Wear OS สำหรับเริ่ม session และดู streak)
- **[v1.1]** พิจารณาการบล็อกแอปจริงใหม่เมื่อมีงบประมาณและสิทธิ์ที่จำเป็น (Apple entitlement, Play policy) — ดูหมวด 39
- พิจารณา monetization model (ดูหมวด 34.3)

---

# 37. Development Timeline

Timeline เป็นแผนระดับ indicative โดยประมาณ สำหรับทีมขนาดเล็ก (**[v1.1]** ปัจจุบันเป็นผู้พัฒนาหลักคนเดียวในโครงงาน ตามตารางนี้ควรขยายเวลาหรือตัด scope ตามหมวด 36.1) — ควรปรับตามขนาดทีมจริงเมื่อ kick off

| ระยะ | ระยะเวลา (สัปดาห์) | เนื้อหาหลัก |
| --- | --- | --- |
| Research & UX | 1-4 | User research, persona validation, wireframe, design system (**[v1.1]** ใช้ prototype เป็นฐาน) |
| Architecture Setup | 3-5 (คาบเกี่ยวกับ UX) | Project setup, CI/CD skeleton (GitHub Actions), DB schema (local) |
| MVP Development | 6-14 | Onboarding, Focus Session, Detection (Android + iOS demo), Friction L0–L3, Streak, Analytics พื้นฐาน, Offline-first |
| Internal QA & Polish | 15-16 | Bug fix, performance, accessibility audit, visual parity กับ prototype |
| Closed Beta | 17-20 | จำกัดผู้ใช้ 10–30 คน (**[v1.1]** ปรับจาก 100-300), เก็บ feedback, iterate |
| V1 Development | 21-28 | ตามหมวด 36.2 (**[v1.1]** Vault Partner, L4, Export PDF) |
| Public Launch Prep | 29-30 | (**[v1.1]** เลื่อนไป Phase 2 จนกว่าจะมี developer account) |
| **Public Launch** | สัปดาห์ 31 | — |
| V2 iterations | 32+ | ตาม roadmap หมวด 36.3 แบบ continuous |

---

# 38. Future Web Platform Strategy

## 38.1 เหตุผลที่ไม่ทำเว็บใน v1.0

Core value ของผลิตภัณฑ์ (การตรวจจับและการเตือนระหว่างใช้มือถือ) ผูกกับ mobile OS โดยธรรมชาติ — เว็บแพลตฟอร์มไม่ได้เพิ่มคุณค่าหลักในช่วงแรก และจะเพิ่ม scope/ความซับซ้อนโดยไม่จำเป็นต่อการพิสูจน์ product-market fit

## 38.2 บทบาทของเว็บในอนาคต

เว็บจะไม่ใช่ “แอปคู่ขนาน” เต็มรูปแบบ แต่เป็น **Companion Dashboard** เน้น:
- การดูข้อมูล analytics เชิงลึกที่หน้าจอใหญ่กว่าเหมาะกว่า (กราฟ, trend ยาว)
- การจัดการ Vault Partner สำหรับผู้ที่สะดวกทำงานผ่านคอมพิวเตอร์ (v1.1+)
- Export/report สำหรับใช้งานร่วมกับเครื่องมืออื่น (เช่น แนบรายงานความคืบหน้าส่งโค้ช/therapist)
- Landing page + marketing site (แยกจาก dashboard)

## 38.3 แนวทางเทคนิคที่แนะนำเมื่อถึงเวลา

- ใช้ **Next.js** (React) เพื่อ reuse ทีม frontend/TypeScript ที่คุ้นเคยจาก backend NestJS อยู่แล้ว
- Reuse packages/api-contracts เดิมจาก monorepo (หมวด 28) เพื่อไม่ต้องเขียน API client ใหม่
- ไม่ทำ real-time app blocking ผ่านเว็บ (เป็นไปไม่ได้ทางเทคนิคใน browser sandbox) — เว็บทำหน้าที่เป็น read/manage layer เท่านั้น ไม่ใช่ enforcement layer

---

# 39. [v1.1] ข้อจำกัดด้านงบประมาณและแพลตฟอร์ม (เพิ่มใหม่)

> หมวดนี้เพิ่มในฉบับ v1.1 และเป็นเหตุผลของการเปลี่ยนแปลงในหมวด 0 ทั้งฉบับ

## 39.1 ข้อจำกัด

| ข้อจำกัด | รายละเอียด | ผลต่อผลิตภัณฑ์ |
| --- | --- | --- |
| Apple Developer Program | ค่าสมาชิกประจำปีเป็นค่าใช้จ่ายที่ไม่อยู่ในงบ | ไม่มี FamilyControls/Screen Time API → ไม่สามารถบล็อกแอปบน iOS ได้ ใช้ Shortcuts + การเตือนแทน |
| macOS ส่วนตัว | ไม่มีเครื่อง Mac | iOS build ผ่าน Codemagic, ไม่มี Xcode ในเครื่องโดยตรง |
| Cloud/backend | งบจำกัด | MVP เป็น local-first ทั้งหมด |
| ค่าบริการ AI | ค่า API ต่อการสนทนา | AI Coach เป็น rule-based ใน MVP |
| บริการ push/sync/auth | ค่าใช้จ่ายต่อผู้ใช้ | ใช้ local notification ไม่มี sync และไม่มีบัญชีใน MVP |

## 39.2 สิ่งที่เปลี่ยนจากการบล็อกเป็นการเตือน

| ด้าน | การบล็อก (v1.0) | การเตือน (v1.1) |
| --- | --- | --- |
| ผลต่อการเปิดแอป | ไม่สามารถเปิดได้ก่อนผ่านเงื่อนไข | เปิดได้เสมอ การเตือนและ reflective pause เป็นการเลือกของผู้ใช้ |
| สิทธิ์ที่ต้องการ | Device Admin / FamilyControls / Accessibility (ควบคุม) | Accessibility (ดูชื่อแอป) / Notifications / Shortcuts |
| การทดสอบ iOS | ทำไม่ได้ใน scope นี้ | ทำได้ด้วย Shortcuts (demo) |
| ความแรงของผลลัพธ์ | สูงตามกลไก | ขึ้นกับการตอบสนองของผู้ใช้ |
| ข้อความที่ใช้ | “บล็อก”, “ปลดบล็อก” | “เตือน”, “หยุดการเตือน” |
| จุดแข็ง | ควบคุมได้จริง | ไม่ล็อกชีวิตจริง, เคารพ autonomy, ทำได้ตามงบ |

## 39.3 สิ่งที่คงไว้จาก v1.0

- Focus Session, Intention, Pause limit, Exit gate
- Streak แบบ non-punishing และ Recovery
- Reflection และการเข้ารหัสข้อมูลอ่อนไหว
- Insights, AI Coach (rule-based), Export
- Friction levels L0–L4 ในฐานะการออกแบบระดับการเตือน (L4 เลื่อน)

## 39.4 สิ่งที่ยกเลิก/เลื่อน

- การบล็อกแอปจริงทุกรูปแบบ (ทั้ง Android และ iOS)
- Vault Partner, L4, Partner approval, Override request
- Backend, sync, Firebase Auth, FCM, Redis, PostgreSQL
- Export PDF / PNG / Markdown
- Usage time ต่อแอป (ต้องการ Usage Access)
- Fastlane Match, TestFlight, App Store phased rollout

## 39.5 การตัดสินใจที่ต้องยืนยัน (Open decisions)

1. ยอมรับการปรับตัวอักษรที่ไม่ผ่าน contrast ของ prototype (หมวด 12.2.2) หรือคงค่าเดิม
2. ค่า Emergency window (15 นาที) และ Dedup (30 วินาที) ตามที่เสนอ
3. Package id ของ LINE, Shopee, Lazada ตรวจสอบกับ Play Store ก่อนใช้งาน
4. Dopamine Load Index (proxy = จำนวนครั้งที่เปิด) ยอมรับสำหรับ MVP หรือไม่
5. ชั่วโมงเงียบใน MVP แสดงเท่านั้นหรือปิดการตั้งค่าไปก่อน

---

# ภาคผนวก A — [v1.1] Prototype Screen Mapping และ Copy

## A.1 หน้าจอตาม Prototype และสถานะ

| หน้าจอ (Prototype) | ไฟล์ใน prototype | สถานะ v1.1 |
| --- | --- | --- |
| Onboarding (6 ขั้น) | `screens/Onboarding.tsx` | MVP |
| Focus (home / setup / active / summary / streak recovery) | `screens/FocusScreen.tsx` | MVP |
| Friction L0–L4, Exit gate, Pause limit, Emergency, Success toast | `components/FrictionGate.tsx` | MVP (L0–L3), L4 เลื่อน |
| Duration picker | `components/DurationPicker.tsx` | MVP |
| Insights | `screens/InsightsScreen.tsx` | MVP (ยกเว้น usage time) |
| AI Coach | `screens/AICoachScreen.tsx` | MVP (rule-based) |
| Vault | `screens/VaultScreen.tsx` | v1.1 |
| Settings (รวม modal) | `screens/SettingsScreen.tsx` | MVP และ v1.1 |
| Export flow | `components/ExportFlow.tsx` | MVP (CSV/JSON) |
| Bottom navigation | `components/BottomNav.tsx` | MVP |

## A.2 Copy ที่เปลี่ยนจาก Prototype

| Prototype | v1.1 |
| --- | --- |
| “บล็อก” / “บล็อกในช่วง Focus” | “เตือน” / “เตือนในช่วง Focus” |
| “ปลดบล็อกแล้ว” (Emergency toast) | “หยุดการเตือนแล้ว 15 นาที” |
| “Partner จะได้รับแจ้ง” | ซ่อนใน MVP |
| “Usage Access” (Onboarding) | “Accessibility Service” |
| Insights table column “บล็อก” | “เตือน” |
| Timeline “TikTok ถูกบล็อก” | “ได้รับการเตือน TikTok (L2)” |
| Export “JSON: แอปบล็อก, partner” | “JSON: การตั้งค่า, แอปที่ระวัง” |
| “Online · ข้อมูลของคุณอยู่แค่ใน Homeo” | “ประมวลผลในเครื่อง · ข้อมูลอยู่แค่ใน Homeo” |
| “ลบบัญชี” / “ออกจากระบบ” | “ลบข้อมูลทั้งหมดในเครื่อง” |
| Deep link `dopaminefocus://` | `homeo://` |

## A.3 แอปที่เลือกได้ตาม Prototype (8 รายการ)

Instagram · TikTok · YouTube · X / Twitter · Facebook · LINE · Shopee · Lazada

> **[v1.1] หมายเหตุ:** โค้ดปัจจุบัน (`app_catalog.dart`) มี Reddit และยังไม่มี LINE, Shopee, Lazada ต้องปรับให้ตรงกับ prototype และตรวจสอบ package id ก่อนใช้งาน

---

*จบเอกสาร PRD เวอร์ชัน 1.0 (ปรับปรุงเป็น v1.1 ด้วยข้อมูล [v1.1] ตามที่ระบุ) — เอกสารนี้เป็น living document ควรทบทวนและอัปเดตทุกสิ้น sprint/phase สำคัญ ร่วมกับทีม Product, Design, Engineering*