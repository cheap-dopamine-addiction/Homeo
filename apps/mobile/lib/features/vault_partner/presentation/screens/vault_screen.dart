import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/utils/localized_text.dart';
import 'package:homeo/features/vault_partner/presentation/providers/vault_controller.dart';
import 'package:homeo/features/vault_partner/presentation/widgets/invite_sheet.dart';
import 'package:homeo/features/vault_partner/presentation/widgets/permission_picker.dart';
import 'package:homeo/shared/widgets/app_ui.dart';
import 'package:intl/intl.dart';

/// Vault tab (design: `VaultScreen.tsx`): partner list, invite sheet and the
/// override-request inbox.
class VaultScreen extends ConsumerWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vault = ref.watch(vaultControllerProvider);
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Vault',
                  style: text.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(
                height: 44,
                child: FilledButton(
                  onPressed: () => showInviteSheet(context),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(context.tx('+ เชิญ Partner', '+ Invite Partner')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            context.tx(
              'คนที่คุณไว้วางใจ — ดูได้เฉพาะสิ่งที่คุณเลือกแชร์',
              'People you trust — they only see what you choose to share',
            ),
            style: text.bodySmall?.copyWith(color: c.inkMuted),
          ),
          const SizedBox(height: 20),
          if (vault.partners.isEmpty)
            const _EmptyPartners()
          else
            for (final partner in vault.partners) ...[
              _PartnerCard(partner: partner),
              const SizedBox(height: 12),
            ],
          const SizedBox(height: 12),
          SectionLabel(context.tx('คำขอ Override', 'Override requests')),
          const SizedBox(height: 8),
          if (vault.requests.isEmpty)
            SoftCard(
              child: Text(
                context.tx(
                  'ยังไม่มีคำขอ Override',
                  'No override requests right now',
                ),
                style: text.bodyMedium?.copyWith(color: c.inkMuted),
              ),
            )
          else
            for (final r in vault.requests) ...[
              _RequestCard(request: r),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class _EmptyPartners extends StatelessWidget {
  const _EmptyPartners();

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: c.primarySoft,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Icon(Icons.group_outlined, size: 36, color: c.primary),
          ),
          const SizedBox(height: 16),
          Text(
            context.tx('ยังไม่มี Vault Partner', 'No Vault Partner yet'),
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            context.tx(
              'เชิญคนที่คุณไว้วางใจเพื่อรับการสนับสนุน โดยที่คุณยังควบคุมข้อมูลทั้งหมด',
              'Invite someone you trust for support — you still control all of your data.',
            ),
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(color: c.inkMuted),
          ),
        ],
      ),
    );
  }
}

class _PartnerCard extends ConsumerWidget {
  const _PartnerCard({required this.partner});

  final VaultPartner partner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;

    final (bg, fg, label) = switch (partner.status) {
      PartnerStatus.active => (c.successSoft, c.success, 'Active'),
      PartnerStatus.pending => (
        c.warnSoft,
        c.onWarnSoft,
        context.tx('รอตอบรับ', 'Pending'),
      ),
      PartnerStatus.revoked => (
        c.dangerSoft,
        c.onDangerSoft,
        context.tx('ยกเลิกแล้ว', 'Revoked'),
      ),
    };

    final since = switch (partner.status) {
      PartnerStatus.pending => context.tx('รอการตอบรับ', 'Waiting for reply'),
      _ => context.tx(
        'ตั้งแต่ ${DateFormat.MMMd(Localizations.localeOf(context).toString()).format(partner.since)}',
        'Since ${DateFormat.MMMd(Localizations.localeOf(context).toString()).format(partner.since)}',
      ),
    };

    final revoked = partner.status == PartnerStatus.revoked;

    return SoftCard(
      radius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: c.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_outline_rounded, color: c.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          partner.name,
                          style: text.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            label,
                            style: text.labelSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: fg,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      since,
                      style: text.bodySmall?.copyWith(color: c.inkMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final p in PartnerPermission.values)
                if (partner.permissions.contains(p))
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: c.primarySoft,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      p.label(context),
                      style: text.labelSmall?.copyWith(
                        color: c.primaryText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
            ],
          ),
          if (!revoked) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: SoftButton(
                    label: context.tx('แก้ไขสิทธิ์', 'Edit access'),
                    onPressed: () => showEditPermissionsSheet(context, partner),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SoftButton(
                    label: context.tx('ยกเลิกสิทธิ์', 'Revoke access'),
                    color: c.onDangerSoft,
                    background: c.dangerSoft,
                    onPressed: () => ref
                        .read(vaultControllerProvider.notifier)
                        .revoke(partner.id),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

Future<void> showEditPermissionsSheet(
  BuildContext context,
  VaultPartner partner,
) => showHomeoSheet<void>(context, (_) => _EditPermissionsSheet(partner: partner));

class _EditPermissionsSheet extends ConsumerStatefulWidget {
  const _EditPermissionsSheet({required this.partner});

  final VaultPartner partner;

  @override
  ConsumerState<_EditPermissionsSheet> createState() =>
      _EditPermissionsSheetState();
}

class _EditPermissionsSheetState extends ConsumerState<_EditPermissionsSheet> {
  late final Set<PartnerPermission> _perms = {...widget.partner.permissions};

  @override
  Widget build(BuildContext context) {
    return SheetFrame(
      title: context.tx(
        'สิทธิ์ของ ${widget.partner.name}',
        'Access for ${widget.partner.name}',
      ),
      onClose: () => Navigator.of(context).pop(),
      children: [
        PermissionPicker(
          selected: _perms,
          onToggle: (p) =>
              setState(() => _perms.contains(p) ? _perms.remove(p) : _perms.add(p)),
        ),
        const SizedBox(height: 8),
        GradientButton(
          label: context.tx('บันทึก', 'Save'),
          onPressed: () {
            ref
                .read(vaultControllerProvider.notifier)
                .setPermissions(widget.partner.id, {..._perms});
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class _RequestCard extends ConsumerWidget {
  const _RequestCard({required this.request});

  final OverrideRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final now = DateTime.now();
    final ago = now.difference(request.requestedAt).inMinutes.clamp(0, 9999);
    final left = request.expiresAt.difference(now).inMinutes.clamp(0, 9999);
    final ctrl = ref.read(vaultControllerProvider.notifier);

    return SoftCard(
      color: c.warnSoft,
      borderColor: c.warn.withValues(alpha: 0.4),
      radius: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.warn.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.notifications_none_rounded, color: c.warn),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tx(
                    '${request.partnerName} ขอเปิด ${request.appName}',
                    '${request.partnerName} asks to open ${request.appName}',
                  ),
                  style: text.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: c.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.tx(
                    'เหตุผล: "${request.reason}"',
                    'Reason: "${request.reason}"',
                  ),
                  style: text.bodySmall?.copyWith(color: c.onWarnSoft),
                ),
                Text(
                  context.tx(
                    '$ago นาทีที่แล้ว · หมดอายุใน $left นาที',
                    '$ago min ago · expires in $left min',
                  ),
                  style: text.labelSmall?.copyWith(color: c.onWarnSoft),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: FilledButton(
                          onPressed: () {
                            ctrl.resolveRequest(request.id);
                            showToast(
                              context,
                              context.tx('อนุมัติแล้ว', 'Approved'),
                            );
                          },
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 44),
                            backgroundColor: c.success,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                          ),
                          child: Text(context.tx('อนุมัติ', 'Approve')),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton(
                          onPressed: () {
                            ctrl.resolveRequest(request.id);
                            showToast(
                              context,
                              context.tx('ไม่อนุมัติ', 'Denied'),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 44),
                            shape: const StadiumBorder(),
                          ),
                          child: Text(context.tx('ไม่อนุมัติ', 'Deny')),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
