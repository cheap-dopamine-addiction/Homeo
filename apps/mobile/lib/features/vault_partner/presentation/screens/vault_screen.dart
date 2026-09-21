import 'package:flutter/material.dart';
import 'package:homeo/l10n/l10n.dart';
import 'package:homeo/shared/widgets/placeholder_screen.dart';

class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context) => PlaceholderScreen(
    title: context.l10n.tabVault,
    icon: Icons.lock_outline_rounded,
  );
}
