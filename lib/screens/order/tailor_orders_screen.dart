
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class TailorOrdersScreen extends StatefulWidget {
//   const TailorOrdersScreen({super.key});

//   @override
//   State<TailorOrdersScreen> createState() => _TailorOrdersScreenState();
// }

// class _TailorOrdersScreenState extends State<TailorOrdersScreen>
//     with SingleTickerProviderStateMixin {
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
//     final pendingOrders =
//         _orders.where((o) => o['status'] != 'Delivered' && o['status'] != 'Cancelled').toList();
//     final completedOrders =
//         _orders.where((o) => o['status'] == 'Delivered' || o['status'] == 'Cancelled').toList();

//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Customer Orders'),
//           bottom: const TabBar(
//             indicatorColor: Colors.white,
//             tabs: [
//               Tab(text: 'Pending Orders'),
//               Tab(text: 'Completed Orders'),
//             ],
//           ),
//         ),
//         body: _loading
//             ? const Center(child: CircularProgressIndicator())
//             : TabBarView(
//                 children: [
//                   _buildOrderList(pendingOrders),
//                   _buildOrderList(completedOrders),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _buildOrderList(List<Map<String, dynamic>> orders) {
//     if (orders.isEmpty) {
//       return const Center(child: Text('No orders found'));
//     }

//     return RefreshIndicator(
//       onRefresh: _fetchOrders,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: orders.length,
//         itemBuilder: (context, index) {
//           final order = orders[index];
//           final date = order['created_at'] != null
//               ? DateFormat.yMMMd().format(DateTime.parse(order['created_at']))
//               : 'Unknown date';
//           final status = order['status'] ?? 'Unknown';

//           // 🧩 choose color based on status
//           Color statusColor;
//           if (status == 'Delivered') {
//             statusColor = Colors.green;
//           } else if (status == 'Cancelled') {
//             statusColor = Colors.red;
//           } else {
//             statusColor = Colors.orange;
//           }

//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             child: ListTile(
//               title: Text(
//                 'Order #${order['id']}',
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text(
//                 'Type: ${order['order_type']}\n'
//                 'Status: $status\n'
//                 'Amount: Rs. ${order['total_amount'] ?? 0}\n'
//                 'Date: $date',
//               ),
//               isThreeLine: true,
//               trailing: _buildTrailingButton(status, order),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // 🧠 helper to build correct trailing widget
//   Widget _buildTrailingButton(String status, Map<String, dynamic> order) {
//     if (status == 'Delivered') {
//       return const Icon(Icons.check_circle, color: Colors.green);
//     } else if (status == 'Cancelled') {
//       return const Text(
//         'Cancelled',
//         style:
//             TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
//       );
//     } else {
//       // Pending or In Progress
//       return ElevatedButton(
//         onPressed: () => _markDelivered(order['id'].toString()),
//         child: const Text('Mark Delivered'),
//       );
//     }
//   }
// }chatttttttttttttttttttttttttttt
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/screens/chats/chat_screen.dart';
// class TailorOrdersScreen extends StatefulWidget {
//   const TailorOrdersScreen({super.key});

//   @override
//   State<TailorOrdersScreen> createState() => _TailorOrdersScreenState();
// }

// class _TailorOrdersScreenState extends State<TailorOrdersScreen>
//     with SingleTickerProviderStateMixin {
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
//     final pendingOrders = _orders
//         .where((o) => o['status'] != 'Delivered' && o['status'] != 'Cancelled')
//         .toList();
//     final completedOrders = _orders
//         .where((o) => o['status'] == 'Delivered' || o['status'] == 'Cancelled')
//         .toList();

//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Customer Orders'),
//           bottom: const TabBar(
//             indicatorColor: Colors.white,
//             tabs: [
//               Tab(text: 'Pending Orders'),
//               Tab(text: 'Completed Orders'),
//             ],
//           ),
//         ),
//         body: _loading
//             ? const Center(child: CircularProgressIndicator())
//             : TabBarView(
//                 children: [
//                   _buildOrderList(pendingOrders),
//                   _buildOrderList(completedOrders),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _buildOrderList(List<Map<String, dynamic>> orders) {
//     if (orders.isEmpty) {
//       return const Center(child: Text('No orders found'));
//     }

//     return RefreshIndicator(
//       onRefresh: _fetchOrders,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: orders.length,
//         itemBuilder: (context, index) {
//           final order = orders[index];
//           final date = order['created_at'] != null
//               ? DateFormat.yMMMd().format(DateTime.parse(order['created_at']))
//               : 'Unknown date';
//           final status = order['status'] ?? 'Unknown';

//           Color statusColor;
//           if (status == 'Delivered') {
//             statusColor = Colors.green;
//           } else if (status == 'Cancelled') {
//             statusColor = Colors.red;
//           } else {
//             statusColor = Colors.orange;
//           }

//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             child: ListTile(
//               title: Text(
//                 'Order #${order['id']}',
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text(
//                 'Type: ${order['order_type']}\n'
//                 'Status: $status\n'
//                 'Amount: Rs. ${order['total_amount'] ?? 0}\n'
//                 'Date: $date',
//               ),
//               isThreeLine: true,
//               trailing: _buildTrailingButton(status, order),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTrailingButton(String status, Map<String, dynamic> order) {
//     // ✅ If order is delivered
//     if (status == 'Delivered') {
//       return const Icon(Icons.check_circle, color: Colors.green);
//     }
//     // ✅ If order is cancelled
//     else if (status == 'Cancelled') {
//       return const Text(
//         'Cancelled',
//         style: TextStyle(
//             color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
//       );
//     }
//     // ✅ Pending or In Progress orders
//     else {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//             onPressed: () => _markDelivered(order['id'].toString()),
//             child: const Text('Mark Delivered'),
//           ),
//           const SizedBox(height: 6),
//           // 🟢 Added Chat Button
//           ElevatedButton.icon(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => ChatScreen(
//                     orderId: order['id'].toString(),
//                     tailorId: order['tailor_id'] ?? '',
//                     customerId: order['user_id'] ?? '',
//                   ),
//                 ),
//               );
//             },
//             icon: const Icon(Icons.chat, size: 16),
//             label: const Text('Chat'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blueAccent,
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//             ),
//           ),
//         ],
//       );
//     }
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/screens/chats/chat_screen.dart';

// class TailorOrdersScreen extends StatefulWidget {
//   const TailorOrdersScreen({super.key});

//   @override
//   State<TailorOrdersScreen> createState() => _TailorOrdersScreenState();
// }

// class _TailorOrdersScreenState extends State<TailorOrdersScreen>
//     with SingleTickerProviderStateMixin {
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
//     final pendingOrders = _orders
//         .where((o) => o['status'] != 'Delivered' && o['status'] != 'Cancelled')
//         .toList();
//     final completedOrders = _orders
//         .where((o) => o['status'] == 'Delivered' || o['status'] == 'Cancelled')
//         .toList();

//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Customer Orders'),
//           bottom: const TabBar(
//             indicatorColor: Colors.white,
//             tabs: [
//               Tab(text: 'Pending Orders'),
//               Tab(text: 'Completed Orders'),
//             ],
//           ),
//         ),
//         body: _loading
//             ? const Center(child: CircularProgressIndicator())
//             : TabBarView(
//                 children: [
//                   _buildOrderList(pendingOrders),
//                   _buildOrderList(completedOrders),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _buildOrderList(List<Map<String, dynamic>> orders) {
//     if (orders.isEmpty) {
//       return const Center(child: Text('No orders found'));
//     }

//     return RefreshIndicator(
//       onRefresh: _fetchOrders,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: orders.length,
//         itemBuilder: (context, index) {
//           final order = orders[index];
//           final date = order['created_at'] != null
//               ? DateFormat.yMMMd().format(DateTime.parse(order['created_at']))
//               : 'Unknown date';
//           final status = order['status'] ?? 'Unknown';

//           Color statusColor;
//           if (status == 'Delivered') {
//             statusColor = Colors.green;
//           } else if (status == 'Cancelled') {
//             statusColor = Colors.red;
//           } else {
//             statusColor = Colors.orange;
//           }

//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Order #${order['id']}',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 4),
//                   Text('Type: ${order['order_type']}'),
//                   Text('Status: $status'),
//                   Text('Amount: Rs. ${order['total_amount'] ?? 0}'),
//                   Text('Date: $date'),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       // ✅ Mark Delivered Button
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: status == 'Delivered' ||
//                                   status == 'Cancelled'
//                               ? null
//                               : () => _markDelivered(order['id'].toString()),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                           ),
//                           child: const Text('Mark Delivered'),
//                         ),
//                       ),
//                       const SizedBox(width: 10),

//                       // ✅ Chat Button (fixed)
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: () {
//                             final customerId = order['user_id'];
//                             final tailorId = order['tailor_id'];

//                             if (customerId == null || tailorId == null) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text(
//                                       'Chat not available — missing customer or tailor info!'),
//                                 ),
//                               );
//                               return;
//                             }

//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => ChatScreen(
//                                   orderId: order['id'].toString(),
//                                   tailorId: tailorId,
//                                   customerId: customerId,
//                                 ),
//                               ),
//                             );
//                           },
//                           icon: const Icon(Icons.chat, size: 18),
//                           label: const Text('Chat with Customer'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blueAccent,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }pkaaaaaaaaaaaaaaaaaaaaaaaa
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/screens/chats/chat_screen.dart';

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
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Failed to fetch orders: $e')));
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

//       _fetchOrders();
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Failed to update order: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pendingOrders = _orders
//         .where((o) => o['status'] != 'Delivered' && o['status'] != 'Cancelled')
//         .toList();
//     final completedOrders = _orders
//         .where((o) => o['status'] == 'Delivered' || o['status'] == 'Cancelled')
//         .toList();

//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Customer Orders'),
//           bottom: const TabBar(
//             indicatorColor: Colors.white,
//             tabs: [
//               Tab(text: 'Pending Orders'),
//               Tab(text: 'Completed Orders'),
//             ],
//           ),
//         ),
//         body: _loading
//             ? const Center(child: CircularProgressIndicator())
//             : TabBarView(
//                 children: [
//                   _buildOrderList(pendingOrders),
//                   _buildOrderList(completedOrders),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _buildOrderList(List<Map<String, dynamic>> orders) {
//     if (orders.isEmpty) return const Center(child: Text('No orders found'));

//     return RefreshIndicator(
//       onRefresh: _fetchOrders,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: orders.length,
//         itemBuilder: (context, index) {
//           final order = orders[index];
//           final date = order['created_at'] != null
//               ? DateFormat.yMMMd().format(DateTime.parse(order['created_at']))
//               : 'Unknown date';
//           final status = order['status'] ?? 'Unknown';

//           Color statusColor;
//           if (status == 'Delivered') {
//             statusColor = Colors.green;
//           } else if (status == 'Cancelled') {
//             statusColor = Colors.red;
//           } else {
//             statusColor = Colors.orange;
//           }

//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Order #${order['id']}',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 4),
//                   Text('Type: ${order['order_type']}'),
//                   Text('Status: $status', style: TextStyle(color: statusColor)),
//                   Text('Amount: Rs. ${order['total_amount'] ?? 0}'),
//                   Text('Date: $date'),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: status == 'Delivered' || status == 'Cancelled'
//                               ? null
//                               : () => _markDelivered(order['id'].toString()),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                           ),
//                           child: const Text('Mark Delivered'),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: () {
//                             final customerId = order['user_id'];
//                             final tailorId = order['tailor_id'];

//                             if (customerId == null || tailorId == null) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text(
//                                       'Chat not available — missing info!'),
//                                 ),
//                               );
//                               return;
//                             }

//                             // ✅ Navigate to ChatScreen (same logic for both buttons)
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => ChatScreen(
//                                   orderId: order['id'].toString(),
//                                   tailorId: tailorId,
//                                   customerId: customerId,
//                                 ),
//                               ),
//                             );
//                           },
//                           icon: const Icon(Icons.chat, size: 18),
//                           label: const Text('Chat with Customer'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blueAccent,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/screens/chats/chat_screen.dart';

// class TailorOrdersScreen extends StatefulWidget {
//   const TailorOrdersScreen({super.key});

//   @override
//   State<TailorOrdersScreen> createState() => _TailorOrdersScreenState();
// }

// class _TailorOrdersScreenState extends State<TailorOrdersScreen>
//     with SingleTickerProviderStateMixin {
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
//           SnackBar(content: Text('Failed to fetch orders: $e')));
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

//       _fetchOrders(); // Refresh orders
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to update order: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pendingOrders = _orders
//         .where((o) => o['status'] != 'Delivered' && o['status'] != 'Cancelled')
//         .toList();
//     final completedOrders = _orders
//         .where((o) => o['status'] == 'Delivered' || o['status'] == 'Cancelled')
//         .toList();

//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Customer Orders'),
//           bottom: const TabBar(
//             indicatorColor: Colors.white,
//             tabs: [
//               Tab(text: 'Pending Orders'),
//               Tab(text: 'Completed Orders'),
//             ],
//           ),
//         ),
//         body: _loading
//             ? const Center(child: CircularProgressIndicator())
//             : TabBarView(
//                 children: [
//                   _buildOrderList(pendingOrders),
//                   _buildOrderList(completedOrders),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _buildOrderList(List<Map<String, dynamic>> orders) {
//     if (orders.isEmpty) return const Center(child: Text('No orders found'));

//     return RefreshIndicator(
//       onRefresh: _fetchOrders,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: orders.length,
//         itemBuilder: (context, index) {
//           final order = orders[index];
//           final date = order['created_at'] != null
//               ? DateFormat.yMMMd()
//                   .format(DateTime.parse(order['created_at']))
//               : 'Unknown date';
//           final status = order['status'] ?? 'Unknown';

//           Color statusColor;
//           if (status == 'Delivered') {
//             statusColor = Colors.green;
//           } else if (status == 'Cancelled') {
//             statusColor = Colors.red;
//           } else {
//             statusColor = Colors.orange;
//           }

//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Order #${order['id']}',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 4),
//                   Text('Type: ${order['order_type']}'),
//                   Text('Status: $status', style: TextStyle(color: statusColor)),
//                   Text('Amount: Rs. ${order['total_amount'] ?? 0}'),
//                   Text('Date: $date'),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: status == 'Delivered' ||
//                                   status == 'Cancelled'
//                               ? null
//                               : () => _markDelivered(order['id'].toString()),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                           ),
//                           child: const Text('Mark Delivered'),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: () {
//                             final customerId = order['user_id'];
//                             final tailorId = order['tailor_id'];

//                             if (customerId == null || tailorId == null) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text(
//                                       'Chat not available — missing info!'),
//                                 ),
//                               );
//                               return;
//                             }

//                             // ✅ Both Chat buttons use same ChatScreen
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => ChatScreen(
//                                   orderId: order['id'].toString(),
//                                   tailorId: tailorId,
//                                   customerId: customerId,
//                                 ),
//                               ),
//                             );
//                           },
//                           icon: const Icon(Icons.chat, size: 18),
//                           label: const Text('Chat with Customer'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blueAccent,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/screens/chats/chat_screen.dart';

// class TailorOrdersScreen extends StatefulWidget {
//   const TailorOrdersScreen({super.key});

//   @override
//   State<TailorOrdersScreen> createState() => _TailorOrdersScreenState();
// }

// class _TailorOrdersScreenState extends State<TailorOrdersScreen>
//     with SingleTickerProviderStateMixin {
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
//           SnackBar(content: Text('Failed to fetch orders: $e')));
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

//       _fetchOrders(); // Refresh orders
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to update order: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pendingOrders = _orders
//         .where((o) => o['status'] != 'Delivered' && o['status'] != 'Cancelled')
//         .toList();
//     final completedOrders = _orders
//         .where((o) => o['status'] == 'Delivered' || o['status'] == 'Cancelled')
//         .toList();

//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Customer Orders'),
//           bottom: const TabBar(
//             indicatorColor: Colors.white,
//             tabs: [
//               Tab(text: 'Pending Orders'),
//               Tab(text: 'Completed Orders'),
//             ],
//           ),
//         ),
//         body: _loading
//             ? const Center(child: CircularProgressIndicator())
//             : TabBarView(
//                 children: [
//                   _buildOrderList(pendingOrders),
//                   _buildOrderList(completedOrders),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _buildOrderList(List<Map<String, dynamic>> orders) {
//     if (orders.isEmpty) return const Center(child: Text('No orders found'));

//     return RefreshIndicator(
//       onRefresh: _fetchOrders,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: orders.length,
//         itemBuilder: (context, index) {
//           final order = orders[index];
//           final date = order['created_at'] != null
//               ? DateFormat.yMMMd().format(DateTime.parse(order['created_at']))
//               : 'Unknown date';
//           final status = order['status'] ?? 'Unknown';

//           Color statusColor;
//           if (status == 'Delivered') {
//             statusColor = Colors.green;
//           } else if (status == 'Cancelled') {
//             statusColor = Colors.red;
//           } else {
//             statusColor = Colors.orange;
//           }

//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Order #${order['id']}',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 4),
//                   Text('Type: ${order['order_type']}'),
//                   Text('Status: $status', style: TextStyle(color: statusColor)),
//                   Text('Amount: Rs. ${order['total_amount'] ?? 0}'),
//                   Text('Date: $date'),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: status == 'Delivered' ||
//                                   status == 'Cancelled'
//                               ? null
//                               : () => _markDelivered(order['id'].toString()),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                           ),
//                           child: const Text('Mark Delivered'),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: () {
//                             if (order['id'] == null) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text(
//                                       'Chat not available — missing info!'),
//                                 ),
//                               );
//                               return;
//                             }

//                             // ✅ Both buttons now open same ChatScreen by orderId
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => ChatScreen(
//                                   orderId: order['id'].toString(), senderId: '', receiverId: '',
//                                 ),
//                               ),
//                             );
//                           },
//                           icon: const Icon(Icons.chat, size: 18),
//                           label: const Text('Chat with Customer / Tailor'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blueAccent,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
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
