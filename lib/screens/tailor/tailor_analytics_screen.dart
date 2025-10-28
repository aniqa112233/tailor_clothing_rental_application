import 'package:flutter/material.dart';
import '../shared/stats_card.dart';

class TailorAnalyticsScreen extends StatelessWidget {
  const TailorAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: const [
          StatsCard(title: 'Orders', value: '24'),
          StatsCard(title: 'Earnings', value: 'PKR 18,500'),
          StatsCard(title: 'Ratings', value: '4.7⭐'),
          StatsCard(title: 'Active Customers', value: '12'),
        ],
      ),
    );
  }
}
