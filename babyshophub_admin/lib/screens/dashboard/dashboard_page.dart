import 'package:babyshophub_admin/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(title: "Your Dashboard", height: 80),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _DashboardCard(
                    title: "Pending orders",
                    value: "8",
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _DashboardCard(
                    title: "Shipped Orders",
                    value: "10",
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _DashboardCard(
              title: "Processing Orders",
              value: "3",
              isWide: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isWide;

  const _DashboardCard({
    required this.title,
    required this.value,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isWide ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB8B8B8), // Gray color for cards
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                ),
          ),
        ],
      ),
    );
  }
}
