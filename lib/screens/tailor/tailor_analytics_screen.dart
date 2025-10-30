
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/stats_card.dart';
import '../../providers/tailor_provider.dart';

class TailorAnalyticsScreen extends StatefulWidget {
  const TailorAnalyticsScreen({super.key});

  @override
  State<TailorAnalyticsScreen> createState() => _TailorAnalyticsScreenState();
}

class _TailorAnalyticsScreenState extends State<TailorAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    final tailor = Provider.of<TailorProvider>(context, listen: false);
    tailor.fetchAnalytics();
  }

  Future<void> _updateValue(String key, dynamic currentValue) async {
    final tailor = Provider.of<TailorProvider>(context, listen: false);
    final controller = TextEditingController(text: currentValue.toString());

    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Update $key'),
        content: TextField(
          controller: controller,
          keyboardType: key == 'Ratings' ? TextInputType.numberWithOptions(decimal: true) : TextInputType.number,
          decoration: InputDecoration(labelText: 'Enter new $key'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Save')),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      dynamic value;
      if (key == 'Ratings') {
        value = double.tryParse(result) ?? currentValue;
      } else {
        value = int.tryParse(result) ?? currentValue;
      }

      final updateData = {
        'Orders': 'orders',
        'Earnings': 'earnings',
        'Ratings': 'ratings',
        'Active Customers': 'active_customers',
      };

      await tailor.updateAnalytics({updateData[key]!: value});
    }
  }

  @override
  Widget build(BuildContext context) {
    final tailor = Provider.of<TailorProvider>(context);
    final analytics = tailor.analytics;

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: analytics == null
          ? const Center(child: CircularProgressIndicator())
          : GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              children: [
                StatsCard(
                  title: 'Orders',
                  value: (analytics['orders'] ?? 0).toString(),
                  onTap: () => _updateValue('Orders', analytics['orders'] ?? 0),
                ),
                StatsCard(
                  title: 'Earnings',
                  value: 'PKR ${(analytics['earnings'] ?? 0).toString()}',
                  onTap: () => _updateValue('Earnings', analytics['earnings'] ?? 0),
                ),
                StatsCard(
                  title: 'Ratings',
                  value: (analytics['ratings'] ?? 0.0).toStringAsFixed(1) + '⭐',
                  onTap: () => _updateValue('Ratings', analytics['ratings'] ?? 0.0),
                ),
                StatsCard(
                  title: 'Active Customers',
                  value: (analytics['active_customers'] ?? 0).toString(),
                  onTap: () => _updateValue('Active Customers', analytics['active_customers'] ?? 0),
                ),
              ],
            ),
    );
  }
}
