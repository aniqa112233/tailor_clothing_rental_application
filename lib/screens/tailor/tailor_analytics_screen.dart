// import 'package:flutter/material.dart';
// import '../shared/stats_card.dart';

// class TailorAnalyticsScreen extends StatelessWidget {
//   const TailorAnalyticsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Analytics')),
//       body: GridView.count(
//         crossAxisCount: 2,
//         padding: const EdgeInsets.all(16),
//         children: const [
//           StatsCard(title: 'Orders', value: '24'),
//           StatsCard(title: 'Earnings', value: 'PKR 18,500'),
//           StatsCard(title: 'Ratings', value: '4.7⭐'),
//           StatsCard(title: 'Active Customers', value: '12'),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../shared/stats_card.dart';
// import '../../providers/tailor_provider.dart';

// class TailorAnalyticsScreen extends StatefulWidget {
//   const TailorAnalyticsScreen({super.key});

//   @override
//   State<TailorAnalyticsScreen> createState() => _TailorAnalyticsScreenState();
// }

// class _TailorAnalyticsScreenState extends State<TailorAnalyticsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     final tailor = Provider.of<TailorProvider>(context, listen: false);
//     tailor.fetchAnalytics();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final tailor = Provider.of<TailorProvider>(context);
//     final analytics = tailor.analytics;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Analytics')),
//       body: analytics == null
//           ? const Center(child: CircularProgressIndicator())
//           : GridView.count(
//               crossAxisCount: 2,
//               padding: const EdgeInsets.all(16),
//               children: [
//                 StatsCard(
//                   title: 'Orders',
//                   value: analytics['orders'].toString(),
//                 ),
//                 StatsCard(
//                   title: 'Earnings',
//                   value: 'PKR ${analytics['earnings'].toString()}',
//                 ),
//                 StatsCard(
//                   title: 'Ratings',
//                   value: analytics['ratings'].toStringAsFixed(1) + '⭐',
//                 ),
//                 StatsCard(
//                   title: 'Active Customers',
//                   value: analytics['active_customers'].toString(),
//                 ),
//               ],
//             ),
//     );
//   }
// }
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
                ),
                StatsCard(
                  title: 'Earnings',
                  value: 'PKR ${(analytics['earnings'] ?? 0).toString()}',
                ),
                StatsCard(
                  title: 'Ratings',
                  value: (analytics['ratings'] ?? 0.0).toStringAsFixed(1) + '⭐',
                ),
                StatsCard(
                  title: 'Active Customers',
                  value: (analytics['active_customers'] ?? 0).toString(),
                ),
              ],
            ),
    );
  }
}
