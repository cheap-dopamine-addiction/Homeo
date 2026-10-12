import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/utils/localized_text.dart';
import 'package:homeo/features/vault_partner/presentation/providers/vault_controller.dart';
import 'package:homeo/features/vault_partner/presentation/widgets/permission_picker.dart';
import 'package:homeo/shared/widgets/app_ui.dart';

/// "Invite Vault Partner" sheet (design: `InviteSheet`).
Future<void> showInviteSheet(BuildContext context) =>
    showHomeoSheet<void>(context, (_) => const _InviteSheet());

class _InviteSheet extends StatefulWidget {
  const _InviteSheet();

  @override
  State<_InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends State<_InviteSheet> {
  final Set<PartnerPermission> _perms = {
    PartnerPermission.focusTime,
    PartnerPermission.sessionComplete,
  };

  void _toggle(PartnerPermission p) =>
      setState(() => _perms.contains(p) ? _perms.remove(p) : _perms.add(p));

  /// No invite backend yet (PRD §18 `/v1/vault/invitations`), so the invite
  /// text is built locally from the chosen permissions.
  String _inviteText(BuildContext context) => context.tx(
    'ฉันอยากชวนคุณเป็น Vault Partner ใน Homeo — คุณจะเห็นเฉพาะ: '
        '${_perms.map((p) => p.label(context)).join(', ')}',
    'I would like you to be my Vault Partner in Homeo — you would only see: '
        '${_perms.map((p) => p.label(context)).join(', ')}',
  );

  Future<void> _copy() async {
    final messenger = ScaffoldMessenger.of(context);
    final text = _inviteText(context);
    final done = context.tx('คัดลอกคำเชิญแล้ว', 'Invitation copied');
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(content: Text(done)));
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    return SheetFrame(
      title: context.tx('เชิญ Vault Partner', 'Invite a Vault Partner'),
      onClose: () => Navigator.of(context).pop(),
      children: [
        SoftCard(
          color: c.primarySoft,
          borderColor: c.primarySoft,
          radius: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tx('Partner คืออะไร?', 'What is a Partner?'),
                style: text.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: c.primaryText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.tx(
                  'เป็นคนที่คุณไว้วางใจ ที่จะดูข้อมูลที่คุณเลือกแชร์เท่านั้น Partner ไม่สามารถบังคับ หรือลงโทษคุณได้ คุณยกเลิกสิทธิ์ได้ทุกเมื่อ',
                  'Someone you trust who only sees what you choose to share. A Partner cannot force or punish you, and you can revoke access at any time.',
                ),
                style: text.bodySmall?.copyWith(color: c.onPrimarySoft),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionLabel(
          context.tx('เลือกสิ่งที่ต้องการแชร์', 'Choose what to share'),
        ),
        const SizedBox(height: 8),
        PermissionPicker(selected: _perms, onToggle: _toggle),
        Text(
          context.tx(
            'ข้อมูลอื่น ๆ ที่ไม่ได้เลือก จะไม่ถูกแชร์เด็ดขาด รวมถึงเนื้อหาใน session และข้อมูล AI Coach',
            'Anything not selected is never shared — including session content and AI Coach data.',
          ),
          style: text.bodySmall?.copyWith(color: c.inkSubtle),
        ),
        const SizedBox(height: 16),
        GradientButton(
          label: context.tx('คัดลอกลิงก์เชิญ', 'Copy invitation'),
          icon: Icons.upload_rounded,
          onPressed: _copy,
        ),
        const SizedBox(height: 10),
        SoftButton(
          label: context.tx('แชร์ผ่านแอปอื่น', 'Share via another app'),
          icon: Icons.smartphone_rounded,
          height: 52,
          onPressed: _copy,
        ),
      ],
    );
  }
}
