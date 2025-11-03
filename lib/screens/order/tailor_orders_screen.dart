// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class TailorOrdersScreen extends StatefulWidget {
//   const TailorOrdersScreen({super.key});

//   @override
//   State<TailorOrdersScreen> createState() => _TailorOrdersScreenState();
// }

// class _TailorOrdersScreenState extends State<TailorOrdersScreen> {
//   final supabase = Supabase.instance.client;
//   bool _loading = false;
//   List<Map<String, dynamic>> _orders = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchOrders();
//   }

//   Future<void> _fetchOrders() async {
//     try {
//       setState(() => _loading = true);
//       final response = await supabase
//           .from('orders')
//           .select()
//           .order('created_at', ascending: false);

//       setState(() {
//         _orders = (response as List)
//             .map((e) => e as Map<String, dynamic>)
//             .toList();
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to fetch orders: $e')),
//       );
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   Future<void> _markDelivered(String orderId) async {
//     try {
//       await supabase
//           .from('orders')
//           .update({'status': 'Delivered'})
//           .eq('id', orderId);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Order marked as Delivered')),
//       );
//       _fetchOrders(); // refresh list
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update order: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Customer Orders')),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : _orders.isEmpty
//               ? const Center(child: Text('No orders found'))
//               : RefreshIndicator(
//                   onRefresh: _fetchOrders,
//                   child: ListView.builder(
//                     padding: const EdgeInsets.all(12),
//                     itemCount: _orders.length,
//                     itemBuilder: (context, index) {
//                       final order = _orders[index];
//                       final date = order['created_at'] != null
//                           ? DateFormat.yMMMd().format(
//                               DateTime.parse(order['created_at']),
//                             )
//                           : 'Unknown date';

//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 8),
//                         child: ListTile(
//                           title: Text(
//                             'Order #${order['id']}',
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           subtitle: Text(
//                             'Type: ${order['order_type']}\n'
//                             'Status: ${order['status']}\n'
//                             'Amount: Rs. ${order['total_amount'] ?? 0}\n'
//                             'Date: $date',
//                           ),
//                           isThreeLine: true,
//                           trailing: order['status'] == 'Delivered'
//                               ? const Icon(Icons.check_circle,
//                                   color: Colors.green)
//                               : ElevatedButton(
//                                   onPressed: () =>
//                                       _markDelivered(order['id'].toString()),
//                                   child: const Text('Mark Delivered'),
//                                 ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//     );
//   }
// }
// // lib/screens/tailor/tailor_orders_screen.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class TailorOrdersScreen extends StatefulWidget {
//   const TailorOrdersScreen({super.key});

//   @override
//   State<TailorOrdersScreen> createState() => _TailorOrdersScreenState();
// }

// class _TailorOrdersScreenState extends State<TailorOrdersScreen> {
//   final supabase = Supabase.instance.client;
//   bool _loading = false;
//   List<Map<String, dynamic>> _orders = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchOrders();
//   }

//   Future<void> _fetchOrders() async {
//     try {
//       setState(() => _loading = true);
//       final response = await supabase
//           .from('orders')
//           .select()
//           .order('created_at', ascending: false);

//       setState(() {
//         _orders =
//             (response as List).map((e) => e as Map<String, dynamic>).toList();
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to fetch orders: $e')),
//       );
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   Future<void> _markDelivered(String orderId) async {
//     try {
//       await supabase
//           .from('orders')
//           .update({'status': 'Delivered'})
//           .eq('id', orderId);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Order marked as Delivered')),
//       );

//       _fetchOrders(); // refresh list
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update order: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Customer Orders')),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : _orders.isEmpty
//               ? const Center(child: Text('No orders found'))
//               : RefreshIndicator(
//                   onRefresh: _fetchOrders,
//                   child: ListView.builder(
//                     padding: const EdgeInsets.all(12),
//                     itemCount: _orders.length,
//                     itemBuilder: (context, index) {
//                       final order = _orders[index];
//                       final date = order['created_at'] != null
//                           ? DateFormat.yMMMd()
//                               .format(DateTime.parse(order['created_at']))
//                           : 'Unknown date';
//                       final status = order['status'] ?? 'Unknown';

//                       // 🧩 choose color based on status
//                       Color statusColor;
//                       if (status == 'Delivered') {
//                         statusColor = Colors.green;
//                       } else if (status == 'Cancelled') {
//                         statusColor = Colors.red;
//                       } else {
//                         statusColor = Colors.orange;
//                       }

//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 8),
//                         child: ListTile(
//                           title: Text(
//                             'Order #${order['id']}',
//                             style:
//                                 const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           subtitle: Text(
//                             'Type: ${order['order_type']}\n'
//                             'Status: $status\n'
//                             'Amount: Rs. ${order['total_amount'] ?? 0}\n'
//                             'Date: $date',
//                           ),
//                           isThreeLine: true,
//                           trailing: _buildTrailingButton(status, order),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//     );
//   }

//   // 🧠 helper to build correct trailing widget
//   Widget _buildTrailingButton(String status, Map<String, dynamic> order) {
//     if (status == 'Delivered') {
//       return const Icon(Icons.check_circle, color: Colors.green);
//     } else if (status == 'Cancelled') {
//       return const Text(
//         'Cancelled',
//         style: TextStyle(
//             color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
//       );
//     } else {
//       // Pending or In Progress
//       return ElevatedButton(
//         onPressed: () => _markDelivered(order['id'].toString()),
//         child: const Text('Mark Delivered'),
//       );
//     }
//   }
// }
// lib/screens/tailor/tailor_orders_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

      _fetchOrders(); // refresh list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingOrders =
        _orders.where((o) => o['status'] != 'Delivered' && o['status'] != 'Cancelled').toList();
    final completedOrders =
        _orders.where((o) => o['status'] == 'Delivered' || o['status'] == 'Cancelled').toList();

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
    if (orders.isEmpty) {
      return const Center(child: Text('No orders found'));
    }

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

          // 🧩 choose color based on status
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
            child: ListTile(
              title: Text(
                'Order #${order['id']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Type: ${order['order_type']}\n'
                'Status: $status\n'
                'Amount: Rs. ${order['total_amount'] ?? 0}\n'
                'Date: $date',
              ),
              isThreeLine: true,
              trailing: _buildTrailingButton(status, order),
            ),
          );
        },
      ),
    );
  }

  // 🧠 helper to build correct trailing widget
  Widget _buildTrailingButton(String status, Map<String, dynamic> order) {
    if (status == 'Delivered') {
      return const Icon(Icons.check_circle, color: Colors.green);
    } else if (status == 'Cancelled') {
      return const Text(
        'Cancelled',
        style:
            TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
      );
    } else {
      // Pending or In Progress
      return ElevatedButton(
        onPressed: () => _markDelivered(order['id'].toString()),
        child: const Text('Mark Delivered'),
      );
    }
  }
}
