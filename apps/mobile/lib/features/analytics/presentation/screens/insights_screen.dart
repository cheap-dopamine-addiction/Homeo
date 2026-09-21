import 'package:flutter/material.dart';
import 'package:homeo/l10n/l10n.dart';
import 'package:homeo/shared/widgets/placeholder_screen.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) => PlaceholderScreen(
    title: context.l10n.tabInsights,
    icon: Icons.bar_chart_rounded,
  );
}
