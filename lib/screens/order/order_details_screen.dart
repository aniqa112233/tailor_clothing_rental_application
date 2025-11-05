
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../models/order_model.dart';
// import '../../providers/order_provider.dart';
// import 'package:intl/intl.dart';

// class OrderDetailsScreen extends StatefulWidget {
//   final String orderId;
//   const OrderDetailsScreen({super.key, required this.orderId});

//   @override
//   State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
// }

// class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
//   OrderModel? _order;
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     try {
//       final provider = Provider.of<OrderProvider>(context, listen: false);
//       final ord = await provider.getOrderById(widget.orderId);
//       setState(() {
//         _order = ord;
//         _loading = false;
//       });
//     } catch (e) {
//       setState(() => _loading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading: $e')),
//       );
//     }
//   }

//   void _changeStatus(String status) async {
//     setState(() => _loading = true);
//     try {
//       await Provider.of<OrderProvider>(context, listen: false)
//           .updateOrderStatus(widget.orderId, status);
//       await _load();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Status update failed: $e')),
//       );
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final df = DateFormat.yMMMd().add_jm();
//     return Scaffold(
//       appBar: AppBar(title: const Text('Order Details')),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : _order == null
//               ? const Center(child: Text('Order not found'))
//               : Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Order ID: ${_order!.id}',
//                           style:
//                               const TextStyle(fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       Text('Type: ${_order!.orderType}'),
//                       const SizedBox(height: 8),
//                       Text('Service ID: ${_order!.serviceId}'),
//                       const SizedBox(height: 8),
//                       Text('Tailor: ${_order!.tailorId ?? 'Not assigned'}'),
//                       const SizedBox(height: 8),
//                       Text('Status: ${_order!.status}'),
//                       const SizedBox(height: 8),
//                       Text(
//                           'Amount: Rs. ${_order!.totalAmount.toStringAsFixed(2)}'),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Delivery: ${_order!.deliveryDate != null ? DateFormat.yMMMd().format(_order!.deliveryDate!) : '—'}',
//                       ),
//                       const SizedBox(height: 16),
//                       const Text('Measurements:',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       _order!.measurements == null
//                           ? const Text('No measurements provided')
//                           : Text(_order!.measurements.toString()),
//                       const Spacer(),

//                       // ✅ Only Cancel Order button (Removed Mark Delivered)
//                       OutlinedButton(
//                         onPressed: _order!.status == 'Cancelled'
//                             ? null
//                             : () => _changeStatus('Cancelled'),
//                         child: const Text('Cancel Order'),
//                       ),
//                     ],
//                   ),
//                 ),
//     );
//   }
// }chatttttttttttttttttttttttttttttttttttttttt
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tailor_clothing_application/screens/chats/chat_screen.dart';
// import '../../models/order_model.dart';
// import '../../providers/order_provider.dart';
// import 'package:intl/intl.dart';
// class OrderDetailsScreen extends StatefulWidget {
//   final String orderId;
//   const OrderDetailsScreen({super.key, required this.orderId});

//   @override
//   State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
// }

// class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
//   OrderModel? _order;
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     try {
//       final provider = Provider.of<OrderProvider>(context, listen: false);
//       final ord = await provider.getOrderById(widget.orderId);
//       setState(() {
//         _order = ord;
//         _loading = false;
//       });
//     } catch (e) {
//       setState(() => _loading = false);
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Error loading: $e')));
//     }
//   }

//   void _changeStatus(String status) async {
//     setState(() => _loading = true);
//     try {
//       await Provider.of<OrderProvider>(context, listen: false)
//           .updateOrderStatus(widget.orderId, status);
//       await _load();
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Status update failed: $e')));
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final df = DateFormat.yMMMd().add_jm();
//     return Scaffold(
//       appBar: AppBar(title: const Text('Order Details')),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : _order == null
//               ? const Center(child: Text('Order not found'))
//               : Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Order ID: ${_order!.id}',
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       Text('Type: ${_order!.orderType}'),
//                       const SizedBox(height: 8),
//                       Text('Service ID: ${_order!.serviceId}'),
//                       const SizedBox(height: 8),
//                       Text('Tailor: ${_order!.tailorId ?? 'Not assigned'}'),
//                       const SizedBox(height: 8),
//                       Text('Status: ${_order!.status}'),
//                       const SizedBox(height: 8),
//                       Text(
//                           'Amount: Rs. ${_order!.totalAmount.toStringAsFixed(2)}'),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Delivery: ${_order!.deliveryDate != null ? DateFormat.yMMMd().format(_order!.deliveryDate!) : '—'}',
//                       ),
//                       const SizedBox(height: 16),
//                       const Text('Measurements:',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       _order!.measurements == null
//                           ? const Text('No measurements provided')
//                           : Text(_order!.measurements.toString()),
//                       const Spacer(),

//                       // 🟢 Chat button (new)
//                       if (_order!.tailorId != null)
//                         ElevatedButton.icon(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => ChatScreen(
//                                   orderId: _order!.id,
//                                   tailorId: _order!.tailorId!,
//                                   customerId: _order!.userId,
//                                 ),
//                               ),
//                             );
//                           },
//                           icon: const Icon(Icons.chat),
//                           label: const Text("Chat with Tailor"),
//                           style: ElevatedButton.styleFrom(
//                             minimumSize:
//                                 const Size(double.infinity, 50),
//                             backgroundColor: Colors.blueAccent,
//                           ),
//                         ),
//                       const SizedBox(height: 10),

//                       // 🟠 Cancel button (as before)
//                       OutlinedButton(
//                         onPressed: _order!.status == 'Cancelled'
//                             ? null
//                             : () => _changeStatus('Cancelled'),
//                         child: const Text('Cancel Order'),
//                       ),
//                     ],
//                   ),
//                 ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tailor_clothing_application/screens/chats/chat_screen.dart';
// import '../../models/order_model.dart';
// import '../../providers/order_provider.dart';
// import 'package:intl/intl.dart';

// class OrderDetailsScreen extends StatefulWidget {
//   final String orderId;
//   const OrderDetailsScreen({super.key, required this.orderId});

//   @override
//   State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
// }

// class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
//   OrderModel? _order;
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     try {
//       final provider = Provider.of<OrderProvider>(context, listen: false);
//       final ord = await provider.getOrderById(widget.orderId);
//       setState(() {
//         _order = ord;
//         _loading = false;
//       });
//     } catch (e) {
//       setState(() => _loading = false);
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Error loading: $e')));
//     }
//   }

//   void _changeStatus(String status) async {
//     setState(() => _loading = true);
//     try {
//       await Provider.of<OrderProvider>(context, listen: false)
//           .updateOrderStatus(widget.orderId, status);
//       await _load();
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Status update failed: $e')));
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final df = DateFormat.yMMMd().add_jm();
//     return Scaffold(
//       appBar: AppBar(title: const Text('Order Details')),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : _order == null
//               ? const Center(child: Text('Order not found'))
//               : Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Order ID: ${_order!.id}',
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       Text('Type: ${_order!.orderType}'),
//                       const SizedBox(height: 8),
//                       Text('Service ID: ${_order!.serviceId}'),
//                       const SizedBox(height: 8),
//                       Text('Tailor: ${_order!.tailorId ?? 'Not assigned'}'),
//                       const SizedBox(height: 8),
//                       Text('Status: ${_order!.status}'),
//                       const SizedBox(height: 8),
//                       Text(
//                           'Amount: Rs. ${_order!.totalAmount.toStringAsFixed(2)}'),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Delivery: ${_order!.deliveryDate != null ? DateFormat.yMMMd().format(_order!.deliveryDate!) : '—'}',
//                       ),
//                       const SizedBox(height: 16),
//                       const Text('Measurements:',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       _order!.measurements == null
//                           ? const Text('No measurements provided')
//                           : Text(_order!.measurements.toString()),
//                       const Spacer(),

//                       // 🟢 Chat button
//                       if (_order!.tailorId != null)
//                         ElevatedButton.icon(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => ChatScreen(
//                                   orderId: _order!.id.toString(), // ✅ FIX
//                                   tailorId: _order!.tailorId!,
//                                   customerId: _order!.userId,
//                                 ),
//                               ),
//                             );
//                           },
//                           icon: const Icon(Icons.chat),
//                           label: const Text("Chat with Tailor"),
//                           style: ElevatedButton.styleFrom(
//                             minimumSize: const Size(double.infinity, 50),
//                             backgroundColor: Colors.blueAccent,
//                           ),
//                         ),
//                       const SizedBox(height: 10),

//                       // 🟠 Cancel button
//                       OutlinedButton(
//                         onPressed: _order!.status == 'Cancelled'
//                             ? null
//                             : () => _changeStatus('Cancelled'),
//                         child: const Text('Cancel Order'),
//                       ),
//                     ],
//                   ),
//                 ),
//     );
//   }
// }wapussssssssssssssssssssssssssssss
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tailor_clothing_application/screens/chats/chat_screen.dart';
// import '../../models/order_model.dart';
// import '../../providers/order_provider.dart';
// import 'package:intl/intl.dart';

// class OrderDetailsScreen extends StatefulWidget {
//   final String orderId;
//   const OrderDetailsScreen({super.key, required this.orderId});

//   @override
//   State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
// }

// class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
//   OrderModel? _order;
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     try {
//       final provider = Provider.of<OrderProvider>(context, listen: false);
//       final ord = await provider.getOrderById(widget.orderId);
//       setState(() {
//         _order = ord;
//         _loading = false;
//       });
//     } catch (e) {
//       setState(() => _loading = false);
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Error loading: $e')));
//     }
//   }

//   void _changeStatus(String status) async {
//     setState(() => _loading = true);
//     try {
//       await Provider.of<OrderProvider>(context, listen: false)
//           .updateOrderStatus(widget.orderId, status);
//       await _load();
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Status update failed: $e')));
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final df = DateFormat.yMMMd().add_jm();
//     return Scaffold(
//       appBar: AppBar(title: const Text('Order Details')),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : _order == null
//               ? const Center(child: Text('Order not found'))
//               : Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Order ID: ${_order!.id}',
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       Text('Type: ${_order!.orderType}'),
//                       const SizedBox(height: 8),
//                       Text('Service ID: ${_order!.serviceId}'),
//                       const SizedBox(height: 8),
//                       Text('Tailor: ${_order!.tailorId ?? 'Not assigned'}'),
//                       const SizedBox(height: 8),
//                       Text('Status: ${_order!.status}'),
//                       const SizedBox(height: 8),
//                       Text(
//                           'Amount: Rs. ${_order!.totalAmount.toStringAsFixed(2)}'),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Delivery: ${_order!.deliveryDate != null ? DateFormat.yMMMd().format(_order!.deliveryDate!) : '—'}',
//                       ),
//                       const SizedBox(height: 16),
//                       const Text('Measurements:',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       _order!.measurements == null
//                           ? const Text('No measurements provided')
//                           : Text(_order!.measurements.toString()),
//                       const Spacer(),

//                       // ✅ Always show chat button
//                       ElevatedButton.icon(
//                         onPressed: _order!.tailorId == null
//                             ? () {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content:
//                                         Text("Tailor not assigned yet!"),
//                                   ),
//                                 );
//                               }
//                             : () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => ChatScreen(
//                                       orderId: _order!.id.toString(),
//                                       tailorId: _order!.tailorId!,
//                                       customerId: _order!.userId,
//                                     ),
//                                   ),
//                                 );
//                               },
//                         icon: const Icon(Icons.chat),
//                         label: const Text("Chat with Tailor"),
//                         style: ElevatedButton.styleFrom(
//                           minimumSize: const Size(double.infinity, 50),
//                           backgroundColor: Colors.blueAccent,
//                         ),
//                       ),

//                       const SizedBox(height: 10),

//                       // 🟠 Cancel button
//                       OutlinedButton(
//                         onPressed: _order!.status == 'Cancelled'
//                             ? null
//                             : () => _changeStatus('Cancelled'),
//                         child: const Text('Cancel Order'),
//                       ),
//                     ],
//                   ),
//                 ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailor_clothing_application/screens/chats/chat_screen.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
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
      final ord = await provider.getOrderById(widget.orderId);
      setState(() {
        _order = ord;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error loading: $e')));
    }
  }

  void _changeStatus(String status) async {
    setState(() => _loading = true);
    try {
      await Provider.of<OrderProvider>(context, listen: false)
          .updateOrderStatus(widget.orderId, status);
      await _load();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Status update failed: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat.yMMMd().add_jm();

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _order == null
              ? const Center(child: Text('Order not found'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order ID: ${_order!.id}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Type: ${_order!.orderType}'),
                      const SizedBox(height: 8),
                      Text('Service ID: ${_order!.serviceId}'),
                      const SizedBox(height: 8),
                      Text('Tailor: ${_order!.tailorId ?? 'Not assigned'}'),
                      const SizedBox(height: 8),
                      Text('Status: ${_order!.status}'),
                      const SizedBox(height: 8),
                      Text(
                          'Amount: Rs. ${_order!.totalAmount.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      Text(
                        'Delivery: ${_order!.deliveryDate != null ? DateFormat.yMMMd().format(_order!.deliveryDate!) : '—'}',
                      ),
                      const SizedBox(height: 16),
                      const Text('Measurements:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _order!.measurements == null
                          ? const Text('No measurements provided')
                          : Text(_order!.measurements.toString()),
                      const Spacer(),

                      // ✅ Always show chat button
                      ElevatedButton.icon(
                        onPressed: () {
                          // Check if tailor is assigned before navigating
                          if (_order!.tailorId == null ||
                              _order!.tailorId!.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Tailor not assigned yet!"),
                              ),
                            );
                            return;
                          }

                          // ✅ Tailor assigned → open chat
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                orderId: _order!.id.toString(),
                                tailorId: _order!.tailorId!,
                                customerId: _order!.userId,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.chat),
                        label: const Text("Chat with Tailor"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.blueAccent,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // 🟠 Cancel button
                      OutlinedButton(
                        onPressed: _order!.status == 'Cancelled'
                            ? null
                            : () => _changeStatus('Cancelled'),
                        child: const Text('Cancel Order'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
