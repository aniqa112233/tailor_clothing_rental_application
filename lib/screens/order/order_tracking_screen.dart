
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/order_provider.dart';
import '../../models/order_model.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  OrderModel? _order;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final provider = Provider.of<OrderProvider>(context, listen: false);
      final order = await provider.getOrderById(widget.orderId);
      setState(() {
        _order = order;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error loading tracking: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_order == null) return const Scaffold(body: Center(child: Text('Order not found')));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${_order!.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Current Status: ${_order!.status}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              'Expected Delivery: ${_order!.deliveryDate != null ? DateFormat.yMMMd().format(_order!.deliveryDate!) : "Not set"}',
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 32),
            Expanded(
              child: _buildTrackingProgress(_order!.status),
            ),
            const Divider(height: 32),
            Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getTrackingMessage(_order!.status),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingProgress(String status) {
    double progress = 0.25;
    switch (status) {
      case 'Pending':
        progress = 0.25;
        break;
      case 'In Progress':
        progress = 0.5;
        break;
      case 'Ready':
        progress = 0.75;
        break;
      case 'Delivered':
        progress = 1.0;
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LinearProgressIndicator(
          value: progress,
          minHeight: 10,
          borderRadius: BorderRadius.circular(10),
          backgroundColor: Colors.grey[300],
        ),
        const SizedBox(height: 16),
        Text(
          '${(progress * 100).toStringAsFixed(0)}% completed',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        const Icon(Icons.local_shipping, size: 60, color: Colors.blueAccent),
      ],
    );
  }

  String _getTrackingMessage(String status) {
    switch (status) {
      case 'Pending':
        return 'Your order is waiting for confirmation.';
      case 'In Progress':
        return 'Tailor has started working on your outfit.';
      case 'Ready':
        return 'Your order is ready and will be shipped soon.';
      case 'Delivered':
        return 'Order delivered successfully!';
      default:
        return 'Tracking not available.';
    }
  }
}
