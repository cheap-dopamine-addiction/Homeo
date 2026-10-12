import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/utils/localized_text.dart';
import 'package:homeo/features/friction/domain/app_catalog.dart';
import 'package:homeo/features/onboarding/presentation/providers/onboarding_controller.dart';
import 'package:homeo/shared/widgets/app_ui.dart';

/// First-launch flow (design: `Onboarding.tsx`): welcome → triggers → goal →
/// apps → friction level → permissions. Step 0 has no progress dots; steps
/// 1–5 show 5 dots.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(onboardingControllerProvider);
    final c = AppColors.of(context);

    return PopScope(
      canPop: flow.step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) ref.read(onboardingControllerProvider.notifier).back();
      },
      child: Scaffold(
        backgroundColor: c.canvas,
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: KeyedSubtree(
              key: ValueKey(flow.step),
              child: switch (flow.step) {
                OnboardingSteps.welcome => const _WelcomeStep(),
                OnboardingSteps.triggers => const _TriggersStep(),
                OnboardingSteps.goal => const _GoalStep(),
                OnboardingSteps.apps => const _AppsStep(),
                OnboardingSteps.friction => const _FrictionStep(),
                _ => const _PermissionsStep(),
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ── shared pieces ──────────────────────────────────────────────────────────

class _TopBar extends ConsumerWidget {
  const _TopBar({required this.dot, this.showSkip = true});

  /// 0-based index of the active dot (5 dots total).
  final int dot;
  final bool showSkip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = AppColors.of(context);
    final ctrl = ref.read(onboardingControllerProvider.notifier);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: ctrl.back,
                style: TextButton.styleFrom(foregroundColor: c.inkMuted),
                child: Text('← ${context.tx('ย้อนกลับ', 'Back')}'),
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < 5; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == dot ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == dot ? c.primary : c.border,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            width: 96,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: showSkip
                  ? TextButton(
                      onPressed: ctrl.next,
                      style: TextButton.styleFrom(foregroundColor: c.inkMuted),
                      child: Text(context.tx('ข้าม', 'Skip')),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.title, this.subtitle, {this.size = 24});

  final String title;
  final String subtitle;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: text.headlineMedium?.copyWith(
              fontSize: size,
              fontWeight: FontWeight.w800,
              color: c.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: text.bodyMedium?.copyWith(color: c.inkMuted)),
        ],
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
    child: GradientButton(label: label, onPressed: onPressed),
  );
}

// ── 0 · welcome ────────────────────────────────────────────────────────────

class _WelcomeStep extends ConsumerWidget {
  const _WelcomeStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final ctrl = ref.read(onboardingControllerProvider.notifier);

    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: _Glow(color: c.primary, size: 280),
        ),
        Positioned(
          bottom: 40,
          left: -100,
          child: _Glow(color: c.accent, size: 200),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 24),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.sizeOf(context).height * 0.55,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                c.primarySoft,
                                c.primary.withValues(alpha: 0.35),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: c.primary.withValues(alpha: 0.18),
                                blurRadius: 32,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.home_rounded,
                            size: 48,
                            color: c.primary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Homeo',
                          style: text.displayLarge?.copyWith(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: c.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          context.tx(
                            'ยินดีต้อนรับสู่ Homeo',
                            'Welcome to Homeo',
                          ),
                          textAlign: TextAlign.center,
                          style: text.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: c.ink,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 280),
                          child: Text(
                            context.tx(
                              'Homeo ช่วยให้คุณโฟกัสได้ง่ายขึ้น โดยไม่ตัดสินหรือบังคับคุณ',
                              'Homeo helps you focus more easily — without judging or forcing you.',
                            ),
                            textAlign: TextAlign.center,
                            style: text.bodyLarge?.copyWith(
                              color: c.inkMuted,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.tx(
                            'คุณยังคงควบคุมทุกอย่างได้เสมอ',
                            'You stay in control of everything.',
                          ),
                          textAlign: TextAlign.center,
                          style: text.bodyMedium?.copyWith(
                            color: c.inkSubtle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GradientButton(
                label: context.tx('เริ่มกันเลย', "Let's start"),
                onPressed: ctrl.next,
              ),
              const SizedBox(height: 12),
              Text(
                context.tx(
                  'ไม่มีบัญชีก็ใช้ได้ · ไม่แชร์ข้อมูลโดยไม่ขออนุญาต',
                  'Works without an account · Nothing shared without permission',
                ),
                textAlign: TextAlign.center,
                style: text.bodySmall?.copyWith(color: c.inkSubtle),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.18), color.withValues(alpha: 0)],
        ),
      ),
    ),
  );
}

// ── 1 · triggers ───────────────────────────────────────────────────────────

const _triggers = <(String, String, String)>[
  ('bored', 'เบื่อ', 'Bored'),
  ('stressed', 'เครียด', 'Stressed'),
  ('nothing', 'ไม่มีอะไรทำ', 'Nothing to do'),
  ('public', 'อยู่ที่สาธารณะและอยู่ไม่ถูก', 'Out in public and uneasy'),
  ('avoid', 'หนีงาน', 'Avoiding work'),
  ('curious', 'อยากลอง', 'Just curious'),
  ('unsure', 'ไม่แน่ใจ', 'Not sure'),
];

class _TriggersStep extends ConsumerWidget {
  const _TriggersStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(onboardingControllerProvider);
    final ctrl = ref.read(onboardingControllerProvider.notifier);
    return Column(
      children: [
        const _TopBar(dot: 0),
        _Heading(
          context.tx(
            'คุณมักจะเปิดมือถือ\nเมื่อรู้สึกอย่างไร?',
            'How do you usually feel\nwhen you pick up your phone?',
          ),
          context.tx('เลือกได้มากกว่าหนึ่งข้อ', 'Pick as many as you like'),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final t in _triggers)
                  PillChoice(
                    label: context.tx(t.$2, t.$3),
                    selected: flow.triggers.contains(t.$1),
                    height: 48,
                    onTap: () => ctrl.toggleTrigger(t.$1),
                  ),
              ],
            ),
          ),
        ),
        _NextButton(
          label: context.tx('ต่อไป', 'Next'),
          onPressed: flow.canProceed ? ctrl.nextIfAllowed : null,
        ),
      ],
    );
  }
}

// ── 2 · goal ───────────────────────────────────────────────────────────────

const _goals = <(String, String, String, IconData)>[
  ('read', 'อ่านหนังสือได้นานขึ้น', 'Read for longer', Icons.menu_book_outlined),
  ('work', 'ทำงานแบบมีสมาธิ', 'Work with focus', Icons.work_outline_rounded),
  ('social', 'ลดเวลาบนโซเชียล', 'Spend less time on social', Icons.smartphone_rounded),
  ('create', 'งานสร้างสรรค์', 'Creative work', Icons.palette_outlined),
  ('other', 'อื่น ๆ', 'Something else', Icons.star_outline_rounded),
];

class _GoalStep extends ConsumerWidget {
  const _GoalStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(onboardingControllerProvider);
    final ctrl = ref.read(onboardingControllerProvider.notifier);
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;

    return Column(
      children: [
        const _TopBar(dot: 1),
        _Heading(
          context.tx(
            'อยากโฟกัสเรื่องไหน\nเป็นพิเศษ?',
            'What do you want to\nfocus on most?',
          ),
          context.tx('เปลี่ยนได้ทุกเมื่อ', 'You can change this any time'),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _goals.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final g = _goals[i];
              final selected = flow.goal == g.$1;
              return Semantics(
                button: true,
                selected: selected,
                child: Material(
                  color: selected ? c.primary : c.surface,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => ctrl.selectGoal(g.$1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: selected
                            ? null
                            : Border.all(color: c.border, width: 2),
                      ),
                      child: Row(
                        children: [
                          IconTile(
                            icon: g.$4,
                            size: 40,
                            iconSize: 20,
                            radius: 12,
                            background: selected
                                ? Colors.white.withValues(alpha: 0.2)
                                : c.primarySoft,
                            color: selected ? c.onPrimary : c.primary,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              context.tx(g.$2, g.$3),
                              style: text.titleSmall?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: selected ? c.onPrimary : c.ink,
                              ),
                            ),
                          ),
                          if (selected)
                            Icon(Icons.check_rounded, color: c.onPrimary),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        _NextButton(
          label: context.tx('ต่อไป', 'Next'),
          onPressed: flow.canProceed ? ctrl.nextIfAllowed : null,
        ),
      ],
    );
  }
}

// ── 3 · apps ───────────────────────────────────────────────────────────────

class _AppsStep extends ConsumerStatefulWidget {
  const _AppsStep();

  @override
  ConsumerState<_AppsStep> createState() => _AppsStepState();
}

class _AppsStepState extends ConsumerState<_AppsStep> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flow = ref.watch(onboardingControllerProvider);
    final ctrl = ref.read(onboardingControllerProvider.notifier);
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;

    final query = _search.text.trim().toLowerCase();
    final apps = [
      for (final a in AppCatalog.apps)
        if (query.isEmpty || a.displayName.toLowerCase().contains(query)) a,
    ];

    return Column(
      children: [
        const _TopBar(dot: 2),
        _Heading(
          context.tx('แอปไหนที่ดึงความสนใจ?', 'Which apps pull your attention?'),
          context.tx(
            'Homeo จะช่วยเพิ่ม friction ก่อนเปิดแอปที่กำหนด',
            'Homeo adds friction before you open the apps you choose',
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: context.tx('ค้นหาแอป...', 'Search apps...'),
              prefixIcon: const Icon(Icons.search_rounded),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 8,
              childAspectRatio: 0.78,
            ),
            itemCount: apps.length,
            itemBuilder: (context, i) {
              final app = apps[i];
              final selected = flow.apps.contains(app.key);
              return Semantics(
                button: true,
                selected: selected,
                label: app.displayName,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => ctrl.toggleApp(app.key),
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(19),
                              border: Border.all(
                                color: selected
                                    ? c.primary
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: AppBadge(
                              name: app.displayName,
                              color: app.brand,
                              size: 56,
                            ),
                          ),
                          if (selected)
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: c.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check_rounded,
                                  size: 12,
                                  color: c.onPrimary,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        app.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.labelSmall?.copyWith(color: c.inkMuted),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        _NextButton(
          label: flow.apps.isNotEmpty
              ? context.tx(
                  'เลือก ${flow.apps.length} แอปแล้ว — ต่อไป',
                  '${flow.apps.length} selected — Next',
                )
              : context.tx('ต่อไปโดยไม่เลือก', 'Continue without picking'),
          onPressed: ctrl.next,
        ),
      ],
    );
  }
}

// ── 4 · friction level ─────────────────────────────────────────────────────

const _frictionOptions = <(String, String, String, String, String)>[
  ('L0', 'เบาๆ', 'Gentle', 'แค่ช่วยเตือนเมื่อคุณเริ่มหลุดโฟกัส', 'Just a nudge when you start to drift'),
  ('L1', 'ช่วยหยุดสักครู่', 'A short pause', 'ให้เวลาคุณคิดก่อนเปิด', 'A moment to think before opening'),
  ('L2', 'ช่วยให้หยุดคิด', 'Stop and think', 'เพิ่มช่วงสะท้อนก่อนเปิด', 'A reflective step before opening'),
  ('L3', 'ปกป้องจริงจัง', 'Serious protection', 'บล็อกในช่วง Focus', 'Blocked during focus sessions'),
  ('L4', 'ปกป้องร่วมกับ Partner', 'Protected with a partner', 'ต้องมีขั้นตอนเพิ่มเติมในการปลดบล็อก', 'Extra steps needed to unblock'),
];

class _FrictionStep extends ConsumerWidget {
  const _FrictionStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(onboardingControllerProvider);
    final ctrl = ref.read(onboardingControllerProvider.notifier);
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;

    return Column(
      children: [
        const _TopBar(dot: 3),
        _Heading(
          context.tx(
            'คุณต้องการให้ Homeo ช่วยปกป้องช่วงโฟกัสมากแค่ไหน?',
            'How much should Homeo protect your focus time?',
          ),
          context.tx(
            'เปลี่ยนได้ในภายหลังที่ Settings',
            'You can change this later in Settings',
          ),
          size: 22,
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _frictionOptions.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final f = _frictionOptions[i];
              final selected = flow.friction == i;
              return Semantics(
                button: true,
                selected: selected,
                child: Material(
                  color: selected ? c.primarySoft : c.surface,
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => ctrl.selectFriction(i),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: selected ? c.primary : c.border,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selected ? c.surface : c.surfaceAlt,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              f.$1,
                              style: text.labelSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: selected ? c.primary : c.inkMuted,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tx(f.$2, f.$3),
                                  style: text.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: selected ? c.primary : c.ink,
                                  ),
                                ),
                                Text(
                                  context.tx(f.$4, f.$5),
                                  style: text.bodySmall?.copyWith(
                                    color: c.inkMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (selected)
                            Icon(Icons.check_rounded, color: c.primary),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        _NextButton(
          label: context.tx('ต่อไป', 'Next'),
          onPressed: ctrl.next,
        ),
      ],
    );
  }
}

// ── 5 · permissions ────────────────────────────────────────────────────────

class _PermissionsStep extends ConsumerWidget {
  const _PermissionsStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(onboardingControllerProvider);
    final ctrl = ref.read(onboardingControllerProvider.notifier);
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;

    // The Android build detects opened apps with an Accessibility service
    // (name only, never screen content) — not Usage Access as in the design
    // mock-up — so the card describes what the app really asks for.
    final items = [
      (
        Icons.bar_chart_rounded,
        'Accessibility Service',
        context.tx(
          'ดูว่าแอปไหนขึ้นมาอยู่หน้าจอ (ชื่อแอปเท่านั้น)',
          'Sees which app is on screen (app name only)',
        ),
        context.tx(
          'เพื่อตรวจจับและแจ้งเตือนก่อนเปิดแอปที่กำหนด',
          'To detect and warn you when you open watched apps',
        ),
      ),
      (
        Icons.notifications_none_rounded,
        'Notifications',
        context.tx(
          'ส่งการแจ้งเตือน session และ insights',
          'Sends session and insight notifications',
        ),
        context.tx(
          'คุณสามารถปิดได้ทุกเมื่อในการตั้งค่า',
          'You can turn them off any time in Settings',
        ),
      ),
    ];

    return Column(
      children: [
        const _TopBar(dot: 4, showSkip: false),
        _Heading(
          context.tx('Homeo ต้องการ\nสิทธิ์อะไรบ้าง?', 'What permissions\ndoes Homeo need?'),
          context.tx(
            'เราโปร่งใสเสมอ — คุณควบคุมได้ทุกอย่าง',
            "We're always transparent — you stay in control",
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              for (final p in items) ...[
                SoftCard(
                  radius: 20,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconTile(
                        icon: p.$1,
                        size: 48,
                        iconSize: 24,
                        radius: 14,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.$2,
                              style: text.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              p.$3,
                              style: text.bodySmall?.copyWith(
                                color: c.inkMuted,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              p.$4,
                              style: text.labelSmall?.copyWith(
                                color: c.primaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              SoftCard(
                color: c.warnSoft,
                borderColor: c.warn.withValues(alpha: 0.3),
                radius: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: c.warn, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        context.tx(
                          'บนบางอุปกรณ์หรือระบบปฏิบัติการ บางฟีเจอร์อาจทำงานต่างกัน Homeo จะอธิบายข้อจำกัดเหล่านี้เสมอ',
                          'On some devices or operating systems a few features behave differently. Homeo will always explain the limits.',
                        ),
                        style: text.bodySmall?.copyWith(color: c.onWarnSoft),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: GradientButton(
            label: context.tx('เริ่มใช้ Homeo', 'Start using Homeo'),
            onPressed: flow.finishing
                ? null
                : () => ctrl.finish(askPermissions: true),
          ),
        ),
        TextButton(
          onPressed: flow.finishing
              ? null
              : () => ctrl.finish(askPermissions: false),
          style: TextButton.styleFrom(
            foregroundColor: c.inkMuted,
            minimumSize: const Size(48, 48),
          ),
          child: Text(
            context.tx('ข้ามและตั้งค่าทีหลัง', 'Skip and set up later'),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
