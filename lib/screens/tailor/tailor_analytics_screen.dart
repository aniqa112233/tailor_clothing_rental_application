import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../shared/stats_card.dart';
import '../../providers/tailor_provider.dart';
import '../../utils/app_theme.dart';

class TailorAnalyticsScreen extends StatefulWidget {
  const TailorAnalyticsScreen({super.key});

  @override
  State<TailorAnalyticsScreen> createState() => _TailorAnalyticsScreenState();
}

class _TailorAnalyticsScreenState extends State<TailorAnalyticsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    final tailor = Provider.of<TailorProvider>(context, listen: false);
    tailor.fetchAnalytics();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    // Start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _updateValue(String key, dynamic currentValue) async {
    final tailor = Provider.of<TailorProvider>(context, listen: false);
    final controller = TextEditingController(text: currentValue.toString());

    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Update $key',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        content: TextField(
          controller: controller,
          keyboardType: key == 'Ratings' ? TextInputType.numberWithOptions(decimal: true) : TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Enter new $key',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.primary, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Save'),
          ),
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

    if (analytics == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Analytics',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              letterSpacing: 0.5,
            ),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
            strokeWidth: 3,
          ),
        ),
      );
    }

    // Extract values
    final orders = (analytics['orders'] ?? 0) as int;
    final earnings = (analytics['earnings'] ?? 0) as int;
    final ratings = (analytics['ratings'] ?? 0.0) as double;
    final activeCustomers = (analytics['active_customers'] ?? 0) as int;

    // Normalize values for better comparison
    final ordersValue = orders.toDouble();
    final earningsValue = earnings > 0 ? earnings / 1000.0 : 0.0;
    final ratingsValue = ratings * 20;
    final customersValue = activeCustomers.toDouble();

    // Calculate total for proportional segments
    final totalValue = ordersValue + earningsValue + ratingsValue + customersValue;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analytics',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stats Cards Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: [
                StatsCard(
                  title: 'Orders',
                  value: orders.toString(),
                  onTap: () => _updateValue('Orders', orders),
                ),
                StatsCard(
                  title: 'Earnings',
                  value: 'PKR ${earnings.toString()}',
                  onTap: () => _updateValue('Earnings', earnings),
                ),
                StatsCard(
                  title: 'Ratings',
                  value: ratings.toStringAsFixed(1) + '⭐',
                  onTap: () => _updateValue('Ratings', ratings),
                ),
                StatsCard(
                  title: 'Active Customers',
                  value: activeCustomers.toString(),
                  onTap: () => _updateValue('Active Customers', activeCustomers),
                ),
              ],
            ),
            // Combined Chart Section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Performance Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Combined Circular Chart
                  Center(
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return _buildCombinedCircularChart(
                          ordersValue,
                          earningsValue,
                          ratingsValue,
                          customersValue,
                          totalValue,
                          _animation.value,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCombinedCircularChart(
    double ordersValue,
    double earningsValue,
    double ratingsValue,
    double customersValue,
    double totalValue,
    double animationValue,
  ) {
    if (totalValue == 0) {
      return SizedBox(
        width: 200,
        height: 200,
        child: Center(
          child: Text(
            'No Data',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      );
    }

    // Calculate percentages
    final ordersPercent = ordersValue / totalValue;
    final earningsPercent = earningsValue / totalValue;
    final ratingsPercent = ratingsValue / totalValue;
    final customersPercent = customersValue / totalValue;

    return SizedBox(
      width: 200,
      height: 200,
      child: CustomPaint(
        painter: CombinedCircularChartPainter(
          ordersPercent,
          earningsPercent,
          ratingsPercent,
          customersPercent,
          animationValue,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Performance',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CombinedCircularChartPainter extends CustomPainter {
  final double ordersPercent;
  final double earningsPercent;
  final double ratingsPercent;
  final double customersPercent;
  final double animationValue;

  CombinedCircularChartPainter(
    this.ordersPercent,
    this.earningsPercent,
    this.ratingsPercent,
    this.customersPercent,
    this.animationValue,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -math.pi / 2; // Start from top

    // Orders - Primary color (animated)
    if (ordersPercent > 0) {
      final sweepAngle = ordersPercent * 2 * math.pi * animationValue;
      final paint = Paint()
        ..color = AppTheme.primary
        ..style = PaintingStyle.fill;
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    }

    // Earnings - Accent color (animated)
    if (earningsPercent > 0) {
      final sweepAngle = earningsPercent * 2 * math.pi * animationValue;
      final paint = Paint()
        ..color = AppTheme.accent
        ..style = PaintingStyle.fill;
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    }

    // Ratings - Primary with opacity (animated)
    if (ratingsPercent > 0) {
      final sweepAngle = ratingsPercent * 2 * math.pi * animationValue;
      final paint = Paint()
        ..color = AppTheme.primary.withOpacity(0.7)
        ..style = PaintingStyle.fill;
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    }

    // Customers - Accent with opacity (animated)
    if (customersPercent > 0) {
      final sweepAngle = customersPercent * 2 * math.pi * animationValue;
      final paint = Paint()
        ..color = AppTheme.accent.withOpacity(0.7)
        ..style = PaintingStyle.fill;
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
    }

    // Draw inner circle for donut effect
    final innerRadius = radius * 0.6;
    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, innerRadius, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}