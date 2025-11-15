
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import 'package:intl/intl.dart';
import '../utils/app_theme.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  const OrderCard({super.key, required this.order});

  Color _statusColor(String s) {
    switch (s) {
      case 'Pending':
        return Colors.orange;
      case 'In Progress':
        return Colors.blue;
      case 'Ready':
        return Colors.green;
      case 'Delivered':
        return AppTheme.accent; // Light green same as tick icon
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final createdAt = order.createdAt != null ? DateFormat.yMMMd().format(order.createdAt!) : '';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        title: Text('Order ${order.id?.substring(0, 8) ?? ''}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${order.orderType} • ${order.serviceId}'),
            const SizedBox(height: 4),
            Text('Placed: $createdAt'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Rs ${order.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: _statusColor(order.status).withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(order.status, style: TextStyle(color: _statusColor(order.status))),
            ),
          ],
        ),
      ),
    );
  }
}
