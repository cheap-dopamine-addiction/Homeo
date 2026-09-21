import 'package:flutter/material.dart';
import 'package:homeo/l10n/l10n.dart';
import 'package:homeo/shared/widgets/placeholder_screen.dart';

class AiCoachScreen extends StatelessWidget {
  const AiCoachScreen({super.key});

  @override
  Widget build(BuildContext context) => PlaceholderScreen(
    title: context.l10n.tabAiCoach,
    icon: Icons.chat_bubble_outline_rounded,
  );
}
