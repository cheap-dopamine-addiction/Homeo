import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homeo/app/router/app_routes.dart';
import 'package:homeo/core/theme/app_colors.dart';
import 'package:homeo/core/utils/localized_text.dart';
import 'package:homeo/features/ai_coach/presentation/providers/ai_coach_controller.dart';
import 'package:homeo/features/ai_coach/presentation/providers/coach_responder.dart';
import 'package:homeo/features/analytics/domain/insights_calculator.dart';
import 'package:homeo/features/analytics/presentation/providers/insights_providers.dart';
import 'package:homeo/features/focus_session/presentation/providers/focus_session_providers.dart';
import 'package:homeo/features/friction/domain/app_catalog.dart';
import 'package:homeo/shared/widgets/app_ui.dart';
import 'package:intl/intl.dart';

/// AI Coach tab (design: `AICoachScreen.tsx`): history drawer, privacy and
/// safety notices, chat bubbles with edit / delete / regenerate / copy /
/// share, suggested prompts and a typing indicator.
class AiCoachScreen extends ConsumerStatefulWidget {
  const AiCoachScreen({super.key});

  @override
  ConsumerState<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends ConsumerState<AiCoachScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  bool _sidebar = false;

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  String get _greeting => context.tx(
    'สวัสดี! ฉันคือ AI Coach ของ Homeo\n\nฉันดูได้เฉพาะข้อมูลใน Homeo ที่คุณอนุญาต และจะไม่วินิจฉัยหรือตัดสินคุณ\n\nอยากคุยเรื่องอะไรวันนี้?',
    "Hi! I'm Homeo's AI Coach.\n\nI can only see the Homeo data you allow, and I won't diagnose or judge you.\n\nWhat would you like to talk about today?",
  );

  String get _newChatGreeting => context.tx(
    'สวัสดี! เริ่มสนทนาใหม่ได้เลย\n\nอยากคุยเรื่องอะไรวันนี้?',
    'Hi! Starting a fresh chat.\n\nWhat would you like to talk about today?',
  );

  CoachFacts _facts() {
    final insights = ref.read(weeklySmartInsightsProvider);
    int? best;
    for (final i in insights) {
      if (i.kind == SmartInsightKind.bestHour) best = i.hour;
    }
    final events = ref.read(distractionEventsProvider).value ?? const [];
    final today = InsightsCalculator.dayOf(DateTime.now());
    final counts = <String, int>{};
    for (final e in events) {
      if (InsightsCalculator.dayOf(e.occurredAt) == today) {
        counts[e.appPackageId] = (counts[e.appPackageId] ?? 0) + 1;
      }
    }
    String? topApp;
    var topCount = 0;
    counts.forEach((k, v) {
      if (v > topCount) {
        topApp = AppCatalog.nameOf(k);
        topCount = v;
      }
    });
    return CoachFacts(
      bestWindowStartHour: best,
      topAppToday: topApp,
      topAppTodayCount: topCount,
      streak: ref.read(focusStatsProvider).streak.current,
    );
  }

  CoachReply get _reply {
    final facts = _facts();
    final thai = context.isThai;
    return (text) => CoachResponder.reply(text, facts, thai: thai);
  }

  void _send(String text) {
    ref.read(aiCoachControllerProvider.notifier).send(text, _reply);
    _input.clear();
  }

  Future<void> _copy(String text, {bool popActive = true}) async {
    final msg = context.tx('คัดลอกแล้ว', 'Copied');
    await Clipboard.setData(ClipboardData(text: text));
    if (popActive) {
      ref.read(aiCoachControllerProvider.notifier).clearActive();
    }
    if (mounted) showToast(context, msg);
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final state = ref.watch(aiCoachControllerProvider);
    final ctrl = ref.read(aiCoachControllerProvider.notifier);

    // Greeting is added lazily so it follows the current locale.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ctrl.ensureGreeting(_greeting);
    });

    ref.listen(
      aiCoachControllerProvider.select((s) => (s.messages.length, s.isTyping)),
      (_, _) => _scrollToEnd(),
    );

    final showSuggested = state.messages.length <= 1 && !state.isTyping;

    return SafeArea(
      child: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: ctrl.clearActive,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: context.tx('เปิด sidebar', 'Open sidebar'),
                        onPressed: () => setState(() => _sidebar = true),
                        icon: const Icon(Icons.menu_rounded),
                      ),
                      const _AvatarBot(size: 40),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Coach',
                              style: text.titleLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: c.success,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    context.tx(
                                      'Online · ข้อมูลของคุณอยู่แค่ใน Homeo',
                                      'Online · your data stays in Homeo',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: text.labelSmall?.copyWith(
                                      color: c.inkMuted,
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
                ),
                _Banner(
                  icon: Icons.lock_outline_rounded,
                  color: c.primary,
                  background: c.primarySoft,
                  textColor: c.onPrimarySoft,
                  message: context.tx(
                    'AI Coach เห็นเฉพาะข้อมูลที่คุณอนุญาต ไม่ส่งข้อมูลออกไปภายนอกโดยไม่บอก',
                    'AI Coach only sees data you allow and never sends data out without telling you',
                  ),
                ),
                _Banner(
                  color: c.warn,
                  background: c.warnSoft,
                  textColor: c.onWarnSoft,
                  message: context.tx(
                    'AI Coach ให้คำแนะนำทั่วไป ไม่ใช่ผู้เชี่ยวชาญ หากต้องการความช่วยเหลือเพิ่มเติม ควรพูดคุยกับผู้เชี่ยวชาญ',
                    'AI Coach gives general advice and is not a professional. For more help, please talk to a professional.',
                  ),
                ),
                Expanded(
                  child: state.messages.isEmpty
                      ? _EmptyState(onPrompt: _send)
                      : ListView(
                          controller: _scroll,
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                          children: [
                            for (final m in state.messages)
                              _Bubble(
                                msg: m,
                                active: state.activeId == m.id,
                                editing: state.editingId == m.id,
                                onTap: () => ctrl.toggleActive(m.id),
                                onEdit: () => ctrl.startEdit(m.id),
                                onDelete: () => ctrl.askDelete(m.id),
                                onRegenerate: () => ctrl.regenerate(m, _reply),
                                onCopy: () => _copy(m.text),
                                onShare: () => _copy(m.text),
                                onEditCancel: ctrl.cancelEdit,
                                onEditSend: (t) =>
                                    ctrl.sendEdit(m.id, t, _reply),
                              ),
                            if (state.isTyping) const _TypingRow(),
                          ],
                        ),
                ),
                if (showSuggested && state.messages.isNotEmpty)
                  SizedBox(
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: coachSuggestedPrompts.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final p = coachSuggestedPrompts[i];
                        return PillChoice(
                          label: context.tx(p.$1, p.$2),
                          selected: false,
                          height: 40,
                          onTap: () => _send(context.tx(p.$1, p.$2)),
                        );
                      },
                    ),
                  ),
                // Input bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _input,
                          enabled: !state.isTyping,
                          textInputAction: TextInputAction.send,
                          onChanged: (_) => setState(() {}),
                          onSubmitted: _send,
                          decoration: InputDecoration(
                            hintText: context.tx(
                              'ถามอะไรก็ได้...',
                              'Ask me anything...',
                            ),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(999),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(999),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(999),
                              borderSide: BorderSide(
                                color: c.primary,
                                width: 2,
                              ),
                            ),
                            fillColor: c.surfaceAlt,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        tooltip: context.tx('ส่ง', 'Send'),
                        onPressed: _input.text.trim().isEmpty || state.isTyping
                            ? null
                            : () => _send(_input.text),
                        style: IconButton.styleFrom(
                          minimumSize: const Size(48, 48),
                        ),
                        icon: const Icon(Icons.send_rounded),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Sidebar
          if (_sidebar)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _sidebar = false),
                child: ColoredBox(color: Colors.black.withValues(alpha: 0.4)),
              ),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            top: 0,
            bottom: 0,
            left: _sidebar ? 0 : -300,
            width: 290,
            child: _Sidebar(
              history: state.history,
              onClose: () => setState(() => _sidebar = false),
              onNewChat: () {
                ctrl.newChat(_newChatGreeting);
                _input.clear();
                setState(() => _sidebar = false);
              },
              onSelect: (id) {
                ctrl.openHistory(id);
                setState(() => _sidebar = false);
              },
              onProfile: () {
                setState(() => _sidebar = false);
                context.go(AppRoutes.settings);
              },
            ),
          ),
          if (state.deleteConfirmId != null) ...[
            Positioned.fill(
              child: GestureDetector(
                onTap: ctrl.cancelDelete,
                child: ColoredBox(color: Colors.black.withValues(alpha: 0.4)),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                color: c.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        context.tx('ลบข้อความนี้?', 'Delete this message?'),
                        style: text.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.tx(
                          'ข้อความจะหายไปและไม่สามารถกู้คืนได้',
                          'The message will be removed and cannot be restored',
                        ),
                        style: text.bodyMedium?.copyWith(color: c.inkMuted),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: SoftButton(
                              label: context.tx('ยกเลิก', 'Cancel'),
                              height: 52,
                              onPressed: ctrl.cancelDelete,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: FilledButton(
                                onPressed: ctrl.confirmDelete,
                                style: FilledButton.styleFrom(
                                  backgroundColor: c.danger,
                                  foregroundColor: c.onDanger,
                                  shape: const StadiumBorder(),
                                ),
                                child: Text(context.tx('ลบ', 'Delete')),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.color,
    required this.background,
    required this.textColor,
    required this.message,
    this.icon,
  });

  final IconData? icon;
  final Color color;
  final Color background;
  final Color textColor;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarBot extends StatelessWidget {
  const _AvatarBot({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [c.primary, c.primaryGlow],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Icon(
          Icons.smart_toy_outlined,
          size: size * 0.55,
          color: c.onPrimary,
        ),
      ),
    );
  }
}

class _TypingRow extends StatefulWidget {
  const _TypingRow();

  @override
  State<_TypingRow> createState() => _TypingRowState();
}

class _TypingRowState extends State<_TypingRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final reduce = MediaQuery.disableAnimationsOf(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const _AvatarBot(size: 36),
          const SizedBox(width: 8),
          Semantics(
            label: context.tx('AI Coach กำลังพิมพ์', 'AI Coach is typing'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: c.surface,
                border: Border.all(color: c.border, width: 1.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(4),
                ),
              ),
              child: AnimatedBuilder(
                animation: _anim,
                builder: (context, _) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < 3; i++)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: c.primary.withValues(
                            alpha: reduce
                                ? 0.7
                                : 0.4 +
                                      0.6 *
                                          (1 -
                                                  ((_anim.value * 3 - i) % 3 -
                                                          0.5)
                                                      .abs()
                                                      .clamp(0, 1))
                                              .toDouble(),
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatefulWidget {
  const _Bubble({
    required this.msg,
    required this.active,
    required this.editing,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onRegenerate,
    required this.onCopy,
    required this.onShare,
    required this.onEditCancel,
    required this.onEditSend,
  });

  final CoachMessage msg;
  final bool active;
  final bool editing;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onRegenerate;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onEditCancel;
  final ValueChanged<String> onEditSend;

  @override
  State<_Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<_Bubble> {
  late final TextEditingController _edit = TextEditingController(
    text: widget.msg.text,
  );

  @override
  void didUpdateWidget(_Bubble old) {
    super.didUpdateWidget(old);
    if (widget.editing && !old.editing) {
      _edit.value = TextEditingValue(
        text: widget.msg.text,
        selection: TextSelection.collapsed(offset: widget.msg.text.length),
      );
    }
  }

  @override
  void dispose() {
    _edit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final msg = widget.msg;
    final isAi = msg.role == CoachRole.ai;

    final radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: Radius.circular(isAi ? 4 : 18),
      bottomRight: Radius.circular(isAi ? 18 : 4),
    );

    Widget body;
    if (widget.editing) {
      body = Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: radius,
          border: Border.all(color: c.primary, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _edit,
              autofocus: true,
              minLines: 1,
              maxLines: 5,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onEditCancel,
                  child: Text(context.tx('ยกเลิก', 'Cancel')),
                ),
                FilledButton(
                  onPressed: _edit.text.trim().isEmpty
                      ? null
                      : () => widget.onEditSend(_edit.text),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(72, 44),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(context.tx('ส่ง', 'Send')),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      body = Semantics(
        button: true,
        child: Material(
          color: isAi ? c.surface : c.primary,
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: radius,
                border: isAi ? Border.all(color: c.border, width: 1.5) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: text.bodyMedium?.copyWith(
                      color: isAi ? c.ink : c.onPrimary,
                      height: 1.5,
                    ),
                  ),
                  if (msg.isEdited || msg.isRegenerated)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        [
                          if (msg.isEdited) context.tx('แก้ไขแล้ว', 'edited'),
                          if (msg.isRegenerated)
                            context.tx('สร้างใหม่', 'regenerated'),
                        ].join(' · '),
                        style: text.labelSmall?.copyWith(
                          fontSize: 10,
                          color: isAi
                              ? c.inkSubtle
                              : c.onPrimary.withValues(alpha: 0.75),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget pills() => Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: isAi
            ? [
                _ActionPill(
                  icon: Icons.content_paste_rounded,
                  label: context.tx('คัดลอก', 'Copy'),
                  onTap: widget.onCopy,
                ),
                _ActionPill(
                  icon: Icons.ios_share_rounded,
                  label: context.tx('แชร์', 'Share'),
                  onTap: widget.onShare,
                ),
              ]
            : [
                _ActionPill(
                  icon: Icons.edit_outlined,
                  label: context.tx('แก้ไข', 'Edit'),
                  onTap: widget.onEdit,
                ),
                _ActionPill(
                  icon: Icons.delete_outline_rounded,
                  label: context.tx('ลบ', 'Delete'),
                  onTap: widget.onDelete,
                ),
                _ActionPill(
                  icon: Icons.refresh_rounded,
                  label: context.tx('สร้างใหม่', 'Regenerate'),
                  onTap: widget.onRegenerate,
                ),
              ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: isAi
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: isAi
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isAi) ...[
                const _AvatarBot(size: 36),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.75,
                  ),
                  child: body,
                ),
              ),
            ],
          ),
          if (widget.active && !widget.editing)
            Padding(
              padding: EdgeInsets.only(left: isAi ? 44 : 0),
              child: pills(),
            ),
        ],
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: c.border, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: c.inkMuted),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: c.inkMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onPrompt});

  final ValueChanged<String> onPrompt;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 24),
        const Center(child: _AvatarBot(size: 64)),
        const SizedBox(height: 16),
        Text(
          context.tx('ยังไม่มีการสนทนา', 'No conversation yet'),
          textAlign: TextAlign.center,
          style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        Text(
          context.tx(
            'เริ่มคุยกับ AI Coach ได้เลย',
            'Start chatting with AI Coach',
          ),
          textAlign: TextAlign.center,
          style: text.bodyMedium?.copyWith(color: c.inkMuted),
        ),
        const SizedBox(height: 24),
        SectionLabel(context.tx('หัวข้อแนะนำ', 'Suggested topics')),
        const SizedBox(height: 8),
        for (final p in coachSuggestedPrompts) ...[
          SoftButton(
            label: context.tx(p.$1, p.$2),
            height: 52,
            onPressed: () => onPrompt(context.tx(p.$1, p.$2)),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.history,
    required this.onClose,
    required this.onNewChat,
    required this.onSelect,
    required this.onProfile,
  });

  final List<CoachConversation> history;
  final VoidCallback onClose;
  final VoidCallback onNewChat;
  final ValueChanged<String> onSelect;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    return Material(
      color: c.surface,
      elevation: 8,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [c.primary, c.primaryGlow],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'H',
                      style: TextStyle(
                        color: c.onPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Homeo',
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: c.primary,
                      ),
                    ),
                  ),
                  RoundCloseButton(
                    onPressed: onClose,
                    tooltip: context.tx('ปิด sidebar', 'Close sidebar'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: GradientButton(
                label: context.tx('สนทนาใหม่', 'New chat'),
                icon: Icons.bolt_rounded,
                height: 48,
                fontSize: 15,
                onPressed: onNewChat,
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
                    child: SectionLabel('History'),
                  ),
                  if (history.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        context.tx(
                          'ยังไม่มีประวัติการสนทนา',
                          'No past conversations yet',
                        ),
                        style: text.bodySmall?.copyWith(color: c.inkMuted),
                      ),
                    ),
                  for (final h in history)
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(
                        h.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        '${DateFormat.MMMd(locale).format(h.savedAt)} · ${context.tx('${h.messages.length} ข้อความ', '${h.messages.length} messages')}',
                        style: text.bodySmall?.copyWith(color: c.inkMuted),
                      ),
                      onTap: () => onSelect(h.id),
                    ),
                ],
              ),
            ),
            Divider(height: 1, color: c.border),
            ListTile(
              leading: const IconTile(icon: Icons.person_outline_rounded),
              title: const Text(
                'Profile',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text(
                context.tx('บัญชีและการตั้งค่า', 'Account and settings'),
              ),
              onTap: onProfile,
            ),
          ],
        ),
      ),
    );
  }
}
