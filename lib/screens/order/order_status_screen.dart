// lib/screens/order/order_status_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order_model.dart';

class OrderStatusScreen extends StatefulWidget {
  final String orderId;
  const OrderStatusScreen({super.key, required this.orderId});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  OrderModel? _order;
  bool _loading = true;

  final List<String> _steps = [
    'Pending',
    'In Progress',
    'Ready',
    'Delivered',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final provider = Provider.of<OrderProvider>(context, listen: false);
    try {
      final order = await provider.getOrderById(widget.orderId);
      setState(() {
        _order = order;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading order: $e')));
    }
  }

  int _getStepIndex(String status) {
    switch (status) {
      case 'Pending':
        return 0;
      case 'In Progress':
        return 1;
      case 'Ready':
        return 2;
      case 'Delivered':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_order == null) return const Scaffold(body: Center(child: Text('Order not found')));

    final currentStep = _getStepIndex(_order!.status);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Status'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order ID: ${_order!.id?.substring(0, 8) ?? ''}", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Expanded(
              child: Stepper(
                type: StepperType.vertical,
                physics: const BouncingScrollPhysics(),
                currentStep: currentStep,
                steps: _steps.map((s) {
                  final index = _steps.indexOf(s);
                  final isActive = index <= currentStep;
                  return Step(
                    title: Text(s),
                    content: Text(_getStepDescription(s)),
                    isActive: isActive,
                    state: index < currentStep ? StepState.complete : StepState.indexed,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepDescription(String status) {
    switch (status) {
      case 'Pending':
        return 'Your order has been placed and is waiting for tailor confirmation.';
      case 'In Progress':
        return 'Tailor is working on your order.';
      case 'Ready':
        return 'Order is ready for delivery.';
      case 'Delivered':
        return 'Order has been successfully delivered.';
      default:
        return '';
    }
  }
}
