import 'package:flutter/material.dart';

/// Analytics / insights screen — shows focus trends and streak data.
class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: const Center(
        child: Text('Insights coming soon'),
      ),
    );
  }
}
