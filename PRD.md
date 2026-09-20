Product Requirements Document (PRD)
 
แอปพลิเคชันลดการเสพติด Dopamine และเสริมสร้าง Focus (Homeo)
 
Product & Engineering Team
 
เวอร์ชัน 1.0 — กรกฎาคม 2026
 
Table of Contents
 
# 1. Executive Summary
 
**Homeo** คือแอปพลิเคชันมือถือแบบ cross-platform (Flutter, iOS + Android) ที่ออกแบบมาเพื่อช่วยให้ผู้ใช้ลดพฤติกรรมเสพติดสิ่งเร้าที่ให้ dopamine แบบฉับพลัน (short-form video, social feed, เกมมือถือ, notification loop) และสร้างความสามารถในการโฟกัสอย่างยั่งยืนขึ้นมาใหม่ ผ่านกลไก behavioral design ที่มีหลักฐานทางวิทยาศาสตร์รองรับ (evidence-informed), ระบบเพื่อนช่วยรับผิดชอบ (Vault Partner), การสร้างแรงเสียดทานเชิงกลยุทธ์ (intentional friction), การสะท้อนตนเอง (reflection), และการวิเคราะห์ข้อมูลพฤติกรรม (analytics)
 
โปรเจกต์นี้เริ่มต้นจาก MVP มือถือเป็นหลัก (mobile-first) โดยไม่มีเว็บแพลตฟอร์มในระยะแรก และไม่มีแผนสร้างรายได้ (monetization) ในช่วงเริ่มต้น — เป้าหมายหลักคือการพิสูจน์คุณค่าของผลิตภัณฑ์ (product-value validation) และสร้างฐานผู้ใช้ที่มีพฤติกรรมเปลี่ยนแปลงจริง (behavior change) ก่อนพิจารณาโมเดลรายได้ในอนาคต
 
เอกสารฉบับนี้เป็น PRD แบบครบวงจร ครอบคลุมตั้งแต่กลยุทธ์ผลิตภัณฑ์ งานวิจัยเชิงพฤติกรรมศาสตร์ การวิเคราะห์คู่แข่ง สถาปัตยกรรมระบบ ฐานข้อมูล API ความปลอดภัย ไปจนถึงแผนการพัฒนาและ roadmap ระยะยาว เพื่อใช้เป็นเอกสารอ้างอิงหลักสำหรับทีมวิศวกรรมที่จะสร้างผลิตภัณฑ์นี้จริง
 
**สิ่งที่ไม่ได้อยู่ในขอบเขต (Out of Scope) ของเวอร์ชัน 1.0:** - เว็บแพลตฟอร์ม (จะกล่าวถึงเป็น future strategy เท่านั้น) - โมเดลรายได้/การชำระเงิน (ไม่มีแผนตอนนี้ ทุก feature เปิดให้ใช้ฟรี) - Enterprise/Team mode
 
# 2. Vision / Mission / Product Philosophy
 
## 2.1 Vision
 
“ช่วยให้ทุกคนสามารถควบคุมความสนใจของตัวเองคืนมาได้ ไม่ใช่ด้วยการห้ามเทคโนโลยี แต่ด้วยการออกแบบสภาพแวดล้อมที่สนับสนุนเจตจำนงที่แท้จริงของผู้ใช้”
 
เราเชื่อว่าปัญหาไม่ได้อยู่ที่ “เทคโนโลยีเป็นสิ่งไม่ดี” แต่อยู่ที่ระบบสิ่งเร้าจำนวนมากถูกออกแบบมาให้ใช้ประโยชน์จากกลไก dopamine ของสมองมนุษย์เพื่อดึงความสนใจให้นานที่สุดโดยไม่คำนึงถึงสวัสดิภาพผู้ใช้ (attention economy) เป้าหมายของเราคือสร้างเครื่องมือที่ “เอียงสนามแข่ง” กลับมาให้ผู้ใช้ได้เปรียบอีกครั้ง
 
## 2.2 Mission
 
สร้างระบบ behavioral infrastructure ที่ช่วยให้ผู้ใช้: 1. ตระหนักรู้พฤติกรรมของตนเอง (self-awareness) ผ่านการติดตามและสะท้อนผล 2. ลดแรงกระตุ้นจาก cheap dopamine ด้วยแรงเสียดทานที่ออกแบบมาอย่างมีเหตุผล 3. สร้างนิสัยการโฟกัสที่ยั่งยืนผ่านการทำซ้ำ การเสริมแรงเชิงบวก และอัตลักษณ์ตนเอง (identity-based habits) 4. ได้รับการสนับสนุนทางสังคมผ่านระบบ accountability partner แบบที่เคารพความเป็นส่วนตัว
 
## 2.3 Product Philosophy
 
| หลักการ | ความหมาย |
| --- | --- |
| **Friction, not prohibition** | เราไม่บล็อกแบบเบ็ดเสร็จ แต่เพิ่มแรงเสียดทานที่เหมาะสมเพื่อให้ผู้ใช้ “หยุดคิด” ก่อนกระทำ |
| **Layered control, not absolute control** | ผู้ใช้ยังคงมี autonomy สูงสุด ระบบไม่ล็อกจนใช้งานไม่ได้ในกรณีฉุกเฉิน |
| **Progress over perfection** | เน้นความสม่ำเสมอระยะยาวมากกว่าความสมบูรณ์แบบระยะสั้น (ไม่ลงโทษเมื่อ streak ขาด) |
| **Transparency by design** | ผู้ใช้ (และ Vault Partner) ต้องเข้าใจว่าเหตุใดระบบจึงทำงานแบบนั้นเสมอ ไม่มี dark pattern |
| **Privacy-first accountability** | การแชร์ข้อมูลกับ Vault Partner ต้องเป็นไปโดยสมัครใจ ควบคุมได้ และย้อนกลับได้ |
| **Evidence-informed, not gimmick-driven** | ทุกกลไกพฤติกรรมต้องอ้างอิงงานวิจัยที่ตรวจสอบได้ |
 
# 3. Scientific Research & Behavioral Science
 
การออกแบบผลิตภัณฑ์นี้อ้างอิงกรอบแนวคิดและงานวิจัยด้านจิตวิทยาพฤติกรรมและประสาทวิทยาศาสตร์ ดังนี้
 
## 3.1 กลไกทางประสาทวิทยาของ Dopamine
 
Dopamine ไม่ใช่ “สารแห่งความสุข” โดยตรง แต่เป็นสารสื่อประสาทที่เกี่ยวข้องกับ **การคาดการณ์รางวัล (reward prediction)** และแรงจูงใจในการแสวงหา (wanting) มากกว่าความพึงพอใจ (liking) งานของ Wolfram Schultz เกี่ยวกับ reward prediction error อธิบายว่าสมองปล่อย dopamine สูงสุดเมื่อรางวัลนั้น “คาดเดาไม่ได้” (variable/unpredictable) ซึ่งเป็นหลักการเดียวกับที่ระบบ social media feed, short-form video และเกมมือถือใช้ในการออกแบบ infinite scroll และ notification
 
จิตแพทย์ Anna Lembke (Stanford, ผู้เขียน *Dopamine Nation*) เสนอแนวคิด “dopamine balance” ว่าสมองพยายามรักษาสมดุลระหว่างความสุขและความเจ็บปวด (pleasure-pain balance) การเสพสิ่งเร้าที่ให้ dopamine สูงซ้ำ ๆ ทำให้เกิด tolerance และ “dopamine deficit state” ซึ่งลดความสามารถในการรู้สึกพอใจกับกิจกรรมที่ให้ dopamine ต่ำแต่ยั่งยืน (เช่น งานที่ต้องใช้สมาธิลึก) แนวคิด “dopamine fasting/detox” ที่เธอเสนอเป็นพื้นฐานของฟีเจอร์ friction และ recovery mode ในแอปนี้
 
## 3.2 Habit Loop และ Behavior Change Models
 
- **Habit Loop (Charles Duhigg / BJ Fogg):** ประกอบด้วย Cue → Routine → Reward การเปลี่ยนนิสัยที่ยั่งยืนต้องแทรกแซงที่ cue หรือเปลี่ยน routine ไม่ใช่พึ่งพา willpower เพียงอย่างเดียว
 
- **Fogg Behavior Model (B=MAP):** พฤติกรรมจะเกิดขึ้นเมื่อ Motivation, Ability และ Prompt มาบรรจบกันพร้อมกัน ฟีเจอร์ friction ของเราลด “Ability” ในการทำพฤติกรรมที่ไม่พึงประสงค์ ขณะที่ระบบ nudge เพิ่ม prompt ให้กับพฤติกรรมที่พึงประสงค์
 
- **Implementation Intentions (Peter Gollwitzer):** การตั้งเป้าหมายแบบ “if-then” (ถ้าเกิด X ฉันจะทำ Y) เพิ่มโอกาสสำเร็จของเป้าหมายอย่างมีนัยสำคัญ นำมาใช้ในฟีเจอร์ตั้งเป้า focus session
 
- **Temptation Bundling (Katy Milkman):** การผูกกิจกรรมที่อยากทำเข้ากับกิจกรรมที่ควรทำ ใช้เป็นแนวคิดในฟีเจอร์ reward pairing
 
- **Self-Determination Theory (Deci ****&**** Ryan):** แรงจูงใจภายใน (intrinsic motivation) ยั่งยืนกว่าแรงจูงใจภายนอก ต้องอาศัย 3 องค์ประกอบ: Autonomy, Competence, Relatedness — เป็นหลักการที่กำกับการออกแบบ gamification ไม่ให้กลายเป็นการควบคุมจากภายนอกมากเกินไป
 
- **Identity-Based Habits (James Clear,**** *****Atomic Habits*****):** นิสัยที่ยั่งยืนเกิดจากการเปลี่ยนความเชื่อเกี่ยวกับตัวตน (“ฉันเป็นคนที่โฟกัสได้”) มากกว่าผลลัพธ์ระยะสั้น ใช้ในการออกแบบข้อความ reflection และ progress narrative
 
## 3.3 Friction และ Commitment Devices
 
งานวิจัยด้าน behavioral economics (Thaler & Sunstein, *Nudge*) แสดงให้เห็นว่าการเพิ่ม “แรงเสียดทานเล็กน้อยแต่มีความหมาย” (small meaningful friction) สามารถลดพฤติกรรมอัตโนมัติ (automatic behavior) ได้อย่างมีประสิทธิภาพโดยไม่ลดทอน autonomy ของผู้ใช้ ตรงข้ามกับหนังสือ *Hooked* ของ Nir Eyal ที่อธิบายว่าผลิตภัณฑ์เสพติดใช้ variable reward และลด friction ให้เหลือน้อยที่สุด — แอปนี้ทำสิ่งตรงข้ามโดยเจตนา (Anti-Hooked design)
 
**Commitment devices** เช่นระบบ Vault Partner อ้างอิงงานวิจัยของ Dean Karlan และ John Beshears เกี่ยวกับการที่ผู้คนยินยอมผูกมัดตนเองล่วงหน้ากับผลลัพธ์เชิงลบ (self-binding) เพื่อเพิ่มโอกาสบรรลุเป้าหมาย
 
## 3.4 ข้อจำกัดของแนวทาง Digital Detox แบบเดิม
 
Cal Newport (*Digital Minimalism*) ชี้ว่าการเลิกใช้แบบเบ็ดเสร็จ (cold turkey) มักล้มเหลวในระยะยาว เพราะไม่ได้แก้ที่รากของปัญหาคือการขาดกิจกรรมทดแทนที่มีความหมาย (high-value replacement activities) แอปนี้จึงออกแบบ reflection และ focus session ให้เชื่อมโยงกับเป้าหมายที่มีความหมายของผู้ใช้ ไม่ใช่แค่ “บล็อกแอป”
 
## 3.5 หลักการที่นำมาปรับใช้ในผลิตภัณฑ์ (สรุป)
 
| งานวิจัย/ทฤษฎี | นำไปใช้ในฟีเจอร์ |
| --- | --- |
| Reward Prediction Error | Friction gate ก่อนเปิดแอปกลุ่มเสี่ยง |
| Fogg Behavior Model | Prompt/nudge ที่จับจังหวะ high-motivation moment |
| Implementation Intentions | Focus session planning (“if-then” goal setting) |
| Identity-Based Habits | Reflection journal, progress narrative |
| Commitment Devices | Vault Partner, recovery delay |
| Self-Determination Theory | Gamification ที่เน้น mastery ไม่ใช่ external reward เพียงอย่างเดียว |
| Pleasure-Pain Balance | Analytics แสดง “dopamine load” และช่วงพักฟื้น |
 
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
| **Opal** | UI สวย, บล็อกแอปมีประสิทธิภาพ, มี “Deep Focus” mode | ไม่มีระบบ accountability partner ที่แท้จริง, friction ตายตัวไม่ปรับตาม context | เพิ่ม friction แบบ adaptive + Vault Partner ที่มีมนุษย์จริงร่วมตัดสินใจ |
| **Forest** | Gamification สนุก, กลไกปลูกต้นไม้จูงใจดี | ไม่มี behavioral science เชิงลึก, ไม่มี reflection/analytics เชิงพฤติกรรม | ผสาน gamification เข้ากับ data-driven insight และ CBT-style reflection |
| **Freedom** | บล็อกข้าม device ได้ (cross-device sync) | UX ล้าสมัย, ไม่มี social accountability, ตั้งค่าซับซ้อน | Vault Partner + friction ที่ตอบสนอง real-time พร้อม UX ทันสมัย |
| **One Sec** | Friction ก่อนเปิดแอป (breathing pause) มีประสิทธิภาพสูง | ฟีเจอร์จำกัดเฉพาะ friction เดียว ไม่มี ecosystem ของ habit-building | ขยาย friction เป็น framework หลายระดับ + ผูกกับเป้าหมายระยะยาว |
| **iOS/Android native Screen Time** | ติดตั้งมาแล้ว ฟรี | Friction ต่ำมาก (ปิดง่าย), ไม่มี social accountability, analytics ตื้น | ความลึกของ behavioral design และ accountability ที่ native ทำไม่ได้ |
 
## 4.3 Positioning
 
“แอปเดียวที่รวม Friction Science + Human Accountability + Behavioral Analytics เข้าด้วยกัน แทนที่จะเป็นแค่ตัวบล็อกแอปหรือเกมจับเวลา”
 
**Differentiators หลัก:** 1. Vault Partner — ระบบ accountability ที่มีมนุษย์จริงเป็นผู้ตรวจสอบ ไม่ใช่แค่ AI/algorithm 2. Friction-based Intervention Framework ที่ปรับระดับตาม context (adaptive friction) 3. รากฐานทางวิทยาศาสตร์พฤติกรรมที่อธิบายได้และตรวจสอบได้ ไม่ใช่ gimmick 4. Layered control philosophy — ไม่ล็อกผู้ใช้แบบเบ็ดเสร็จ เคารพ autonomy
 
## 4.4 Risks ทางการตลาด
 
- ตลาดมีผู้เล่นที่ established แล้ว (switching cost ของผู้ใช้)
 
- Digital wellbeing เป็น “vitamin” ไม่ใช่ “painkiller” โดยธรรมชาติ — ต้องอาศัย onboarding ที่ดีเพื่อสร้าง perceived value ตั้งแต่แรก
 
- ฟีเจอร์ friction คล้ายกับคู่แข่งได้ง่าย (low technical moat) — moat ที่แท้จริงคือคุณภาพของ behavioral design และ community/accountability network effect
 
# 5. User Personas
 
## 5.1 Persona A — “น้องปูน” นักศึกษาปี 3 (Student, อายุ 20)
 
- **บริบท:** เรียนวิศวกรรม ต้องอ่านหนังสือสอบแต่เปิด TikTok/Instagram ทุก 5-10 นาทีระหว่างอ่าน
 
- **Pain Points:** เสียเวลาไปกับ short-form video หลายชั่วโมงต่อวัน, รู้สึกผิดหลังเล่นนาน, สอบตกเพราะเวลาไม่พอ
 
- **เป้าหมาย:** อยากอ่านหนังสือได้ต่อเนื่อง 45-90 นาทีโดยไม่หยิบมือถือ
 
- **แรงจูงใจ:** กลัวสอบตก, อยากพิสูจน์ตัวเองกับครอบครัว
 
- **ความสัมพันธ์กับ Vault Partner:** ให้เพื่อนสนิทหรือรุ่นพี่เป็น Vault Partner
 
## 5.2 Persona B — “พี่เอก” Senior Developer (อายุ 29)
 
- **บริบท:** ทำงาน remote ต้องเขียนโค้ดแบบ deep work แต่ context-switch ไป Twitter/X, HackerNews, Slack บ่อย
 
- **Pain Points:** เสีย flow state บ่อย, productivity ต่ำกว่าที่ควร, รู้สึกเหนื่อยล้าทางสมองแม้ทำงานไม่มาก (dopamine fatigue)
 
- **เป้าหมาย:** สร้าง deep work block 2-3 ชั่วโมงต่อวันแบบไม่ขาดตอน
 
- **แรงจูงใจ:** ต้องการ career growth, ไม่อยากให้ทีมรอ
 
- **ความสัมพันธ์กับ Vault Partner:** ให้คู่ชีวิตหรือเพื่อนร่วมทีมเป็น partner แบบ mutual accountability
 
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
 
# 6. Jobs To Be Done (JTBD)
 
| # | Job Statement | Trigger | Desired Outcome |
| --- | --- | --- | --- |
| JTBD-1 | เมื่อฉันต้องโฟกัสงาน/เรียน ฉันต้องการลดสิ่งรบกวนจากมือถือ เพื่อให้ทำงานเสร็จตามเวลา | เริ่มงานสำคัญ, ใกล้ deadline | Focus session ที่สมบูรณ์โดยไม่ถูกขัดจังหวะ |
| JTBD-2 | เมื่อฉันรู้สึกอยากเปิดแอปโดยไม่มีเหตุผล ฉันต้องการให้มีอะไรมาช่วยหยุดฉันไว้ก่อน เพื่อให้ฉันได้คิดก่อนทำ | มือถือสั่นแจ้งเตือน, ความเบื่อ | ผ่าน friction gate แล้วตัดสินใจอย่างมีสติ |
| JTBD-3 | เมื่อฉันพยายามเปลี่ยนพฤติกรรมคนเดียวไม่สำเร็จ ฉันต้องการให้มีคนช่วยตรวจสอบ เพื่อเพิ่มความรับผิดชอบ | ล้มเหลวซ้ำหลายครั้ง | มี Vault Partner ที่ช่วย approve/deny การขอ override |
| JTBD-4 | เมื่อฉันอยากรู้ว่าพฤติกรรมตัวเองดีขึ้นไหม ฉันต้องการเห็นข้อมูลที่ชัดเจน เพื่อประเมินความก้าวหน้า | สิ้นสัปดาห์/สิ้นเดือน | Dashboard วิเคราะห์แนวโน้มพฤติกรรม |
| JTBD-5 | เมื่อฉันหลุด (relapse) ฉันต้องการพื้นที่ปลอดภัยในการกลับมาโดยไม่รู้สึกผิดจนเลิกใช้แอป | หลัง streak ขาด | Recovery flow ที่ไม่ shaming ตั้งต้นใหม่ได้ง่าย |
| JTBD-6 | เมื่อฉันอยู่ในสถานการณ์ฉุกเฉินจริง ฉันต้องการ override ข้อจำกัดได้ เพื่อไม่ให้ระบบปิดกั้นชีวิตจริง | เหตุฉุกเฉิน, สายด่วนงาน | Emergency override ที่มี safeguard ป้องกันการใช้ผิดวัตถุประสงค์ |
 
# 7. User Journey Maps
 
## 7.1 Journey: First-Time User (Onboarding → First Focus Session)
 
| ขั้นตอน | การกระทำ | ความรู้สึก | Touchpoint | Opportunity |
| --- | --- | --- | --- | --- |
| Discover | เห็นแอปจาก App Store/เพื่อนแนะนำ | สงสัย อยากลองแก้ปัญหา | App Store listing | คำอธิบายที่เน้นวิทยาศาสตร์ ไม่ gimmick |
| Onboarding | ตอบแบบประเมินพฤติกรรม ตั้งเป้าหมาย | อยากรู้ว่าแอปเข้าใจปัญหาตัวเองไหม | Onboarding flow | Assessment ที่ personalize คำแนะนำทันที |
| Setup | เลือกแอปกลุ่มเสี่ยง ตั้งระดับ friction | กังวลเรื่องตั้งค่าซับซ้อน | Setup wizard | Default ที่ฉลาด ปรับทีหลังได้ |
| First Session | เริ่ม focus session แรก | ตื่นเต้น/กังวลว่าจะทำไม่ได้ | Focus timer screen | Micro-encouragement ระหว่าง session |
| Completion | จบ session แรกสำเร็จ | ภูมิใจ | Completion + reflection | Positive reinforcement ชวนตั้ง session ถัดไป |
 
## 7.2 Journey: Vault Partner Invitation
 
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
 
# 8. Information Architecture
 
Homeo
├── Onboarding
│   ├── Welcome / Value Prop
│   ├── Behavioral Assessment
│   ├── Goal Setting
│   ├── App Selection (แอปกลุ่มเสี่ยง)
│   └── Notification Permission
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
├── Vault Partner
│   ├── Partner List
│   ├── Invite Partner
│   ├── Override Request Flow
│   ├── Approval Inbox (สำหรับ Partner)
│   └── Shared Progress View
├── Analytics
│   ├── Weekly/Monthly Trends
│   ├── Distraction Event Log
│   ├── Dopamine Load Index
│   └── Export Data
├── Interventions (Friction)
│   ├── App Block List
│   ├── Friction Level Settings
│   ├── Emergency Override
│   └── Recovery Mode
├── AI Coach
│   ├── Chat Interface
│   ├── Personalized Insights
│   └── Suggested Actions
├── Profile & Settings
│   ├── Account
│   ├── Notification Preferences
│   ├── Privacy & Data
│   ├── Vault Partner Management
│   └── App Permissions (Accessibility, Usage Stats)
└── Support
    ├── FAQ
    ├── Crisis/Wellbeing Resources
    └── Feedback
 
# 9. Complete Feature Specification
 
## 9.1 Focus Session
 
| Spec | รายละเอียด |
| --- | --- |
| Session Types | Timed (25/45/60/90 นาที, custom), Open-ended |
| Intention Setting | ผู้ใช้พิมพ์เป้าหมายของ session ก่อนเริ่ม (implementation intention) |
| App Blocking during Session | บล็อกแอปกลุ่มเสี่ยงที่เลือกไว้ทั้งหมดโดยอัตโนมัติ |
| Interruption Handling | หากออกจาก session ก่อนกำหนด ต้องผ่าน friction gate (เหตุผล + countdown) |
| Pause | อนุญาต pause ได้จำกัดจำนวนครั้ง/วัน เพื่อป้องกันการใช้เป็นช่องโหว่ |
| Completion Reward | animation, streak +1, บันทึกลง analytics |
| Reflection | คำถามสั้นหลังจบ session (“รู้สึกอย่างไร”, “โฟกัสได้กี่เปอร์เซ็นต์”) |
 
## 9.2 Habit Tracking
 
- ติดตามพฤติกรรมเป้าหมาย (เช่น “ไม่เปิด TikTok ก่อนเที่ยง”)
 
- Streak counter แบบ non-punishing (แสดง “best streak” คู่กับ “current streak” ไม่ลบประวัติเมื่อขาด)
 
- Weekly habit review อัตโนมัติทุกวันอาทิตย์
 
## 9.3 Distraction Logging
 
- บันทึกทุกครั้งที่ผู้ใช้พยายามเปิดแอปกลุ่มเสี่ยงระหว่าง friction/block active (ไม่ว่าจะสำเร็จหรือไม่)
 
- แท็ก context (เวลา, สถานที่ถ้าอนุญาต, ก่อนหน้าทำอะไรอยู่)
 
## 9.4 Analytics Dashboard
 
- Dopamine Load Index (ดัชนีคำนวณจากความถี่ + ระยะเวลาของการเสพสิ่งเร้าสูง)
 
- แนวโน้มรายวัน/สัปดาห์/เดือน
 
- เปรียบเทียบช่วงก่อน-หลังใช้แอป
 
- Export เป็น CSV/PDF
 
## 9.5 AI Coach
 
- Chat interface ที่ให้คำแนะนำเชิงพฤติกรรมโดยอ้างอิงข้อมูลการใช้งานจริงของผู้ใช้
 
- Insight เชิงรุก (proactive insight) เช่น “คุณมักหลุดโฟกัสช่วง 14:00-15:00 ลองย้าย deep work มาช่วงเช้าไหม”
 
- ไม่ให้คำแนะนำทางการแพทย์/จิตเวช — มีการ disclaim ชัดเจนและแนะนำผู้เชี่ยวชาญเมื่อพบสัญญาณเสี่ยง
 
## 9.6 Accountability (Vault Partner) — ดูรายละเอียดในหมวดที่ 10
 
## 9.7 Emergency Recovery
 
- ปุ่ม “ฉุกเฉิน” ที่ปลดบล็อกทันทีสำหรับสถานการณ์จำเป็นจริง (เช่น ต้องโทร/ใช้แผนที่)
 
- จำกัดจำนวนครั้ง และแจ้ง Vault Partner หลังใช้งาน (transparency)
 
- แยกจาก “override request” ปกติที่ต้องรอ approval
 
## 9.8 Notifications
 
- Nudge เชิงบวก (ไม่ shame), reminder เริ่ม session, weekly summary
 
- ผู้ใช้ปรับความถี่ได้ทั้งหมด (respect autonomy)
 
## 9.9 Personalization
 
- Onboarding assessment กำหนด default friction level และ app list
 
- ระบบเรียนรู้ pattern การใช้งานเพื่อปรับ nudge timing
 
## 9.10 Offline Support
 
- Focus session, blocking, logging ทำงานได้แบบ offline เต็มรูปแบบ แล้ว sync เมื่อออนไลน์ (ดูหมวด 21-22)
 
# 10. Vault Partner System (Flow, Edge Cases, Security)
 
## 10.1 แนวคิด
 
Vault Partner คือบุคคลที่ผู้ใช้ไว้วางใจ (เพื่อน, ครอบครัว, คู่ชีวิต) ซึ่งได้รับสิทธิ์จำกัดในการ **อนุมัติ/ปฏิเสธคำขอ override** ข้อจำกัดที่ผู้ใช้ตั้งไว้เอง เป็นกลไก commitment device ที่ทำให้การ “โกงตัวเอง” ยากขึ้น เพราะต้องผ่านบุคคลที่สาม
 
## 10.2 Core Flow
 
- **Invite:** ผู้ใช้ (Owner) ส่งคำเชิญผ่าน deep link/รหัสเชิญให้ Partner
 
- **Accept ****&**** Configure:** Partner ยอมรับ และร่วมตั้งค่าระดับสิทธิ์ (เช่น อนุมัติ override ได้ทุกกรณี / เฉพาะบางแอป / ต้องระบุเหตุผลก่อนเสมอ)
 
- **Active Monitoring (Consent-based):** Partner เห็นเฉพาะข้อมูลสรุป (session completion, streak) ไม่เห็นเนื้อหาที่ใช้ เว้นแต่ Owner เปิดสิทธิ์เพิ่ม
 
- **Override Request:** เมื่อ Owner ต้องการปลดบล็อกก่อนกำหนด ระบบส่งคำขอไปยัง Partner พร้อมเหตุผลที่ Owner กรอก
 
- **Approval Decision:** Partner กด Approve / Deny ภายในเวลาที่กำหนด (มี timeout)
 
- **Recovery Delay:** หาก Partner ไม่ตอบสนอง ระบบเข้าสู่ “cooling-off period” (ค่าเริ่มต้น 10-30 นาที) ก่อนปลดบล็อกอัตโนมัติแบบมีเงื่อนไข (ป้องกัน Owner ติดค้างเพราะ Partner ไม่ว่าง)
 
- **Audit Log:** ทุก request/response ถูกบันทึกและทั้งสองฝ่ายดูย้อนหลังได้
 
## 10.3 Edge Cases
 
| กรณี | การจัดการ |
| --- | --- |
| Partner ไม่ตอบสนองเลย | Cooling-off period แล้วปลดบล็อกอัตโนมัติ พร้อมแจ้ง Partner ภายหลัง |
| Owner สแปม override request | Rate limit คำขอ (เช่น สูงสุด 3 ครั้ง/วัน) เกินกว่านั้นต้องรอ cooling-off ยาวขึ้น |
| Partner ใช้สิทธิ์ในทางที่ผิด (เช่น deny ตลอดเวลาโดยไม่มีเหตุผล/harassment) | Owner สามารถยกเลิกสิทธิ์ Partner ได้ทันทีทุกเมื่อ (Owner มีอำนาจสูงสุดเสมอ) |
| Owner ต้องการยกเลิกความสัมพันธ์ | ทำได้ฝ่ายเดียว ไม่ต้องขอความยินยอมจาก Partner |
| หลาย Partner พร้อมกัน | รองรับ multi-partner, ตั้งกฎ “ต้องได้รับอนุมัติจากอย่างน้อย 1 ใน N คน” |
| Emergency จริง (ปลอดภัยชีวิต) | ใช้ Emergency Recovery แยกต่างหาก ไม่ผ่าน Partner approval เพื่อไม่ให้เป็นอุปสรรคในสถานการณ์อันตราย |
| Partner บล็อก/ลบบัญชี | ระบบแจ้งเตือน Owner และเสนอเชิญ Partner คนใหม่ |
 
## 10.4 Security & Privacy
 
- **Consent-based visibility:** Partner เห็นเฉพาะข้อมูลที่ Owner อนุญาตอย่างชัดเจน (granular permission, ไม่ใช่ all-or-nothing)
 
- **Owner-controlled revocation:** Owner ยกเลิกสิทธิ์ Partner ได้เสมอ โดยไม่ต้องมี approval จาก Partner
 
- **End-to-end scoped data:** Override request payload ส่งเฉพาะข้อมูลจำเป็น (แอปที่ขอ, เหตุผล, เวลา) ไม่ส่งเนื้อหาการใช้งานละเอียด
 
- **Anti-abuse safeguards:** ตรวจจับ pattern การใช้ Vault Partner เป็นเครื่องมือ coercive control (เช่น Partner บล็อกทุกคำขอเพื่อควบคุมอีกฝ่ายเกินขอบเขต) — มี in-app resource แนะนำหากตรวจพบ pattern เข้าข่ายความสัมพันธ์ที่ไม่ดีต่อสุขภาพ
 
- **Audit immutability:** log การอนุมัติ/ปฏิเสธ เก็บแบบ append-only ป้องกันการแก้ไขย้อนหลัง
 
# 11. Friction-based Intervention Framework
 
## 11.1 หลักการออกแบบ
 
Friction ต้อง “สัดส่วนกับความเสี่ยง” (proportional friction) — ไม่ใช่ยิ่งมากยิ่งดี เพราะ friction ที่มากเกินไปจะสร้างความหงุดหงิดจนผู้ใช้เลิกใช้แอปทั้งระบบ (uninstall risk)
 
## 11.2 ระดับ Friction (Adaptive Friction Levels)
 
| ระดับ | กลไก | ใช้เมื่อ |
| --- | --- | --- |
| **L0 — Awareness** | แสดง banner เตือนก่อนเปิดแอป (“นี่คือครั้งที่ 5 วันนี้”) | พฤติกรรมปกติ ยังไม่เกินเป้า |
| **L1 — Micro-friction** | หน่วงเวลา 5-10 วินาที + ปุ่ม “ยืนยันว่าต้องการจริงๆ” | เกินเป้ารายวันเล็กน้อย |
| **L2 — Reflective Pause** | ให้พิมพ์เหตุผลก่อนเข้าแอป (breathing exercise ทางเลือก) | ใกล้ focus session หรือช่วงเวลาที่ตั้งเป็น protected time |
| **L3 — Full Block** | บล็อกสมบูรณ์ระหว่าง active session | Focus session กำลังทำงาน |
| **L4 — Partner-gated** | ต้องผ่านการอนุมัติจาก Vault Partner จึงเข้าได้ | ผู้ใช้เปิดใช้งานระดับสูงสุดด้วยตนเอง (opt-in) |
 
## 11.3 Context-aware Escalation
 
ระบบปรับระดับ friction อัตโนมัติตาม: - เวลาในแผนที่ตั้งไว้ (protected hours) - ความถี่การพยายามเปิดแอปในช่วงเวลาสั้น ๆ (burst detection) - แนวโน้มพฤติกรรมสัปดาห์ก่อนหน้า (ถ้าดีขึ้นต่อเนื่อง ลด friction ลงเป็นรางวัล — “de-escalation as reward”)
 
## 11.4 หลักการป้องกัน Dark Pattern
 
- Friction ทุกระดับต้องมี “ทางออกที่ชัดเจนเสมอ” ห้ามออกแบบให้ผู้ใช้หาทางปิดไม่เจอ (ตรงข้ามกับ dark pattern ทั่วไปที่ทำให้ “ยกเลิก” หายาก)
 
- ไม่ใช้ guilt/shame message — ใช้ neutral, factual language เท่านั้น
 
- ผู้ใช้ตั้งค่า friction level เองได้เสมอ (ไม่ hard-code โดยไม่ให้ผู้ใช้รู้)
 
# 12. UX Principles & Design System
 
## 12.1 UX Principles
 
- **Low friction for productive actions** — เริ่ม focus session ต้องทำได้ภายใน 2 tap
 
- **Intentional friction for impulsive actions** — เปิดแอปกลุ่มเสี่ยงต้องผ่านขั้นตอนที่ออกแบบมาให้ “ช้าลงอย่างมีเหตุผล”
 
- **Transparency** — ผู้ใช้ต้องเข้าใจเสมอว่าทำไมระบบถึงทำงานแบบนั้น (ไม่มี black-box restriction)
 
- **Accessibility** — รองรับ WCAG 2.1 AA, screen reader, dynamic type, color contrast ≥4.5:1
 
- **Autonomy** — ทุกข้อจำกัดต้องมีทางปรับ/ยกเลิกโดยผู้ใช้เอง (ยกเว้น emergency safeguard)
 
## 12.2 Design System — Foundations
 
| Token | ค่า |
| --- | --- |
| Primary Color | Deep Indigo #3730A3 (สื่อถึงความสงบ, focus) |
| Accent Color | Warm Amber #F59E0B (ใช้กับ reward/streak เท่านั้น) |
| Danger/Friction Color | Muted Red #DC2626 (ใช้เฉพาะ friction gate ไม่ใช้พร่ำเพรื่อ) |
| Neutral Scale | Gray 50–900 (Tailwind-style scale) |
| Typography | Heading: Inter SemiBold / Body: Inter Regular |
| Spacing Scale | 4 / 8 / 12 / 16 / 24 / 32 / 48 (px, 8pt grid) |
| Corner Radius | 12px (card), 8px (button), 999px (pill/badge) |
| Elevation | 3 ระดับเงา (card, modal, floating action) |
| Motion | ease-out 200-300ms สำหรับ transition, ไม่ใช้ motion ที่กระตุ้น dopamine เกินจำเป็น (ห้ามใช้ confetti/celebration แบบ over-the-top ที่เข้าข่าย variable reward) |
 
## 12.3 Component Library (หลัก)
 
- Buttons (Primary, Secondary, Ghost, Danger)
 
- Timer Ring (circular progress สำหรับ focus session)
 
- Streak Badge
 
- Friction Modal (มาตรฐานเดียวกันทุกระดับ friction)
 
- Partner Approval Card
 
- Insight Card (AI Coach)
 
- Chart components (line, bar สำหรับ analytics — ใช้ minimal color, ไม่ over-gamify data)
 
## 12.4 Tone of Voice
 
- ตรงไปตรงมา ไม่ตัดสิน (non-judgmental)
 
- ใช้ภาษาสนับสนุน (“ลองอีกครั้งได้เสมอ”) แทนภาษาตำหนิ (“คุณทำพลาดอีกแล้ว”)
 
- หลีกเลี่ยงคำที่กระตุ้นความรู้สึกผิดเกินจำเป็น
 
# 13. Wireframe แนวคิดทุกหน้าจอ
 
หมายเหตุ: อธิบายเป็น structural wireframe (ASCII/text-based layout description) สำหรับส่งต่อให้ทีมออกแบบ UI ทำ high-fidelity mockup ต่อ
 
## 13.1 Onboarding — Behavioral Assessment
 
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
 
## 13.2 Home Dashboard
 
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
 
## 13.3 Focus Session — Active Timer
 
┌───────────────────────────┐
│         25:14              │  countdown, large
│      ╭───────────╮         │
│     │   ⬤ ring    │         │  circular progress
│      ╰───────────╯         │
│  เป้าหมาย: "อ่านบทที่ 4"     │  intention reminder
│                             │
│  [⏸พัก]     [✕ออกจาก session] │
└───────────────────────────┘
 
## 13.4 Friction Gate Modal (L2 — Reflective Pause)
 
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
 
## 13.5 Vault Partner — Override Request (Partner View)
 
┌───────────────────────────┐
│  คำขอจาก ปูน                │
│  ต้องการปลดบล็อก Instagram   │
│  เหตุผล: "ต้องเช็คงานกลุ่ม"  │
│  ขอเมื่อ: 2 นาทีที่แล้ว        │
│                             │
│  [อนุมัติ]   [ปฏิเสธ]    │
└───────────────────────────┘
 
## 13.6 Analytics Dashboard
 
┌───────────────────────────┐
│  แนวโน้ม 7 วันล่าสุด          │
│  [ line chart: focus min ]  │
│                             │
│  Dopamine Load Index: 42/100 (ลดลง) │
│                             │
│  เหตุการณ์ distraction: 8 ครั้ง │
│  [ bar chart by app ]       │
└───────────────────────────┘
 
## 13.7 Recovery / Streak Break
 
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
 
## 13.8 AI Coach Chat
 
┌───────────────────────────┐
│  AI Coach                │
├───────────────────────────┤
│  สัปดาห์นี้คุณโฟกัสเพิ่มขึ้น 20% │
│  จากสัปดาห์ก่อน ลองรักษา      │
│  จังหวะนี้ต่อไหม?              │
├───────────────────────────┤
│  [_______________] [ส่ง]     │  chat input
└───────────────────────────┘
 
# 14. Navigation Flow
 
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
 ├─▶ Vault Tab
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
       Account / Notifications / Privacy / Friction Levels / App Selection
             │
             └─▶ Emergency Recovery (accessible globally via long-press on nav)
 
Deep link support: dopaminefocus://vault/invite/{token}, dopaminefocus://focus/start, dopaminefocus://override/{requestId} (สำหรับ push notification ที่ต้อง jump ตรงไปหน้า approval)
 
# 15. State Management
 
## 15.1 แนวทาง (Flutter)
 
ใช้ **Riverpod 2.x (code-gen)** เป็น state management หลัก ด้วยเหตุผล: type-safety, testability สูง, รองรับ async state (FutureProvider/StreamProvider) ได้ดีสำหรับ sync/offline scenario, และหลีกเลี่ยงปัญหา BuildContext-coupling ของ Provider แบบเดิม
 
## 15.2 State Layers
 
| Layer | เครื่องมือ | ตัวอย่าง |
| --- | --- | --- |
| **UI State (ephemeral)** | StateProvider / local StatefulWidget | ค่าฟอร์มระหว่างกรอก, animation state |
| **App/Domain State** | NotifierProvider / AsyncNotifierProvider | Active focus session, current user, friction settings |
| **Server Cache State** | AsyncNotifierProvider + local cache (Drift) | รายการ Vault Partner, analytics data |
| **Persistent Local State** | Drift (SQLite) + Hive สำหรับ key-value เล็ก | Offline session queue, cached settings |
| **Global Auth State** | NotifierProvider<AuthController> | token, session, user profile |
 
## 15.3 หลักการ
 
- **Single source of truth ต่อ domain** — ห้ามมี state ซ้ำซ้อนระหว่าง provider
 
- **Unidirectional data flow** — UI dispatch action → Notifier update state → UI rebuild
 
- **Offline-first state** — ทุก mutation (เช่น เริ่ม/จบ session) เขียนลง local DB ก่อนเสมอ แล้วค่อย queue sync ไป backend (ดูหมวด 21-22)
 
- **Optimistic UI updates** พร้อม rollback mechanism หาก sync ล้มเหลว
 
# 16. Database Schema (ERD)
 
## 16.1 ภาพรวม Entity
 
User ──1:N──▶ FocusSession
User ──1:N──▶ DistractionEvent
User ──1:N──▶ HabitGoal
User ──1:1..N──▶ VaultPartnership (as Owner)
User ──1:1..N──▶ VaultPartnership (as Partner)
VaultPartnership ──1:N──▶ OverrideRequest
User ──1:N──▶ BlockedApp
User ──1:N──▶ ReflectionEntry
User ──1:1──▶ UserSettings
User ──1:N──▶ NotificationPreference
User ──1:N──▶ AnalyticsSnapshot (daily rollup)
User ──1:N──▶ AuditLogEntry
 
## 16.2 ตาราง (Core Tables)
 
**users** | Column | Type | Note | |—|—|—| | id | UUID (PK) | | | email | text unique | | | display_name | text | | | auth_provider | enum(email, google, apple) | | | created_at | timestamptz | | | timezone | text | IANA tz name | | onboarding_completed_at | timestamptz null | | | deleted_at | timestamptz null | soft delete |
 
**focus_sessions** | Column | Type | Note | |—|—|—| | id | UUID (PK) | | | user_id | UUID (FK → users) | | | intention | text | | | planned_duration_sec | int | | | actual_duration_sec | int | | | status | enum(active, completed, aborted) | | | started_at | timestamptz | | | ended_at | timestamptz null | | | local_id | UUID | สำหรับ offline dedup | | synced_at | timestamptz null | |
 
**distraction_events** | Column | Type | Note | |—|—|—| | id | UUID (PK) | | | user_id | UUID (FK) | | | app_package_id | text | | | friction_level | int | L0-L4 | | resolved_action | enum(returned_to_focus, opened_anyway, partner_approved, emergency_override) | | | occurred_at | timestamptz | |
 
**vault_partnerships** | Column | Type | Note | |—|—|—| | id | UUID (PK) | | | owner_user_id | UUID (FK) | | | partner_user_id | UUID (FK) | | | status | enum(pending, active, revoked) | | | permission_scope | jsonb | granular visibility flags | | approval_rule | enum(any_partner, all_partners) | สำหรับ multi-partner | | created_at | timestamptz | | | revoked_at | timestamptz null | |
 
**override_requests** | Column | Type | Note | |—|—|—| | id | UUID (PK) | | | partnership_id | UUID (FK) | | | requested_by_user_id | UUID (FK) | | | app_package_id | text | | | reason_text | text | | | status | enum(pending, approved, denied, expired_auto_released) | | | requested_at | timestamptz | | | resolved_at | timestamptz null | | | resolved_by_user_id | UUID null | |
 
**habit_goals** | id, user_id, title, target_type(streak/frequency), target_value, created_at, archived_at |
 
**blocked_apps** | id, user_id, app_package_id, friction_level, active_hours(jsonb), created_at |
 
**reflection_entries** | id, user_id, session_id (nullable FK), prompt_key, response_text, mood_tag, created_at |
 
**user_settings** | user_id (PK/FK), default_friction_level, quiet_hours(jsonb), locale, theme, emergency_override_limit_per_month |
 
**analytics_snapshots** (daily rollup, materialized สำหรับ dashboard เร็ว) | id, user_id, date, total_focus_min, distraction_count, dopamine_load_index, streak_current, streak_best |
 
**audit_log_entries** (append-only) | id, actor_user_id, entity_type, entity_id, action, metadata(jsonb), created_at |
 
## 16.3 Indexing Strategy
 
- focus_sessions(user_id, started_at DESC) — สำหรับ history/analytics query
 
- distraction_events(user_id, occurred_at DESC)
 
- override_requests(partnership_id, status) — สำหรับ approval inbox query
 
- vault_partnerships(owner_user_id), vault_partnerships(partner_user_id)
 
- Partial index บน override_requests WHERE status='pending' เพื่อ query inbox ให้เร็ว
 
# 17. Backend Architecture
 
## 17.1 ภาพรวม
 
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
 
## 17.2 Service Breakdown (Modular Monolith → ค่อย extract เป็น microservice เมื่อจำเป็น)
 
| Module | หน้าที่ |
| --- | --- |
| **AuthModule** | Register/Login, token issuance, OAuth (Google/Apple) |
| **UserModule** | Profile, settings, onboarding state |
| **FocusModule** | Session lifecycle, intention, completion logic |
| **FrictionModule** | Friction level calculation, escalation rules |
| **VaultModule** | Partnership management, override request workflow |
| **AnalyticsModule** | Rollup jobs, dopamine load index calculation |
| **NotificationModule** | Push, email, in-app notification dispatch |
| **SyncModule** | Offline delta sync endpoint |
| **AuditModule** | Immutable audit log writer |
 
**เหตุผลเลือก Modular Monolith สำหรับ MVP:** ทีมเล็ก, ลด operational overhead ของ microservices ตั้งแต่ต้น, แต่ยังคง module boundary ชัดเจนด้วย NestJS module system เพื่อให้ extract ออกเป็น service แยกได้ในอนาคตโดยไม่ต้อง rewrite
 
## 17.3 Realtime Requirements
 
Override Request ต้องแจ้งเตือน Partner แบบเรียลไทม์ — ใช้ WebSocket gateway (Socket.IO ผ่าน NestJS @WebSocketGateway) ร่วมกับ Push Notification (FCM/APNs) เป็น fallback เมื่อแอปไม่ได้เปิดอยู่
 
# 18. API Specification
 
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
 
Friction / Blocked Apps
GET    /v1/blocked-apps
PUT    /v1/blocked-apps                   (bulk upsert)
GET    /v1/friction-settings
PATCH  /v1/friction-settings
 
Distraction Events
POST   /v1/distraction-events             (log event)
POST   /v1/distraction-events/sync        (batch offline sync)
 
Vault Partner
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
POST   /v1/emergency/override             (rate-limited, logged)
 
Analytics
GET    /v1/analytics/summary?range=7d|30d|90d
GET    /v1/analytics/dopamine-load
GET    /v1/analytics/export?format=csv|pdf
 
AI Coach
POST   /v1/ai-coach/messages
GET    /v1/ai-coach/insights
 
Notifications
GET    /v1/notifications/preferences
PATCH  /v1/notifications/preferences
POST   /v1/notifications/device-token
 
WebSocket
WS     /v1/ws/vault                        (subscribe: override-request events)
 
## 18.3 ตัวอย่าง Request/Response
 
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
 
Error code namespace แยกตาม module (AUTH_*, VAULT_*, FOCUS_*, SYNC_*) เพื่อให้ client จับ error ได้ชัดเจนและแปลข้อความ localize ได้ง่าย
 
# 19. Authentication & Authorization
 
## 19.1 Authentication
 
- **วิธีการ:** Email+Password, Sign in with Apple (บังคับสำหรับ iOS ตามข้อกำหนด App Store), Sign in with Google
 
- **Provider:** Firebase Authentication (รองรับ OAuth หลายเจ้า, มี SDK Flutter สำเร็จรูป, ลดงาน infra ช่วง MVP) — Backend (NestJS) ตรวจสอบ Firebase ID Token ผ่าน Admin SDK แล้วออก **application-level JWT** (access token อายุสั้น 15 นาที + refresh token อายุยาว 30 วัน เก็บแบบ rotate) เพื่อคุม authorization ภายในระบบเราเอง ไม่ผูกกับ Firebase claim โดยตรง
 
- **MFA:** ไม่บังคับใน MVP แต่ออกแบบ schema ให้รองรับ TOTP ในอนาคต
 
## 19.2 Authorization Model
 
**Role-based + Relationship-based (ReBAC) แบบผสม:**
 
| Role | ขอบเขตสิทธิ์ |
| --- | --- |
| owner (เจ้าของบัญชี) | เต็มสิทธิ์เหนือข้อมูลตนเองเสมอ, ยกเลิก Vault Partnership ได้ฝ่ายเดียว |
| vault_partner | สิทธิ์จำกัดตาม permission_scope ของ partnership นั้น ๆ เท่านั้น (ไม่ใช่ role ระดับ global) |
| system/service | ใช้สำหรับ internal job (analytics rollup, notification dispatch) ผ่าน service account แยก |
 
Authorization ตรวจสอบสองชั้นเสมอ: (1) JWT scope/role ระดับ endpoint (NestJS Guard) และ (2) ownership check ระดับ resource (เช่น ตรวจว่า override_request.partnership_id เป็นของ user ที่ request จริง) เพื่อป้องกัน IDOR (Insecure Direct Object Reference)
 
## 19.3 Token Handling
 
- Access token: JWT (RS256), ส่งผ่าน Authorization: Bearer
 
- Refresh token: เก็บใน secure storage ฝั่ง client (Flutter flutter_secure_storage), rotate ทุกครั้งที่ใช้ (refresh token rotation ป้องกัน replay)
 
- Revocation list ใน Redis สำหรับ logout/บัญชีถูกลบ
 
# 20. Notification Architecture
 
## 20.1 ประเภท Notification
 
| ประเภท | ช่องทาง | Trigger |
| --- | --- | --- |
| Override request | Push (สำคัญที่สุด, ต้อง near-real-time) | Owner ส่งคำขอ |
| Focus reminder | Push, local notification | ตามตารางที่ตั้งไว้ |
| Weekly summary | Push + In-app | Cron รายสัปดาห์ |
| Streak at risk | Push | ใกล้หมดวันแต่ยังไม่ทำ session |
| Partner accepted invite | Push | Partner ตอบรับคำเชิญ |
| AI Coach insight | In-app (ไม่ push spam) | เมื่อพบ pattern ที่น่าสนใจ |
 
## 20.2 สถาปัตยกรรม
 
Event (domain) ──▶ NotificationModule ──▶ BullMQ Job
                                              │
                          ┌───────────────────┼────────────────────┐
                          ▼                   ▼                    ▼
                   FCM (Android)        APNs (iOS)          In-app store (DB)
 
- ใช้ Job Queue (BullMQ + Redis) กัน notification service ล่มเวลาโหลดสูง และรองรับ retry/backoff
 
- Override request ใช้คิวความสำคัญสูง (priority queue) แยกจาก notification ทั่วไป เพื่อ latency ต่ำสุด (<3 วินาที)
 
- Deep-link payload แนบไปกับทุก push เพื่อให้กด notification แล้วพาไปหน้าที่เกี่ยวข้องทันที (ดู navigation flow หมวด 14)
 
## 20.3 User Control
 
ผู้ใช้ตั้งค่า quiet hours และปิด/เปิดแต่ละประเภทได้แยกกัน ยกเว้น override request ที่ปิดไม่ได้ทั้งหมด (สามารถลด priority ได้แต่ปิดสนิทไม่ได้ เพราะกระทบกลไก accountability หลัก) — ต้องแจ้งผู้ใช้อย่างชัดเจนตอน setup
 
# 21. Offline-first Design
 
## 21.1 หลักการ
 
ฟีเจอร์หลัก (focus session, app blocking, friction gate, distraction logging) ต้อง **ทำงานได้ 100% แบบ offline** เพราะเป็นกลไกป้องกันพฤติกรรมที่เกิดขึ้นได้ทุกที่ ไม่ควรพึ่งพา network
 
## 21.2 Local Data Layer
 
- **Drift (SQLite wrapper สำหรับ Flutter)** เป็น local database หลัก — mirror schema ของ core entity (focus_sessions, distraction_events, blocked_apps, reflection_entries)
 
- **Hive** สำหรับ key-value เล็ก ๆ ที่ต้องอ่านเร็วมาก (เช่น current friction level, active session state) เพราะ friction gate ต้อง evaluate ได้ทันทีแม้ไม่มี network
 
## 21.3 Local-first Write Pattern
 
- ทุก mutation เขียนลง local DB ก่อนเสมอ พร้อม local_id (UUID generated client-side) และ synced_at = null
 
- UI อ่านจาก local DB เสมอ (ไม่รอ network round-trip)
 
- Background sync worker (WorkManager บน Android, BGTaskScheduler บน iOS) พยายาม push record ที่ synced_at = null ไปยัง backend เมื่อมีเน็ต
 
## 21.4 App Blocking แบบ Offline
 
การบล็อกแอปทำงานผ่าน native platform API โดยตรง (ดูหมวด Technical Stack) ไม่ผ่าน server-round-trip — ตรรกะ friction level และ active session อยู่ใน local state (Hive) ทั้งหมด เพื่อให้ block ทำงานได้แม้ปิด network/airplane mode
 
# 22. Sync Strategy
 
## 22.1 Sync Model
 
**Delta sync แบบ client-push, server-merge** — client ส่งเฉพาะ record ที่เปลี่ยนแปลง (synced_at IS NULL หรือ updated_at > last_sync_at) เป็น batch ผ่าน POST /v1/{resource}/sync
 
## 22.2 Conflict Resolution
 
| ประเภทข้อมูล | กลยุทธ์ |
| --- | --- |
| Append-only (distraction_events, reflection_entries) | ไม่มี conflict — insert ตาม local_id (idempotent, server ignore ถ้า local_id ซ้ำ) |
| Mutable (user_settings, blocked_apps) | **Last-Write-Wins ด้วย**** ****updated_at**** ****timestamp** พร้อมเก็บ conflict log ไว้ตรวจสอบ |
| Session state (focus_sessions) | Server เป็น source of truth หลังจาก sync สำเร็จ — client เชื่อ server response เพื่อ resolve status |
 
## 22.3 Sync Triggers
 
- App เข้า foreground
 
- Network state เปลี่ยนจาก offline → online
 
- ทุก 15 นาทีเมื่อ app อยู่ foreground (periodic background sync)
 
- Manual pull-to-refresh
 
## 22.4 Idempotency
 
ทุก sync endpoint รับ local_id เป็น idempotency key — server upsert แทน insert ตรงเพื่อป้องกัน duplicate เมื่อ retry (เช่น network หลุดกลางทาง)
 
# 23. Security Model
 
## 23.1 Application Security
 
- Input validation ทุก endpoint ด้วย class-validator (NestJS DTO)
 
- Rate limiting ระดับ IP + user (@nestjs/throttler + Redis) โดยเฉพาะ endpoint ที่มีความเสี่ยงสูง (auth, override-requests, emergency)
 
- CSRF ไม่จำเป็นสำหรับ mobile-only API (ไม่มี cookie-based session) แต่ยังคง CORS policy รัดกุมสำหรับ future web
 
- Dependency scanning อัตโนมัติใน CI (Dependabot/Snyk)
 
## 23.2 Data Security
 
- Encryption at rest: PostgreSQL ผ่าน disk-level encryption ของ cloud provider (เช่น AWS RDS encryption)
 
- Encryption in transit: TLS 1.2+ ทุก endpoint บังคับ HTTPS
 
- Sensitive field (เช่น reflection entries ที่อาจมีเนื้อหาส่วนตัวมาก) เข้ารหัสระดับ column ด้วย application-level encryption (AES-256-GCM) โดย key จัดการผ่าน KMS
 
- Secrets management ผ่าน environment-based secret manager (ไม่ commit secret ลง repo, ใช้ GitHub Actions secrets/Vault)
 
## 23.3 Vault Partner Security (สรุปเพิ่มจากหมวด 10.4)
 
- Override request payload เป็น scoped data เท่านั้น
 
- Owner สามารถ revoke สิทธิ์ Partner ได้ทันทีแบบ real-time (ตัด websocket subscription + invalidate token scope)
 
## 23.4 Abuse Prevention
 
- Rate limit emergency override (ค่าเริ่มต้น 3 ครั้ง/เดือน, ปรับได้แต่มี hard ceiling)
 
- Anomaly detection เบื้องต้น (job รายวัน) ตรวจ pattern ผิดปกติ เช่น partnership ที่มี deny rate 100% ต่อเนื่อง เพื่อ flag ให้ trust & safety ทีมตรวจสอบ (สอดคล้องกับ anti-coercion safeguard)
 
# 24. Privacy & Compliance
 
## 24.1 หลักการ
 
Privacy-by-design และ data minimization — เก็บเฉพาะข้อมูลที่จำเป็นต่อฟีเจอร์จริง ไม่เก็บเนื้อหาที่ผู้ใช้เสพ (เช่น ไม่เก็บว่าผู้ใช้ดูวิดีโออะไร เก็บแค่ app package + เวลา)
 
## 24.2 ประเด็นตามกฎหมาย/มาตรฐาน (สรุปหลักการทั่วไป — ไม่ใช่คำแนะนำทางกฎหมาย)
 
- **GDPR-style rights:** สิทธิ์เข้าถึง (access), แก้ไข (rectification), ลบ (erasure/“right to be forgotten”), และ portability (export ข้อมูลเป็น CSV/JSON) — implement ผ่าน DELETE /v1/users/me และ GET /v1/analytics/export
 
- **Consent management:** ทุกการแชร์ข้อมูลกับ Vault Partner ต้องเป็น explicit opt-in ระดับ field (granular consent) ไม่ใช่ checkbox เดียวครอบคลุมทุกอย่าง
 
- **Data retention:** กำหนด retention policy ชัดเจน (เช่น distraction event raw log เก็บ 24 เดือน แล้ว aggregate เป็น summary, ลบ raw record)
 
- **Minors:** หากเปิดให้ผู้ใช้อายุต่ำกว่าเกณฑ์ (เช่น <18) ต้องพิจารณากรอบเพิ่มเติม (เช่น COPPA ในสหรัฐฯ) — เวอร์ชัน 1.0 กำหนดอายุขั้นต่ำ 16 ปีในเงื่อนไขการใช้งานเพื่อลดความซับซ้อนด้าน compliance ก่อน แล้วประเมินเพิ่มเติมภายหลัง
 
## 24.3 Data Sensitivity Classification
 
| ระดับ | ตัวอย่างข้อมูล | มาตรการ |
| --- | --- | --- |
| High | Reflection entries, mood tags | Column-level encryption, ไม่แชร์กับ Partner โดยอัตโนมัติ |
| Medium | Distraction event log, override reason text | Scoped visibility ตาม consent |
| Low | Streak count, session completion count | แสดงให้ Partner เห็นเป็นค่า default (แต่ยัง toggle ปิดได้) |
 
## 24.4 Third-party Data Sharing
 
ไม่ขายหรือแชร์ข้อมูลผู้ใช้กับบุคคลที่สามเพื่อวัตถุประสงค์โฆษณา — ผู้ให้บริการภายนอกที่ใช้ (Firebase Auth, FCM, cloud hosting) เป็น data processor ภายใต้ data processing agreement เท่านั้น ต้องระบุไว้ใน Privacy Policy อย่างชัดเจน
 
# 25. Risk Analysis พร้อมแนวทางลดความเสี่ยง
 
| ความเสี่ยง | โอกาสเกิด | ผลกระทบ | แนวทางลดความเสี่ยง |
| --- | --- | --- | --- |
| ผู้ใช้ถอนแอปทิ้งเพราะ friction มากไป | สูง | สูง | Adaptive friction, onboarding ที่ตั้งค่า default เหมาะสม, A/B test ระดับ friction |
| ผู้ใช้ปิด permission (Accessibility/Usage Access) เพื่อเลี่ยงระบบ | สูง | สูง | ตรวจจับการปิด permission แล้วแจ้งเตือนเชิงบวก (ไม่บังคับ), ให้ค่าเมื่อเปิดใช้ครบ (streak bonus) |
| ใช้อุปกรณ์/บัญชีสำรองเลี่ยงบล็อก | กลาง | กลาง | เป็นข้อจำกัดโดยธรรมชาติของ mobile OS sandboxing — สื่อสารให้ผู้ใช้เข้าใจว่าแอปช่วยสร้างวินัย ไม่ใช่ “คุก” ที่หนีไม่ได้ 100% |
| Burnout จากการตั้งเป้าหมายเข้มงวดเกินไป | กลาง | สูง | Progressive difficulty, non-punishing streak design, AI Coach แนะนำปรับเป้าหมายเมื่อพบสัญญาณ overload |
| Vault Partner ถูกใช้เป็นเครื่องมือควบคุมเกินขอบเขต (coercive control) | ต่ำ-กลาง | สูงมาก | Owner ยกเลิกสิทธิ์ได้เสมอฝ่ายเดียว, anomaly detection, in-app resource แนะนำเมื่อพบสัญญาณเสี่ยง |
| False positive ใน distraction detection (เช่น เปิดแอปเพื่อทำงานจริง) | กลาง | ต่ำ-กลาง | Context-aware allowlist, ให้ผู้ใช้ mark “งานจริง” แล้วระบบเรียนรู้ pattern |
| Privacy breach / data leak | ต่ำ | สูงมาก | Encryption, least-privilege access, security audit สม่ำเสมอ, data minimization |
| Platform policy risk (Apple/Google เข้มงวดเรื่อง Accessibility API) | กลาง | สูง | ติดตาม platform guideline อย่างใกล้ชิด, ออกแบบให้พึ่งพา official Screen Time/Digital Wellbeing API เป็นหลักแทนการใช้ Accessibility Service แบบ invasive |
| Scope creep จากฟีเจอร์เยอะเกินไปใน MVP | สูง | กลาง | ยึด MVP scope ตามหมวด 36 อย่างเคร่งครัด, ใช้ RICE prioritization สำหรับฟีเจอร์เพิ่มเติม |
| ทีมพัฒนาเล็ก ความเร็วไม่พอ timeline | กลาง | กลาง | Modular monolith ลด overhead, ใช้ managed service (Firebase Auth, managed Postgres) แทนสร้างเอง |
 
# 26. Technical Stack พร้อมเหตุผล
 
| Layer | เทคโนโลยี | เหตุผล |
| --- | --- | --- |
| Mobile Client | **Flutter (Dart)** | Codebase เดียวสำหรับ iOS/Android, performance ใกล้เคียง native, community/ecosystem แข็งแรง, เหมาะกับทีมเล็กที่ต้อง ship เร็ว |
| State Management | **Riverpod 2.x** | Type-safe, testable, รองรับ async/offline state ได้ดีกว่า Provider/BLoC สำหรับ use case นี้ |
| Local DB | **Drift (SQLite)** + **Hive** | Drift สำหรับ relational data ที่ต้อง query ซับซ้อน (session history), Hive สำหรับ key-value ที่ต้องอ่านเร็วมาก (friction state) |
| Backend Framework | **NestJS (Node.js/TypeScript)** | Modular architecture ตรงกับแนวทาง modular monolith, TypeScript ทั้ง stack (client ใช้ Dart แต่ API contract type-safe ผ่าน OpenAPI codegen), ecosystem ครบ (Guard, Interceptor, DI) |
| Database | **PostgreSQL** | ACID compliance, jsonb รองรับ permission_scope แบบยืดหยุ่น, มี extension ครบ (pg_cron สำหรับ rollup job) |
| Auth | **Firebase Authentication** | ลดงาน infra สำหรับ OAuth/social login, SDK Flutter พร้อมใช้ |
| Cache/Queue | **Redis + BullMQ** | Job queue สำหรับ notification/analytics rollup, session/rate-limit cache |
| Push Notification | **FCM (Android) / APNs (iOS)** | มาตรฐานอุตสาหกรรม, integrate ง่ายกับ Flutter ผ่าน firebase_messaging |
| CI/CD | **GitHub Actions** | Integrate ตรงกับ GitHub repo, รองรับ macOS runner สำหรับ iOS build |
| Containerization | **Docker** | Consistent environment dev/staging/prod |
| Hosting (Backend) | **Managed container platform (เช่น AWS ECS Fargate หรือเทียบเท่า)** | ลด operational overhead เทียบกับ self-managed K8s ในช่วง MVP/ทีมเล็ก |
| Monitoring | **Sentry (error tracking) + Grafana/Prometheus หรือ managed APM** | ตรวจจับ crash/error เร็ว, สำคัญมากสำหรับแอปที่ทำงาน offline-first ซึ่ง debug ยากกว่าปกติ |
| API Style | **REST (หลัก) + WebSocket (real-time approval)** | REST เพียงพอสำหรับ CRUD ส่วนใหญ่, WebSocket เฉพาะจุดที่ต้อง latency ต่ำจริง ๆ (ไม่ over-engineer เป็น GraphQL/full-realtime ทั้งระบบตั้งแต่ต้น) |
 
# 27. Flutter Project Structure
 
lib/
├── main.dart
├── app/
│   ├── app.dart                 # MaterialApp root, theme, routing
│   └── router/                  # go_router configuration
├── core/
│   ├── constants/
│   ├── theme/                   # design tokens (หมวด 12.2)
│   ├── network/                 # dio client, interceptors
│   ├── local_db/                # Drift database, Hive boxes
│   ├── error/                   # error/failure types
│   └── utils/
├── features/
│   ├── onboarding/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── screens/
│   │       ├── widgets/
│   │       └── providers/
│   ├── focus_session/
│   │   ├── data/                # repositories, DTOs
│   │   ├── domain/               # entities, use cases
│   │   └── presentation/
│   ├── friction/
│   ├── vault_partner/
│   ├── analytics/
│   ├── ai_coach/
│   ├── notifications/
│   ├── settings/
│   └── auth/
├── shared/
│   ├── widgets/                  # design-system components
│   └── extensions/
└── l10n/                         # localization (th, en)
 
**หลักการ:** Feature-first + Clean Architecture แบบ pragmatic (data/domain/presentation ต่อ feature) — ไม่ over-engineer เป็น full Clean Architecture 4-layer เพราะทีมเล็ก แต่คง separation of concerns ที่เพียงพอให้ test ได้และสลับ implementation (เช่น local vs remote data source) ได้ง่าย
 
# 28. Monorepo Structure
 
dopamine-focus/
├── apps/
│   ├── mobile/                   # Flutter app (โครงสร้างหมวด 27)
│   └── backend/                  # NestJS app
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
│   ├── api-contracts/            # OpenAPI spec + generated types (ใช้ทั้ง backend และ codegen ให้ Dart client)
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
 
**เครื่องมือ Monorepo:** ใช้ **Turborepo** สำหรับส่วน backend/TypeScript packages (เบา เรียนรู้ง่าย เหมาะทีมเล็ก) โดย Flutter app อยู่ใน monorepo เดียวกันแต่ build ผ่าน toolchain ของตัวเอง (ไม่ผูกกับ Turborepo pipeline โดยตรง เพราะ Dart/Flutter ไม่ได้อยู่ใน npm ecosystem) — เชื่อมกันผ่าน packages/api-contracts ที่ generate ทั้ง TypeScript types (backend) และ Dart models (mobile, ผ่าน openapi-generator)
 
# 29. CI/CD
 
## 29.1 Pipeline Overview (GitHub Actions)
 
on: pull_request → 
  ┌─ lint (dart analyze / eslint)
  ├─ unit tests (flutter test / jest)
  ├─ build check (flutter build --debug / nest build)
  └─ security scan (dependency audit)
 
on: merge to main →
  ┌─ full test suite (unit + widget + integration)
  ├─ build staging artifacts
  ├─ deploy backend → staging (auto)
  ├─ deploy mobile → internal testing track (Firebase App Distribution / TestFlight internal)
  └─ notify team (Slack)
 
on: release tag (vX.Y.Z) →
  ┌─ build production artifacts (iOS via macOS runner, Android via standard runner)
  ├─ deploy backend → production (manual approval gate)
  ├─ submit to App Store Connect / Google Play (via fastlane)
  └─ tag release notes
 
## 29.2 macOS Runner สำหรับ iOS
 
เนื่องจากการ build/sign iOS ต้องใช้ macOS toolchain (Xcode) — ใช้ GitHub Actions macos-latest runner (หรือ Codemagic เป็นทางเลือกถ้าต้องการ build farm เฉพาะ Flutter ที่เร็วกว่า) จัดการ signing certificate ผ่าน **Fastlane Match** เพื่อ sync certificate/provisioning profile ข้ามเครื่อง
 
## 29.3 Environments
 
| Environment | วัตถุประสงค์ | Deploy Trigger |
| --- | --- | --- |
| dev | ทดสอบระหว่างพัฒนา | ทุก push branch feature (ephemeral, optional) |
| staging | QA, internal testing, TestFlight/Play internal track | merge to main |
| production | ผู้ใช้จริง | release tag + manual approval |
 
# 30. Testing Strategy
 
## 30.1 Testing Pyramid
 
        ▲  E2E (น้อยที่สุด)
       ╱ ╲   Patrol/Maestro — critical flows เท่านั้น
      ╱   ╲
     ╱     ╲  Integration Tests
    ╱       ╲  API integration, DB integration, sync flow
   ╱─────────╲
  ╱           ╲  Widget Tests (Flutter) / Unit Tests (Nest)
 ╱             ╲  ครอบคลุมมากที่สุด
╱───────────────╲
 
## 30.2 รายละเอียดตามชั้น
 
| ชั้น | เครื่องมือ | ขอบเขต | เป้าหมาย coverage |
| --- | --- | --- | --- |
| Unit Test (Flutter) | flutter_test, mocktail | Domain logic, use cases, providers | ≥80% ของ business logic |
| Unit Test (Backend) | jest | Services, guards, pipes | ≥80% |
| Widget Test | flutter_test | Component rendering, interaction | Critical UI components ทั้งหมด |
| Integration Test (Backend) | jest + testcontainers (Postgres) | API endpoint end-to-end ต่อ module | ทุก endpoint หลัก |
| E2E Mobile | Patrol หรือ Maestro | Onboarding, Focus session flow, Vault override flow | Critical path 5-8 flow เท่านั้น (ไม่ over-invest) |
| Offline/Sync Test | Custom test harness จำลอง network toggling | Conflict resolution, idempotency ของ sync | ครอบคลุมทุก conflict scenario ในหมวด 22.2 |
| Security Test | OWASP ZAP (baseline scan), manual pentest ก่อน launch | Auth, authorization, injection | ก่อนทุก major release |
| Load Test | k6 | Backend endpoint หลัก โดยเฉพาะ override-request realtime path | ก่อน public launch |
 
## 30.3 การทดสอบเฉพาะโดเมน (Behavioral correctness)
 
เพิ่มจาก testing ปกติ — เนื่องจากผลิตภัณฑ์นี้พึ่งพา “ตรรกะพฤติกรรม” ที่ผิดพลาดได้ง่าย (เช่น friction escalation, cooling-off timer) จึงต้องมี **scenario-based test suite** เฉพาะ เช่น “Partner ไม่ตอบภายใน cooling-off period ต้อง auto-release ตรงเวลา ±5 วินาที” เป็นต้น
 
# 31. Release Strategy
 
## 31.1 Release Cadence
 
- **Backend:** Continuous deployment สู่ staging ทุก merge, production release แบบ controlled (weekly หรือ on-demand หลัง QA sign-off)
 
- **Mobile:** Release แบบ 2-3 สัปดาห์/ครั้ง (เหมาะกับรอบ review ของ App Store/Play Store)
 
## 31.2 Rollout Strategy
 
- **Backend:** Blue-green หรือ rolling deployment พร้อม health check ก่อน route traffic เต็ม
 
- **Mobile:** Staged rollout ผ่าน Google Play (เริ่ม 10% → 50% → 100%), App Store phased release (7 วัน automatic increase)
 
- **Feature Flags:** ใช้ remote config (Firebase Remote Config) สำหรับฟีเจอร์เสี่ยงสูง (เช่น friction algorithm ใหม่) เพื่อเปิด/ปิดได้โดยไม่ต้อง release ใหม่ และรองรับ A/B testing
 
## 31.3 Rollback Plan
 
- Backend: เก็บ previous container image พร้อม rollback ได้ภายใน <5 นาที
 
- Mobile: หยุด staged rollout ทันทีเมื่อ crash rate เกิน threshold (monitor ผ่าน Sentry), แจ้งผู้ใช้ผ่าน in-app message หากจำเป็นต้องรอ patch release
 
# 32. KPI / Metrics
 
## 32.1 North Star Metric
 
**“****Weekly Sustained Focus Minutes****”** — จำนวนนาทีรวมของ focus session ที่ผู้ใช้ทำสำเร็จ (ไม่ใช่แค่เริ่ม) ต่อสัปดาห์ ต่อผู้ใช้ที่ active — สะท้อนคุณค่าหลักของผลิตภัณฑ์ (การโฟกัสที่ยั่งยืน) ตรงที่สุด
 
## 32.2 Metric Framework (HEART-inspired)
 
| มิติ | Metric | เป้าหมายเชิงทิศทาง |
| --- | --- | --- |
| Happiness | Post-session satisfaction score (1-5) | เฉลี่ย ≥4.0 |
| Engagement | Sessions/สัปดาห์ต่อ active user | เพิ่มขึ้นต่อเนื่อง 8 สัปดาห์แรก |
| Adoption | % ผู้ใช้ใหม่ที่ทำ session แรกสำเร็จภายใน 24 ชม. | ≥60% |
| Retention | D1 / D7 / D30 retention | D7 ≥35%, D30 ≥15% (benchmark อุตสาหกรรม wellbeing app) |
| Task Success | % override request ที่ resolve ภายใน SLA (ไม่ต้องรอ auto-release) | ≥70% |
 
## 32.3 Business/Health Metrics เพิ่มเติม
 
- Distraction event reduction rate (เทียบ baseline สัปดาห์แรกของผู้ใช้แต่ละคน)
 
- Vault Partner activation rate (% ผู้ใช้ที่เชิญ partner สำเร็จ)
 
- Streak median length
 
- Crash-free session rate (เป้าหมาย ≥99.5%)
 
- Sync success rate / conflict rate
 
# 33. Analytics Events
 
## 33.1 Event Taxonomy (ตัวอย่างหลัก)
 
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
 
vault_invite_sent
vault_invite_accepted
vault_override_requested         { app_package_id, has_reason }
vault_override_resolved          { outcome: approved|denied|auto_released, resolution_time_sec }
vault_partnership_revoked
 
streak_incremented               { streak_count }
streak_broken                    { previous_streak }
 
emergency_override_used          { monthly_count_so_far }
 
ai_coach_message_sent
ai_coach_insight_shown           { insight_type }
 
app_backgrounded
app_foregrounded
sync_completed                   { records_pushed, records_pulled, conflicts }
 
## 33.2 หลักการ
 
- ทุก event ยึด naming convention noun_verb_past-tense เพื่อ query ง่ายและสม่ำเสมอ
 
- ไม่เก็บ PII ใน event property (ใช้ user_id แบบ hashed เชื่อมกับ profile แยกต่างหาก)
 
- Event หมวด behavioral (friction, vault, streak) ต้องมี timestamp ระดับ millisecond เพื่อวิเคราะห์ latency ของ decision moment ได้แม่นยำ
 
# 34. Monetization Strategy
 
## 34.1 สถานะปัจจุบัน — ฟรีทั้งหมด (No Monetization ใน MVP)
 
ตามที่กำหนดขอบเขต เวอร์ชัน 1.0 **ไม่มีแผนสร้างรายได้** ทุกฟีเจอร์เปิดให้ใช้งานฟรีทั้งหมด เพื่อมุ่งเน้นการพิสูจน์คุณค่าผลิตภัณฑ์ (product-market fit) และสร้างฐานผู้ใช้ที่มีพฤติกรรมเปลี่ยนแปลงจริงก่อน
 
## 34.2 ผลกระทบต่อสถาปัตยกรรม
 
แม้ไม่มี monetization ในตอนนี้ แต่ระบบควรออกแบบ **ไม่ปิดกั้นทางเลือกในอนาคต** โดย: - Database schema ของ users ควรเผื่อ field เช่น tier (default free เพียงค่าเดียวตอนนี้) ไว้เพื่อไม่ต้อง migrate ใหญ่ภายหลัง - ไม่ hard-code สมมติฐาน “ไม่มีการชำระเงิน” ลึกเข้าไปใน business logic ของ core feature (เช่น friction/vault) เพื่อให้ปรับเป็น freemium ได้ในอนาคตโดยไม่ต้อง rewrite
 
## 34.3 ตัวเลือกในอนาคต (สำหรับพิจารณาเมื่อถึงเวลา — ไม่ใช่แผนที่ตัดสินใจแล้ว)
 
| โมเดล | ข้อดี | ข้อควรระวัง |
| --- | --- | --- |
| Freemium (ฟีเจอร์ขั้นสูง เช่น AI Coach เชิงลึก, analytics ประวัติยาว) | รายได้ต่อเนื่อง, ยังคง core value ฟรี | ต้องระวังไม่ทำให้ friction/safety feature กลายเป็นของมีเงื่อนไขทางการเงิน (จะขัดกับ product philosophy) |
| One-time purchase (unlock full) | เข้าใจง่าย ไม่ subscription fatigue | รายได้ไม่ต่อเนื่อง ยากต่อการ fund การพัฒนาต่อ |
| B2B2C (ผ่านองค์กร/มหาวิทยาลัย) | Ticket size ใหญ่กว่า | ต้องสร้าง enterprise mode ใหม่ (นอกขอบเขต v1.0) |
 
**ข้อควรระวังสำคัญ:** ฟีเจอร์ safety-critical อย่าง Emergency Recovery และ Vault Partner ควรคงความฟรี/เข้าถึงได้เสมอแม้ในอนาคตจะมี paywall ในส่วนอื่น เพื่อรักษาความน่าเชื่อถือด้าน ethics ของผลิตภัณฑ์
 
# 35. Growth Strategy
 
## 35.1 ช่วงแรก (Pre-launch → Closed Beta)
 
- สร้าง waitlist ผ่าน landing page เรียบง่าย เน้นสื่อสาร behavioral science angle (ไม่ใช่แค่ “แอปบล็อกมือถือ”)
 
- ร่วมมือกับ content creator/นักจิตวิทยาที่พูดเรื่อง digital wellbeing เพื่อสร้างความน่าเชื่อถือ
 
- Closed beta กับกลุ่มเป้าหมายเฉพาะ (นักศึกษา/developer community) เพื่อเก็บ feedback เชิงลึก
 
## 35.2 หลัง Public Launch
 
- **Referral loop ผ่าน Vault Partner:** การเชิญ Partner เป็นกลไก growth โดยธรรมชาติ (invite-to-use) — ทุกคำเชิญคือโอกาสให้คนใหม่โหลดแอป
 
- **Content marketing:** บทความ/สื่อเกี่ยวกับ dopamine science, focus technique — SEO + shareability
 
- **Community:** พื้นที่ (เช่น Discord/กลุ่มปิด) สำหรับผู้ใช้แลกเปลี่ยนเทคนิค เพิ่ม retention ผ่าน social proof
 
- **App Store Optimization (ASO):** keyword เน้น “focus”, “dopamine detox”, “screen time”, คู่กับ review ที่ดีจาก beta users
 
## 35.3 Metrics ที่ใช้วัด Growth
 
- Viral coefficient จาก Vault Partner invite
 
- Organic vs referral install ratio
 
- Cost-free acquisition channel effectiveness (content, ASO)
 
# 36. MVP → V1 → V2 → Long-term Roadmap
 
## 36.1 MVP (เป้าหมาย: พิสูจน์ core loop ทำงานได้จริง)
 
- Authentication (email + Google/Apple)
 
- Onboarding + Behavioral Assessment
 
- Focus Session (timer, intention, blocking พื้นฐาน)
 
- Distraction Logging
 
- Streak (non-punishing)
 
- Friction L0-L2 (ยังไม่รวม Vault Partner)
 
- Analytics พื้นฐาน (weekly summary)
 
- Offline-first สำหรับฟีเจอร์ทั้งหมดข้างต้น
 
## 36.2 V1 (Public Launch)
 
- Vault Partner System เต็มรูปแบบ (invite, override request, approval, audit log)
 
- Friction L3-L4
 
- Emergency Recovery
 
- AI Coach เวอร์ชันแรก (insight พื้นฐาน, ยังไม่ chat แบบเต็ม)
 
- Notification architecture เต็มรูปแบบ
 
- Analytics dashboard เต็มรูปแบบ (Dopamine Load Index)
 
## 36.3 V2
 
- AI Coach แบบ conversational เต็มรูปแบบ
 
- Personalization ขั้นสูง (adaptive friction ที่เรียนรู้จาก pattern จริง)
 
- Multi-partner support (approval rule แบบ any/all)
 
- Export/Report ขั้นสูง (PDF พร้อม insight)
 
- Localization เพิ่มภาษา
 
## 36.4 Long-term
 
- Web Dashboard (ดูหมวด 38)
 
- Integrations (calendar, task manager เช่น Notion/Todoist เพื่อผูก focus session กับงานจริง)
 
- Enterprise/Team mode (สำหรับองค์กร/มหาวิทยาลัย)
 
- Wearable integration (Apple Watch/Wear OS สำหรับเริ่ม session และดู streak)
 
- พิจารณา monetization model (ดูหมวด 34.3)
 
# 37. Development Timeline
 
Timeline เป็นแผนระดับ indicative โดยประมาณ สำหรับทีมขนาดเล็ก (Flutter dev 2, Backend dev 2, Product/Design 1, QA 1 แบบ part-time) — ควรปรับตามขนาดทีมจริงเมื่อ kick off
 
| ระยะ | ระยะเวลา (สัปดาห์) | เนื้อหาหลัก |
| --- | --- | --- |
| Research & UX | 1-4 | User research, persona validation, wireframe, design system |
| Architecture Setup | 3-5 (คาบเกี่ยวกับ UX) | Monorepo setup, CI/CD skeleton, DB schema, API contract |
| MVP Development | 6-14 | Auth, Onboarding, Focus Session, Friction L0-L2, Offline-first, Analytics พื้นฐาน |
| Internal QA & Polish | 15-16 | Bug fix, performance, accessibility audit |
| Closed Beta | 17-20 | จำกัดผู้ใช้ 100-300 คน, เก็บ feedback, iterate |
| V1 Development (Vault Partner, Friction L3-L4, Emergency Recovery) | 21-28 | ตามหมวด 36.2 |
| Public Launch Prep | 29-30 | ASO, marketing asset, staged rollout setup |
| **Public Launch** | สัปดาห์ 31 |  |
| V2 iterations | 32+ | ตาม roadmap หมวด 36.3 แบบ continuous |
 
# 38. Future Web Platform Strategy
 
## 38.1 เหตุผลที่ไม่ทำเว็บใน v1.0
 
Core value ของผลิตภัณฑ์ (friction ระหว่างใช้มือถือ, app blocking) ผูกกับ mobile OS โดยธรรมชาติ — เว็บแพลตฟอร์มไม่ได้เพิ่มคุณค่าหลักในช่วงแรก และจะเพิ่ม scope/ความซับซ้อนโดยไม่จำเป็นต่อการพิสูจน์ product-market fit
 
## 38.2 บทบาทของเว็บในอนาคต
 
เว็บจะไม่ใช่ “แอปคู่ขนาน” เต็มรูปแบบ แต่เป็น **Companion Dashboard** เน้น: - การดูข้อมูล analytics เชิงลึกที่หน้าจอใหญ่กว่าเหมาะกว่า (กราฟ, trend ยาว) - การจัดการ Vault Partner สำหรับผู้ที่สะดวกทำงานผ่านคอมพิวเตอร์ - Export/report สำหรับใช้งานร่วมกับเครื่องมืออื่น (เช่น แนบรายงานความคืบหน้าส่งโค้ช/therapist) - Landing page + marketing site (แยกจาก dashboard)
 
## 38.3 แนวทางเทคนิคที่แนะนำเมื่อถึงเวลา
 
- ใช้ **Next.js** (React) เพื่อ reuse ทีม frontend/TypeScript ที่คุ้นเคยจาก backend NestJS อยู่แล้ว
 
- Reuse packages/api-contracts เดิมจาก monorepo (หมวด 28) เพื่อไม่ต้องเขียน API client ใหม่
 
- ไม่ทำ real-time app blocking ผ่านเว็บ (เป็นไปไม่ได้ทางเทคนิคใน browser sandbox) — เว็บทำหน้าที่เป็น read/manage layer เท่านั้น ไม่ใช่ enforcement layer
 
*จบเอกสาร PRD เวอร์ชัน 1.0 — เอกสารนี้เป็น living document ควรทบทวนและอัปเดตทุกสิ้น sprint/phase สำคัญ ร่วมกับทีม Product, Design, Engineering*