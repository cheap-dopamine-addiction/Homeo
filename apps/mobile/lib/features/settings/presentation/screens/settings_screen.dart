import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homeo/app/router/app_routes.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/utils/localized_text.dart';
import 'package:homeo/features/analytics/presentation/widgets/export_flow.dart';
import 'package:homeo/features/friction/data/friction_repository.dart';
import 'package:homeo/features/friction/data/partner_gateway.dart';
import 'package:homeo/features/friction/domain/app_catalog.dart';
import 'package:homeo/features/friction/domain/blocked_app.dart';
import 'package:homeo/features/friction/domain/friction_level.dart';
import 'package:homeo/features/friction/presentation/providers/friction_providers.dart';
import 'package:homeo/features/settings/data/settings_repository.dart';
import 'package:homeo/features/settings/domain/user_settings.dart';
import 'package:homeo/features/settings/presentation/providers/preferences_controller.dart';
import 'package:homeo/features/settings/presentation/widgets/settings_sheets.dart';
import 'package:homeo/shared/widgets/app_ui.dart';

/// Settings tab (design: `SettingsScreen.tsx`). Friction level and the
/// app block list are wired to the real local DB; theme, notification
/// toggles and quiet hours persist in [AppPreferences].
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final prefs = ref.watch(preferencesProvider);
    final prefsCtl = ref.read(preferencesProvider.notifier);

    final name = prefs.profileName.isEmpty
        ? context.tx('ผู้ใช้ Homeo', 'Homeo user')
        : prefs.profileName;
    final email = prefs.email.isEmpty
        ? context.tx('ยังไม่ได้เพิ่มอีเมล', 'No email added')
        : prefs.email;
    final phone = prefs.phone.isEmpty
        ? context.tx('ยังไม่ได้เพิ่ม', 'Not added')
        : prefs.phone;

    void soon() => showToast(context, context.tx('เร็ว ๆ นี้', 'Coming soon'));
    void noAccount() => showToast(
      context,
      context.tx(
        'ระบบบัญชียังไม่เปิดใช้ในเวอร์ชันนี้',
        'Accounts are not available in this version yet',
      ),
    );

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Text(
            'Settings',
            style: text.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),

          // ── Account ──
          const _Section('Account'),
          _CardBox(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: c.primarySoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: c.primary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: text.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          email,
                          style: text.bodySmall?.copyWith(color: c.inkMuted),
                        ),
                      ],
                    ),
                  ),
                  SoftButton(
                    label: context.tx('แก้ไข', 'Edit'),
                    height: 40,
                    onPressed: () => showEditProfileSheet(context),
                  ),
                ],
              ),
            ),
          ),
          _CardBox(
            child: Column(
              children: [
                _Row(
                  icon: Icons.person_outline_rounded,
                  label: context.tx('ชื่อ-นามสกุล', 'Full name'),
                  sub: name,
                  onPress: () => showEditProfileSheet(context),
                ),
                _Row(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: context.tx('อีเมล', 'Email'),
                  sub: email,
                  onPress: () => showEditProfileSheet(context),
                ),
                _Row(
                  icon: Icons.notifications_none_rounded,
                  label: context.tx('เบอร์โทรศัพท์', 'Phone'),
                  sub: phone,
                  onPress: () => showEditProfileSheet(context),
                  last: true,
                ),
              ],
            ),
          ),

          // ── Interventions ──
          const _Section('Interventions'),
          const _BlockListCard(),
          const _FrictionLevelCard(),
          _CardBox(
            child: Column(
              children: [
                _Row(
                  icon: Icons.tune_rounded,
                  label: context.tx(
                    'Friction และแอปที่ระวัง',
                    'Friction and watched apps',
                  ),
                  sub: context.tx(
                    'ตั้งระดับรายแอปและโควต้าฉุกเฉิน',
                    'Per-app levels and emergency quota',
                  ),
                  onPress: () => context.push(AppRoutes.frictionSettings),
                ),
                _Row(
                  icon: Icons.notifications_active_outlined,
                  label: context.tx(
                    'การตรวจจับและแจ้งเตือน',
                    'Detection and notifications',
                  ),
                  sub: context.tx(
                    'สิทธิ์ที่ต้องเปิดเพื่อให้แจ้งเตือนเมื่อเปิดแอป',
                    'Permissions needed for app-open warnings',
                  ),
                  onPress: () => context.push(AppRoutes.detectionSettings),
                  last: true,
                ),
              ],
            ),
          ),

          // ── Notifications ──
          const _Section('Notifications'),
          _CardBox(
            child: Column(
              children: [
                _Row(
                  icon: Icons.schedule_rounded,
                  label: 'Session Reminder',
                  sub: context.tx('ทุกวัน 09:00', 'Every day 09:00'),
                  right: HomeoToggle(
                    on: prefs.sessionReminder,
                    semanticLabel: 'Session Reminder',
                    onChanged: (v) =>
                        prefsCtl.update((p) => p.copyWith(sessionReminder: v)),
                  ),
                ),
                _Row(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Session Complete',
                  right: HomeoToggle(
                    on: prefs.sessionComplete,
                    semanticLabel: 'Session Complete',
                    onChanged: (v) =>
                        prefsCtl.update((p) => p.copyWith(sessionComplete: v)),
                  ),
                ),
                _Row(
                  icon: Icons.group_outlined,
                  label: 'Partner',
                  right: HomeoToggle(
                    on: prefs.partnerNotif,
                    semanticLabel: 'Partner',
                    onChanged: (v) =>
                        prefsCtl.update((p) => p.copyWith(partnerNotif: v)),
                  ),
                ),
                _Row(
                  icon: Icons.nightlight_outlined,
                  label: 'Quiet Hours',
                  sub: prefs.quietEnabled
                      ? '${prefs.quietStart}–${prefs.quietEnd}'
                      : context.tx('ปิดอยู่', 'Off'),
                  onPress: () => showQuietHoursSheet(context),
                  last: true,
                ),
              ],
            ),
          ),

          // ── Privacy & Data ──
          const _Section('Privacy & Data'),
          _CardBox(
            child: Column(
              children: [
                _Row(
                  icon: Icons.upload_rounded,
                  label: 'Export My Data',
                  sub: 'CSV · JSON · Markdown',
                  onPress: () => showExportFlow(context),
                ),
                _Row(
                  icon: Icons.link_rounded,
                  label: 'Privacy Policy',
                  onPress: soon,
                  last: true,
                ),
              ],
            ),
          ),

          // ── Appearance ──
          const _Section('Appearance'),
          _CardBox(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  for (final o in [
                    (
                      'light',
                      Icons.light_mode_outlined,
                      'Light',
                      'สว่างตลอดเวลา',
                      'Always light',
                    ),
                    (
                      'dark',
                      Icons.nightlight_outlined,
                      'Dark',
                      'มืดตลอดเวลา',
                      'Always dark',
                    ),
                    (
                      'auto',
                      Icons.brightness_auto_outlined,
                      'Auto',
                      'ตามระบบ',
                      'Follow system',
                    ),
                  ])
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _ThemeTile(
                          icon: o.$2,
                          label: o.$3,
                          desc: context.tx(o.$4, o.$5),
                          selected: prefs.themeMode == o.$1,
                          onTap: () => prefsCtl.update(
                            (p) => p.copyWith(themeMode: o.$1),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Vault Partner ──
          const _Section('Vault Partner'),
          _CardBox(
            child: Column(
              children: [
                _Row(
                  icon: Icons.group_outlined,
                  label: context.tx('เชิญ Partner', 'Invite Partner'),
                  sub: context.tx('แชร์ความรับผิดชอบ', 'Share accountability'),
                  onPress: () => showVaultInviteFlow(context),
                ),
                _Row(
                  icon: Icons.shield_outlined,
                  label: context.tx('จัดการ Partners', 'Manage Partners'),
                  onPress: () => showVaultManageSheet(context),
                  last: true,
                ),
              ],
            ),
          ),

          // ── About ──
          const _Section('About'),
          _CardBox(
            child: Column(
              children: [
                _Row(
                  icon: Icons.shield_outlined,
                  label: 'Homeo v1.0.0',
                  sub: context.tx('เวอร์ชันปัจจุบัน', 'Current version'),
                ),
                _Row(
                  icon: Icons.help_outline_rounded,
                  label: 'Support',
                  onPress: soon,
                  last: true,
                ),
              ],
            ),
          ),

          // ── Danger zone ──
          const SizedBox(height: 12),
          _CardBox(
            child: Column(
              children: [
                _Row(
                  icon: Icons.logout_rounded,
                  label: context.tx('ออกจากระบบ', 'Sign out'),
                  onPress: noAccount,
                  danger: true,
                ),
                _Row(
                  icon: Icons.delete_outline_rounded,
                  label: context.tx('ลบบัญชี', 'Delete account'),
                  sub: context.tx(
                    'ข้อมูลทั้งหมดจะถูกลบถาวร',
                    'All data will be permanently deleted',
                  ),
                  onPress: noAccount,
                  danger: true,
                  last: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shield_outlined, size: 13, color: c.inkSubtle),
                    const SizedBox(width: 6),
                    Text(
                      'Homeo v1.0.0',
                      style: text.labelSmall?.copyWith(color: c.inkSubtle),
                    ),
                  ],
                ),
                Text(
                  context.tx(
                    'ความเป็นส่วนตัวคือสิทธิ์ของคุณ',
                    'Privacy is your right',
                  ),
                  style: text.labelSmall?.copyWith(color: c.inkSubtle),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
    child: SectionLabel(title),
  );
}

class _CardBox extends StatelessWidget {
  const _CardBox({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border, width: 1.5),
      ),
      child: child,
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.label,
    this.sub,
    this.right,
    this.onPress,
    this.danger = false,
    this.last = false,
  });

  final IconData icon;
  final String label;
  final String? sub;
  final Widget? right;
  final VoidCallback? onPress;
  final bool danger;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final tint = danger ? c.danger : c.primary;

    final content = Container(
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: last ? null : Border(bottom: BorderSide(color: c.rule)),
      ),
      child: Row(
        children: [
          IconTile(
            icon: icon,
            background: danger ? c.dangerSoft : c.primarySoft,
            color: tint,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: text.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: danger ? c.danger : c.ink,
                  ),
                ),
                if (sub != null)
                  Text(
                    sub!,
                    style: text.bodySmall?.copyWith(color: c.inkMuted),
                  ),
              ],
            ),
          ),
          if (right != null)
            right!
          else if (onPress != null)
            Icon(Icons.chevron_right_rounded, color: c.inkFaint),
        ],
      ),
    );

    if (right != null && onPress == null) return content;
    return InkWell(onTap: onPress, child: content);
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({
    required this.icon,
    required this.label,
    required this.desc,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String desc;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected ? c.primarySoft : c.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? c.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Icon(icon, size: 22, color: selected ? c.primary : c.inkMuted),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: text.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: selected ? c.primaryText : c.ink,
                  ),
                ),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: text.labelSmall?.copyWith(
                    fontSize: 10,
                    color: c.inkMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── App block list (wired to blocked_apps) ─────────────────────────────────

class _BlockListCard extends ConsumerStatefulWidget {
  const _BlockListCard();

  @override
  ConsumerState<_BlockListCard> createState() => _BlockListCardState();
}

class _BlockListCardState extends ConsumerState<_BlockListCard> {
  /// Package ids shown in the list, so a row stays visible after its switch is
  /// turned off (otherwise it would vanish and could not be turned back on).
  final Set<String> _shown = {};
  static const _defaultKeys = ['instagram', 'youtube', 'tiktok'];

  List<CatalogApp> _visible(List<BlockedApp> blocked) {
    final ids = {..._shown, for (final b in blocked) b.appPackageId};
    final apps = <CatalogApp>[];
    for (final key in _defaultKeys) {
      final a = AppCatalog.byKey(key);
      if (a != null) apps.add(a);
    }
    for (final a in AppCatalog.apps) {
      if (ids.contains(a.packageId) && !apps.contains(a)) apps.add(a);
    }
    return apps;
  }

  Future<void> _toggle(CatalogApp app, bool on, FrictionLevel level) async {
    final repo = ref.read(frictionRepositoryProvider);
    if (on) {
      await repo.setBlockedApp(
        BlockedApp(appPackageId: app.packageId, level: level),
      );
    } else {
      await repo.removeBlockedApp(app.packageId);
    }
  }

  Future<void> _addApp(List<BlockedApp> blocked, FrictionLevel level) async {
    final shown = _visible(blocked);
    final remaining = [
      for (final a in AppCatalog.apps)
        if (!shown.contains(a)) a,
    ];
    final picked = await showHomeoSheet<CatalogApp>(
      context,
      (ctx) => SheetFrame(
        title: ctx.tx('เพิ่มแอป', 'Add app'),
        onClose: () => Navigator.of(ctx).pop(),
        children: [
          if (remaining.isEmpty)
            Text(ctx.tx('เพิ่มครบทุกแอปแล้ว', 'Every app is already added')),
          for (final a in remaining)
            ListTile(
              leading: AppBadge(name: a.displayName, color: a.brand, size: 36),
              title: Text(a.displayName),
              onTap: () => Navigator.of(ctx).pop(a),
            ),
        ],
      ),
    );
    if (picked == null) return;
    setState(() => _shown.add(picked.packageId));
    await _toggle(picked, true, level);
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final blocked =
        ref.watch(blockedAppsProvider).value ?? const <BlockedApp>[];
    final settings =
        ref.watch(userSettingsProvider).value ?? UserSettings.defaults;
    final apps = _visible(blocked);

    return _CardBox(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Block List',
                    style: text.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    context.tx(
                      'แอปที่ Homeo จะช่วยเพิ่ม friction ก่อนเปิด',
                      'Apps Homeo adds friction to before they open',
                    ),
                    style: text.bodySmall?.copyWith(color: c.inkMuted),
                  ),
                ],
              ),
            ),
          ),
          for (final app in apps)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: c.rule)),
              ),
              child: Row(
                children: [
                  AppBadge(name: app.displayName, color: app.brand, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      app.displayName,
                      style: text.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  HomeoToggle(
                    on: blocked.any((b) => b.appPackageId == app.packageId),
                    semanticLabel: app.displayName,
                    onChanged: (v) {
                      setState(() => _shown.add(app.packageId));
                      _toggle(app, v, settings.defaultFrictionLevel);
                    },
                  ),
                ],
              ),
            ),
          InkWell(
            onTap: () => _addApp(blocked, settings.defaultFrictionLevel),
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: c.rule)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: c.primarySoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.add_rounded, color: c.primary),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    context.tx('เพิ่มแอป', 'Add app'),
                    style: text.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: c.primaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Friction level (wired to user_settings.default_friction_level) ────────

class _FrictionLevelCard extends ConsumerWidget {
  const _FrictionLevelCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final settings =
        ref.watch(userSettingsProvider).value ?? UserSettings.defaults;
    final hasPartner = ref.watch(partnerGatewayProvider).hasPartner;

    final levels = <(String, String, String, String, String)>[
      ('L0', 'Awareness', 'แค่แบนเนอร์เตือน', 'Just a reminder banner', ''),
      ('L1', 'Micro-Friction', 'ยืนยันก่อนเปิด', 'Confirm before opening', ''),
      ('L2', 'Reflective Pause', 'หยุดคิดก่อน', 'Stop and think first', ''),
      ('L3', 'Full Block', 'บล็อกในช่วง Focus', 'Blocked during focus', ''),
      (
        'L4',
        'Partner-Gated',
        'ต้องมี Partner อนุมัติ',
        'Needs Partner approval',
        '',
      ),
    ];

    return _CardBox(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Friction Level',
                    style: text.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    context.tx(
                      'ระดับการปกป้องช่วงโฟกัส',
                      'How strongly focus time is protected',
                    ),
                    style: text.bodySmall?.copyWith(color: c.inkMuted),
                  ),
                ],
              ),
            ),
          ),
          for (var i = 0; i < levels.length; i++)
            Builder(
              builder: (context) {
                final f = levels[i];
                final selected = settings.defaultFrictionLevel.code == i;
                final enabled = i != 4 || hasPartner;
                return Semantics(
                  button: true,
                  selected: selected,
                  enabled: enabled,
                  child: InkWell(
                    onTap: enabled
                        ? () => ref
                              .read(settingsRepositoryProvider)
                              .save(
                                settings.copyWith(
                                  defaultFrictionLevel: FrictionLevel.fromCode(
                                    i,
                                  ),
                                ),
                              )
                        : null,
                    child: Opacity(
                      opacity: enabled ? 1 : 0.6,
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 60),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        color: selected ? c.primarySoft : null,
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selected ? c.surface : c.surfaceAlt,
                                borderRadius: BorderRadius.circular(10),
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
                                    f.$2,
                                    style: text.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: selected ? c.primaryText : c.ink,
                                    ),
                                  ),
                                  Text(
                                    enabled
                                        ? context.tx(f.$3, f.$4)
                                        : context.tx(
                                            'ใช้ได้เมื่อเชื่อมต่อ Vault Partner',
                                            'Available once you connect a Vault Partner',
                                          ),
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
        ],
      ),
    );
  }
}
