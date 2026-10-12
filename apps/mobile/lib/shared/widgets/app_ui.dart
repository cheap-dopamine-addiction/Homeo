import 'package:flutter/material.dart';
import 'package:homeo/core/theme/app_colors.dart';

/// Small building blocks shared by the screens ported from the Homeo
/// (P-type) design. Everything reads colours from [AppColors.of].

/// Full-width pill button with the primary gradient (design: `linear-gradient
/// (135deg, #6C63E0, #8B7FF0)`). `onPressed == null` renders the disabled look.
class GradientButton extends StatelessWidget {
  const GradientButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = 56,
    this.fontSize = 17,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final enabled = onPressed != null;
    final fg = enabled ? c.onPrimary : c.inkSubtle;

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              gradient: enabled
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [c.primary, c.primaryGlow],
                    )
                  : null,
              color: enabled ? null : c.border,
              borderRadius: BorderRadius.circular(999),
              boxShadow: enabled
                  ? [
                      BoxShadow(
                        color: c.primary.withValues(alpha: 0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: onPressed,
              child: SizedBox(
                height: height,
                width: double.infinity,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 18, color: fg),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(
                          label,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                fontSize: fontSize,
                                fontWeight: FontWeight.w700,
                                color: fg,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Outlined pill (secondary action) — 1.5 px border, primary text.
class SoftButton extends StatelessWidget {
  const SoftButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = 48,
    this.color,
    this.background,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;
  final Color? color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final fg = color ?? c.primaryText;
    return Material(
      color: background ?? c.primarySoft,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onPressed,
        child: Container(
          height: height,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: c.border, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: fg),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card surface used all over the design: white/dark surface, 1.5 px border.
class SoftCard extends StatelessWidget {
  const SoftCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 18,
    this.color,
    this.borderColor,
    this.dashed = false,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? color;
  final Color? borderColor;

  /// The design uses a dashed border for prototype-only entries; Flutter has
  /// no dashed border, so a lighter border is used.
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? c.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor ?? (dashed ? c.borderStrong : c.border),
          width: 1.5,
        ),
      ),
      child: child,
    );
  }
}

/// 36 px rounded icon tile (icon on a tinted square).
class IconTile extends StatelessWidget {
  const IconTile({
    required this.icon,
    this.size = 36,
    this.iconSize = 18,
    this.background,
    this.color,
    this.radius = 10,
    super.key,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final Color? background;
  final Color? color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background ?? c.primarySoft,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(icon, size: iconSize, color: color ?? c.primary),
    );
  }
}

/// Upper-case-ish small section caption.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {this.padding = EdgeInsets.zero, super.key});

  final String text;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: padding,
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          color: c.inkMuted,
        ),
      ),
    );
  }
}

/// Design toggle: 48×28 track, white knob.
class HomeoToggle extends StatelessWidget {
  const HomeoToggle({
    required this.on,
    required this.onChanged,
    this.semanticLabel,
    super.key,
  });

  final bool on;
  final ValueChanged<bool> onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Semantics(
      toggled: on,
      label: semanticLabel,
      onTap: () => onChanged(!on),
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(!on),
          child: SizedBox(
            width: 56,
            height: 48,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 28,
                padding: const EdgeInsets.all(3),
                alignment: on ? Alignment.centerRight : Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: on ? c.primary : c.borderStrong,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Coloured rounded square with the app's initial (design: `AppBadge`).
class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.name,
    required this.color,
    this.size = 40,
    super.key,
  });

  final String name;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final initial = name.isEmpty ? '?' : name.characters.first.toUpperCase();
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size * 0.3),
        ),
        child: Text(
          initial,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: size * 0.42,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

/// Round close button used in sheet headers.
class RoundCloseButton extends StatelessWidget {
  const RoundCloseButton({required this.onPressed, this.tooltip, super.key});

  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return IconButton(
      tooltip: tooltip ?? MaterialLocalizations.of(context).closeButtonTooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: c.primarySoft,
        minimumSize: const Size(44, 44),
      ),
      icon: Icon(Icons.close_rounded, size: 20, color: c.inkMuted),
    );
  }
}

/// Opens a modal bottom sheet on the root navigator, above the app shell.
Future<T?> showHomeoSheet<T>(
  BuildContext context,
  WidgetBuilder builder, {
  bool isDismissible = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    isDismissible: isDismissible,
    builder: builder,
  );
}

/// Standard sheet body: keyboard-safe, scrollable, with an optional title
/// row (title + close button).
class SheetFrame extends StatelessWidget {
  const SheetFrame({
    required this.children,
    this.title,
    this.onClose,
    this.centerTitle = false,
    super.key,
  });

  final String? title;
  final VoidCallback? onClose;
  final bool centerTitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.9,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            title!,
                            textAlign: centerTitle
                                ? TextAlign.center
                                : TextAlign.start,
                            style: text.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: c.ink,
                            ),
                          ),
                        ),
                        if (onClose != null)
                          RoundCloseButton(onPressed: onClose!),
                      ],
                    ),
                  ),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showToast(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  messenger
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
}

/// Selectable pill (triggers, ranges, reasons).
class PillChoice extends StatelessWidget {
  const PillChoice({
    required this.label,
    required this.selected,
    required this.onTap,
    this.height = 44,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: ExcludeSemantics(
        child: Material(
          color: selected ? c.primary : c.primarySoft,
          borderRadius: BorderRadius.circular(999),
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onTap,
            child: Container(
              height: height,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: selected ? null : Border.all(color: c.border, width: 2),
              ),
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: selected ? c.onPrimary : c.primaryText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
