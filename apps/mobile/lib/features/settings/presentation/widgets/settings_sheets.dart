import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/utils/localized_text.dart';
import 'package:homeo/features/settings/presentation/providers/preferences_controller.dart';
import 'package:homeo/features/vault_partner/presentation/providers/vault_controller.dart';
import 'package:homeo/shared/widgets/app_ui.dart';
import 'package:intl/intl.dart';

// ── Edit profile ───────────────────────────────────────────────────────────

Future<void> showEditProfileSheet(BuildContext context) =>
    showHomeoSheet<void>(context, (_) => const _EditProfileSheet());

class _EditProfileSheet extends ConsumerStatefulWidget {
  const _EditProfileSheet();

  @override
  ConsumerState<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<_EditProfileSheet> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final String _origName;
  late final String _origEmail;
  late final String _origPhone;

  @override
  void initState() {
    super.initState();
    final p = ref.read(preferencesProvider);
    _origName = p.profileName;
    _origEmail = p.email;
    _origPhone = p.phone;
    _name = TextEditingController(text: p.profileName);
    _email = TextEditingController(text: p.email);
    _phone = TextEditingController(text: p.phone);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  bool get _changed =>
      _name.text != _origName ||
      _email.text != _origEmail ||
      _phone.text != _origPhone;

  Future<void> _save() async {
    if (!_changed) return;
    final messenger = ScaffoldMessenger.of(context);
    final msg = context.tx('อัปเดตโปรไฟล์แล้ว', 'Profile updated');
    await ref
        .read(preferencesProvider.notifier)
        .update(
          (p) => p.copyWith(
            profileName: _name.text.trim(),
            email: _email.text.trim(),
            phone: _phone.text.trim(),
          ),
        );
    if (!mounted) return;
    Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final providers = [
      ('Email / Password', false),
      ('Google', false),
      ('Apple', false),
    ];
    Widget field(String label, TextEditingController ctl, String hint,
        {TextInputType? type}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionLabel(label),
            const SizedBox(height: 6),
            TextField(
              controller: ctl,
              keyboardType: type,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(hintText: hint),
            ),
          ],
        ),
      );
    }

    return SheetFrame(
      title: context.tx('แก้ไขโปรไฟล์', 'Edit profile'),
      onClose: () => Navigator.of(context).pop(),
      children: [
        Text(
          context.tx(
            'อัปเดตข้อมูลส่วนตัวของคุณ',
            'Update your personal details',
          ),
          style: text.bodySmall?.copyWith(color: c.inkMuted),
        ),
        const SizedBox(height: 16),
        field(
          context.tx('ชื่อ-นามสกุล', 'Full name'),
          _name,
          context.tx('ชื่อของคุณ', 'Your name'),
        ),
        field(
          context.tx('อีเมล', 'Email'),
          _email,
          'email@example.com',
          type: TextInputType.emailAddress,
        ),
        field(
          context.tx('เบอร์โทรศัพท์', 'Phone'),
          _phone,
          '+66 8X XXX XXXX',
          type: TextInputType.phone,
        ),
        SectionLabel(context.tx('วิธีลงชื่อเข้าใช้', 'Sign-in methods')),
        const SizedBox(height: 8),
        for (final m in providers)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SoftCard(
              radius: 14,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      m.$1,
                      style: text.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: m.$2 ? c.successSoft : c.surfaceAlt,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      m.$2
                          ? context.tx('เชื่อมต่อแล้ว', 'Connected')
                          : context.tx('ไม่ได้เชื่อมต่อ', 'Not connected'),
                      style: text.labelSmall?.copyWith(
                        color: m.$2 ? c.success : c.inkMuted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        TextButton(
          onPressed: () => showToast(
            context,
            context.tx(
              'ระบบบัญชียังไม่เปิดใช้ในเวอร์ชันนี้',
              'Accounts are not available in this version yet',
            ),
          ),
          child: Text(
            context.tx(
              '+ เพิ่มวิธีลงชื่อเข้าใช้อื่น',
              '+ Add another sign-in method',
            ),
          ),
        ),
        const SizedBox(height: 8),
        GradientButton(
          label: context.tx('บันทึก', 'Save'),
          onPressed: _changed ? _save : null,
        ),
      ],
    );
  }
}

// ── Quiet hours ────────────────────────────────────────────────────────────

Future<void> showQuietHoursSheet(BuildContext context) =>
    showHomeoSheet<void>(context, (_) => const _QuietHoursSheet());

class _QuietHoursSheet extends ConsumerStatefulWidget {
  const _QuietHoursSheet();

  @override
  ConsumerState<_QuietHoursSheet> createState() => _QuietHoursSheetState();
}

class _QuietHoursSheetState extends ConsumerState<_QuietHoursSheet> {
  late bool _enabled;
  late String _start;
  late String _end;
  late bool _focus;
  late bool _override;
  late bool _ai;

  @override
  void initState() {
    super.initState();
    final p = ref.read(preferencesProvider);
    _enabled = p.quietEnabled;
    _start = p.quietStart;
    _end = p.quietEnd;
    _focus = p.quietFocus;
    _override = p.quietOverride;
    _ai = p.quietAi;
  }

  Future<void> _save() async {
    await ref
        .read(preferencesProvider.notifier)
        .update(
          (p) => p.copyWith(
            quietEnabled: _enabled,
            quietStart: _start,
            quietEnd: _end,
            quietFocus: _focus,
            quietOverride: _override,
            quietAi: _ai,
          ),
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;

    Widget toggleRow(String label, bool on, ValueChanged<bool> set) => Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        HomeoToggle(on: on, onChanged: set, semanticLabel: label),
      ],
    );

    return SheetFrame(
      title: context.tx('ชั่วโมงเงียบ', 'Quiet hours'),
      onClose: () => Navigator.of(context).pop(),
      children: [
        Text(
          context.tx(
            'ปิดการแจ้งเตือนในช่วงเวลาที่กำหนด',
            'Silence notifications during set hours',
          ),
          style: text.bodySmall?.copyWith(color: c.inkMuted),
        ),
        const SizedBox(height: 12),
        SoftCard(
          radius: 16,
          padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
          child: toggleRow(
            context.tx('เปิดใช้งาน', 'Enabled'),
            _enabled,
            (v) => setState(() => _enabled = v),
          ),
        ),
        const SizedBox(height: 12),
        Opacity(
          opacity: _enabled ? 1 : 0.4,
          child: IgnorePointer(
            ignoring: !_enabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SectionLabel(context.tx('เวลาเริ่มต้น', 'Start')),
                          const SizedBox(height: 6),
                          _TimeStepper(
                            value: _start,
                            onChanged: (v) => setState(() => _start = v),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          SectionLabel(context.tx('เวลาสิ้นสุด', 'End')),
                          const SizedBox(height: 6),
                          _TimeStepper(
                            value: _end,
                            onChanged: (v) => setState(() => _end = v),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SectionLabel(context.tx('ข้อยกเว้น', 'Exceptions')),
                const SizedBox(height: 4),
                toggleRow(
                  context.tx('การเตือน Focus', 'Focus reminders'),
                  _focus,
                  (v) => setState(() => _focus = v),
                ),
                toggleRow(
                  'Override Requests',
                  _override,
                  (v) => setState(() => _override = v),
                ),
                toggleRow(
                  'AI Coach Insights',
                  _ai,
                  (v) => setState(() => _ai = v),
                ),
                Text(
                  context.tx(
                    'Override requests จะผ่านชั่วโมงเงียบเสมอ',
                    'Override requests always get through quiet hours',
                  ),
                  style: text.bodySmall?.copyWith(color: c.inkSubtle),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        GradientButton(label: context.tx('บันทึก', 'Save'), onPressed: _save),
      ],
    );
  }
}

class _TimeStepper extends StatelessWidget {
  const _TimeStepper({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final parts = value.split(':');
    final h = int.tryParse(parts.first) ?? 0;
    final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

    void adj({int dh = 0, int dm = 0}) {
      final nh = (h + dh + 24) % 24;
      final nm = (m + dm + 60) % 60;
      onChanged(
        '${nh.toString().padLeft(2, '0')}:${nm.toString().padLeft(2, '0')}',
      );
    }

    Widget col(int v, VoidCallback up, VoidCallback down, String name) {
      return Column(
        children: [
          IconButton(
            tooltip: '$name +',
            onPressed: up,
            icon: const Icon(Icons.keyboard_arrow_up_rounded),
            style: IconButton.styleFrom(backgroundColor: c.surfaceAlt),
          ),
          Text(
            v.toString().padLeft(2, '0'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          IconButton(
            tooltip: '$name −',
            onPressed: down,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            style: IconButton.styleFrom(backgroundColor: c.surfaceAlt),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        col(h, () => adj(dh: 1), () => adj(dh: -1), 'h'),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Text(':', style: TextStyle(fontWeight: FontWeight.w800)),
        ),
        col(m, () => adj(dm: 1), () => adj(dm: -1), 'min'),
      ],
    );
  }
}

// ── Vault invite (4 steps) ─────────────────────────────────────────────────

Future<void> showVaultInviteFlow(BuildContext context) =>
    showHomeoSheet<void>(context, (_) => const _VaultInviteFlow());

enum _InviteStep { intro, method, link, email, sent }

class _VaultInviteFlow extends ConsumerStatefulWidget {
  const _VaultInviteFlow();

  @override
  ConsumerState<_VaultInviteFlow> createState() => _VaultInviteFlowState();
}

class _VaultInviteFlowState extends ConsumerState<_VaultInviteFlow> {
  _InviteStep _step = _InviteStep.intro;
  final _email = TextEditingController();
  final _message = TextEditingController();
  bool _copied = false;
  late final String _link;
  DateTime? _sentAt;

  @override
  void initState() {
    super.initState();
    final r = Random.secure();
    final token = [
      for (var i = 0; i < 10; i++) 'abcdefghjkmnpqrstuvwxyz23456789'[r.nextInt(31)],
    ].join();
    _link = 'homeo://vault/invite/$token';
  }

  @override
  void dispose() {
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  String _inviteText() => context.tx(
    'ฉันอยากชวนคุณเป็น Vault Partner ใน Homeo $_link'
        '${_message.text.trim().isEmpty ? '' : '\n\n${_message.text.trim()}'}',
    'I would like you to be my Vault Partner in Homeo: $_link'
        '${_message.text.trim().isEmpty ? '' : '\n\n${_message.text.trim()}'}',
  );

  Future<void> _copyLink() async {
    await Clipboard.setData(ClipboardData(text: _link));
    if (!mounted) return;
    setState(() => _copied = true);
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  Future<void> _finishSend({required String recipient}) async {
    await Clipboard.setData(ClipboardData(text: _inviteText()));
    // Local record only: no invitation backend exists yet.
    ref.read(vaultControllerProvider.notifier).addPending(recipient, const {
      PartnerPermission.focusTime,
    });
    if (!mounted) return;
    setState(() {
      _sentAt = DateTime.now();
      _step = _InviteStep.sent;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    void close() => Navigator.of(context).pop();

    Widget choice(String title, String desc, VoidCallback onTap) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: c.border, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                Text(desc, style: text.bodySmall?.copyWith(color: c.inkMuted)),
              ],
            ),
          ),
        ),
      ),
    );

    switch (_step) {
      case _InviteStep.intro:
        return SheetFrame(
          title: context.tx('แชร์กับ Vault Partner', 'Share with a Vault Partner'),
          onClose: close,
          children: [
            Text(
              context.tx(
                'Vault Partner คือคนที่คุณไว้ใจ — พวกเขาสามารถดูความคืบหน้าของคุณ ส่งข้อความกำลังใจ และช่วยอนุมัติเมื่อจำเป็น',
                'A Vault Partner is someone you trust — they can see your progress, send encouragement and help approve when needed.',
              ),
              style: text.bodyMedium?.copyWith(color: c.inkMuted),
            ),
            const SizedBox(height: 20),
            GradientButton(
              label: context.tx('ต่อไป', 'Next'),
              onPressed: () => setState(() => _step = _InviteStep.method),
            ),
            TextButton(
              onPressed: close,
              child: Text(context.tx('ข้าม', 'Skip')),
            ),
          ],
        );
      case _InviteStep.method:
        return SheetFrame(
          title: context.tx('วิธีเชิญ', 'How to invite'),
          onClose: close,
          children: [
            Text(
              context.tx('เลือกวิธีที่ต้องการ', 'Choose a method'),
              style: text.bodySmall?.copyWith(color: c.inkMuted),
            ),
            const SizedBox(height: 12),
            choice(
              context.tx('แชร์ลิงก์', 'Share a link'),
              context.tx(
                'คัดลอกลิงก์เพื่อส่งให้ผู้อื่น',
                'Copy a link to send to someone',
              ),
              () => setState(() => _step = _InviteStep.link),
            ),
            choice(
              context.tx('เชิญโดยตรง', 'Invite directly'),
              context.tx('เตรียมคำเชิญสำหรับอีเมล', 'Prepare an invitation for an email'),
              () => setState(() => _step = _InviteStep.email),
            ),
          ],
        );
      case _InviteStep.link:
        return SheetFrame(
          title: context.tx('ลิงก์เชิญ', 'Invitation link'),
          onClose: close,
          children: [
            Text(
              context.tx(
                'แชร์ลิงก์นี้กับ Vault Partner ของคุณ',
                'Share this link with your Vault Partner',
              ),
              style: text.bodySmall?.copyWith(color: c.inkMuted),
            ),
            const SizedBox(height: 12),
            SoftCard(
              color: c.surfaceAlt,
              radius: 14,
              child: SelectableText(
                _link,
                style: text.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  color: c.primaryText,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SoftButton(
              label: _copied
                  ? context.tx('คัดลอกแล้ว!', 'Copied!')
                  : context.tx('คัดลอกลิงก์', 'Copy link'),
              height: 52,
              onPressed: _copyLink,
            ),
            const SizedBox(height: 10),
            GradientButton(
              label: context.tx('แชร์ผ่าน...', 'Share via...'),
              onPressed: () => _finishSend(
                recipient: context.tx('ผู้รับ', 'Recipient'),
              ),
            ),
          ],
        );
      case _InviteStep.email:
        final valid = _email.text.contains('@');
        return SheetFrame(
          title: context.tx('เชิญโดยตรง', 'Invite directly'),
          onClose: close,
          children: [
            SectionLabel(context.tx('อีเมล', 'Email')),
            const SizedBox(height: 6),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(hintText: 'partner@example.com'),
            ),
            const SizedBox(height: 12),
            SectionLabel(
              context.tx('ข้อความส่วนตัว (ไม่บังคับ)', 'Personal message (optional)'),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _message,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: context.tx(
                  'เขียนข้อความถึง Partner ของคุณ...',
                  'Write a message to your Partner...',
                ),
              ),
            ),
            const SizedBox(height: 16),
            GradientButton(
              label: context.tx('ส่งคำเชิญ', 'Send invitation'),
              onPressed: valid
                  ? () => _finishSend(recipient: _email.text.trim())
                  : null,
            ),
          ],
        );
      case _InviteStep.sent:
        final recipient = _email.text.trim().isEmpty
            ? context.tx('ผู้รับ', 'Recipient')
            : _email.text.trim();
        return SheetFrame(
          children: [
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: c.successSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_rounded, size: 32, color: c.success),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.tx('เตรียมคำเชิญแล้ว!', 'Invitation ready!'),
              textAlign: TextAlign.center,
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            Text(
              recipient,
              textAlign: TextAlign.center,
              style: text.bodyMedium?.copyWith(color: c.inkMuted),
            ),
            const SizedBox(height: 4),
            Text(
              context.tx(
                'คัดลอกคำเชิญไว้แล้ว — วางส่งให้ผู้รับได้เลย',
                'The invitation is copied — paste it to send',
              ),
              textAlign: TextAlign.center,
              style: text.bodySmall?.copyWith(color: c.inkSubtle),
            ),
            const SizedBox(height: 16),
            SoftCard(
              color: c.surfaceAlt,
              radius: 14,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(context.tx('สถานะ', 'Status'))),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: c.warnSoft,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          context.tx('รอตอบรับ', 'Pending'),
                          style: text.labelSmall?.copyWith(
                            color: c.onWarnSoft,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Text(context.tx('เตรียมเมื่อ', 'Prepared at'))),
                      Text(
                        DateFormat.Hm(locale).format(_sentAt ?? DateTime.now()),
                        style: text.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GradientButton(
              label: context.tx('เสร็จสิ้น', 'Done'),
              onPressed: close,
            ),
          ],
        );
    }
  }
}

// ── Manage partners ────────────────────────────────────────────────────────

Future<void> showVaultManageSheet(BuildContext context) =>
    showHomeoSheet<void>(context, (_) => const _VaultManageSheet());

class _VaultManageSheet extends ConsumerWidget {
  const _VaultManageSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final partners = ref.watch(vaultControllerProvider).partners;

    return SheetFrame(
      title: context.tx('จัดการ Partners', 'Manage Partners'),
      onClose: () => Navigator.of(context).pop(),
      children: [
        Text(
          context.tx(
            'ดูและจัดการ Vault Partners ทั้งหมดของคุณ',
            'See and manage all of your Vault Partners',
          ),
          style: text.bodySmall?.copyWith(color: c.inkMuted),
        ),
        const SizedBox(height: 12),
        if (partners.isEmpty)
          SoftCard(
            color: c.surfaceAlt,
            child: Row(
              children: [
                const IconTile(icon: Icons.group_outlined, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tx('ยังไม่มี Partner', 'No Partners yet'),
                        style: text.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        context.tx(
                          'เชิญคนที่คุณไว้ใจเป็น Partner',
                          'Invite someone you trust as a Partner',
                        ),
                        style: text.bodySmall?.copyWith(color: c.inkMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          for (final p in partners)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SoftCard(
                radius: 14,
                child: Row(
                  children: [
                    const IconTile(
                      icon: Icons.person_outline_rounded,
                      size: 40,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.name,
                            style: text.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            switch (p.status) {
                              PartnerStatus.active => 'Active',
                              PartnerStatus.pending => context.tx(
                                'รอตอบรับ',
                                'Pending',
                              ),
                              PartnerStatus.revoked => context.tx(
                                'ยกเลิกแล้ว',
                                'Revoked',
                              ),
                            },
                            style: text.bodySmall?.copyWith(color: c.inkMuted),
                          ),
                        ],
                      ),
                    ),
                    if (p.status != PartnerStatus.revoked)
                      TextButton(
                        onPressed: () => ref
                            .read(vaultControllerProvider.notifier)
                            .revoke(p.id),
                        style: TextButton.styleFrom(
                          foregroundColor: c.onDangerSoft,
                        ),
                        child: Text(context.tx('ยกเลิก', 'Revoke')),
                      ),
                  ],
                ),
              ),
            ),
        const SizedBox(height: 12),
        GradientButton(
          label: context.tx('ปิด', 'Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
