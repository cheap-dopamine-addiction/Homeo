import 'package:flutter/material.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/utils/localized_text.dart';
import 'package:homeo/features/vault_partner/presentation/providers/vault_controller.dart';

extension PartnerPermissionLabel on PartnerPermission {
  String label(BuildContext context) => switch (this) {
    PartnerPermission.focusTime => context.tx('ดูเวลาโฟกัส', 'See focus time'),
    PartnerPermission.sessionComplete => context.tx(
      'ดู session ที่เสร็จ',
      'See completed sessions',
    ),
    PartnerPermission.continuity => context.tx(
      'ดูความต่อเนื่อง',
      'See consistency',
    ),
    PartnerPermission.override => context.tx(
      'รับคำขอ override',
      'Receive override requests',
    ),
    PartnerPermission.emergency => context.tx(
      'รับแจ้งเตือนฉุกเฉิน',
      'Receive emergency alerts',
    ),
  };

  IconData get icon => switch (this) {
    PartnerPermission.focusTime => Icons.bar_chart_rounded,
    PartnerPermission.sessionComplete => Icons.check_circle_outline_rounded,
    PartnerPermission.continuity => Icons.calendar_today_outlined,
    PartnerPermission.override => Icons.lock_open_rounded,
    PartnerPermission.emergency => Icons.notifications_none_rounded,
  };
}

/// Checklist of what a partner may see (design: InviteSheet permission list).
class PermissionPicker extends StatelessWidget {
  const PermissionPicker({
    required this.selected,
    required this.onToggle,
    super.key,
  });

  final Set<PartnerPermission> selected;
  final ValueChanged<PartnerPermission> onToggle;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        for (final p in PartnerPermission.values) ...[
          Builder(
            builder: (context) {
              final on = selected.contains(p);
              return Semantics(
                button: true,
                toggled: on,
                label: p.label(context),
                child: Material(
                  color: on ? c.primarySoft : c.surface,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => onToggle(p),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 52),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: on ? c.primary : c.border,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            p.icon,
                            size: 20,
                            color: on ? c.primary : c.inkSubtle,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              p.label(context),
                              style: text.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: on ? c.primaryText : c.ink,
                              ),
                            ),
                          ),
                          ExcludeSemantics(
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: on ? c.primary : Colors.transparent,
                                shape: BoxShape.circle,
                                border: on
                                    ? null
                                    : Border.all(
                                        color: c.borderStrong,
                                        width: 2,
                                      ),
                              ),
                              child: on
                                  ? Icon(
                                      Icons.check_rounded,
                                      size: 14,
                                      color: c.onPrimary,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
