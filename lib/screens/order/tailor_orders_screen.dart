
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailor_clothing_application/screens/chats/chat_screen.dart';

class TailorOrdersScreen extends StatefulWidget {
  const TailorOrdersScreen({super.key});

  @override
  State<TailorOrdersScreen> createState() => _TailorOrdersScreenState();
}

class _TailorOrdersScreenState extends State<TailorOrdersScreen>
    with SingleTickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  bool _loading = false;
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      setState(() => _loading = true);
      final response = await supabase
          .from('orders')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        _orders =
            (response as List).map((e) => e as Map<String, dynamic>).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch orders: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _markDelivered(String orderId) async {
    try {
      await supabase
          .from('orders')
          .update({'status': 'Delivered'})
          .eq('id', orderId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order marked as Delivered')),
      );

      _fetchOrders();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingOrders = _orders
        .where((o) => o['status'] != 'Delivered' && o['status'] != 'Cancelled')
        .toList();
    final completedOrders = _orders
        .where((o) => o['status'] == 'Delivered' || o['status'] == 'Cancelled')
        .toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Customer Orders'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Pending Orders'),
              Tab(text: 'Completed Orders'),
            ],
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildOrderList(pendingOrders),
                  _buildOrderList(completedOrders),
                ],
              ),
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders) {
    if (orders.isEmpty) return const Center(child: Text('No orders found'));

    final currentUser = supabase.auth.currentUser;

    return RefreshIndicator(
      onRefresh: _fetchOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final date = order['created_at'] != null
              ? DateFormat.yMMMd().format(DateTime.parse(order['created_at']))
              : 'Unknown date';
          final status = order['status'] ?? 'Unknown';

          Color statusColor;
          if (status == 'Delivered') {
            statusColor = Colors.green;
          } else if (status == 'Cancelled') {
            statusColor = Colors.red;
          } else {
            statusColor = Colors.orange;
          }

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #${order['id']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Type: ${order['order_type']}'),
                  Text('Status: $status', style: TextStyle(color: statusColor)),
                  Text('Amount: Rs. ${order['total_amount'] ?? 0}'),
                  Text('Date: $date'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: status == 'Delivered' ||
                                  status == 'Cancelled'
                              ? null
                              : () => _markDelivered(order['id'].toString()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Mark Delivered'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (order['user_id'] == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Chat not available — missing info!'),
                                ),
                              );
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                  orderId: order['id'].toString(),
                                  senderId: currentUser!.id,
                                  receiverId: order['user_id'].toString(),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.chat, size: 18),
                          label: const Text('Chat with Customer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
