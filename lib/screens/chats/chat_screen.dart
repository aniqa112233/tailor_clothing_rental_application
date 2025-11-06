// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   late RealtimeChannel _channel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   Future<void> _fetchMessages() async {
//     final response = await supabase
//         .from('messages')
//         .select()
//         .eq('order_id', widget.orderId)
//         .order('created_at', ascending: true);
//     setState(() => _messages = List<Map<String, dynamic>>.from(response));
//   }

//   void _subscribeToMessages() {
//     _channel = supabase.channel('messages:order=${widget.orderId}');
//     _channel
//         .on(
//           RealtimeListenTypes.postgresChanges,
//           ChannelFilter(event: 'INSERT', schema: 'public', table: 'messages'),
//           (payload, [ref]) {
//             final newMsg = payload['new'] as Map<String, dynamic>;
//             if (newMsg['order_id'] == widget.orderId) {
//               setState(() => _messages.add(newMsg));
//             }
//           },
//         )
//         .subscribe();
//   }

//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final receiverId = currentUser.id == widget.customerId
//         ? widget.tailorId
//         : widget.customerId;

//     await supabase.from('messages').insert({
//       'sender_id': currentUser.id,
//       'receiver_id': receiverId,
//       'order_id': widget.orderId,
//       'message': text,
//     });

//     _msgController.clear();
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel.unsubscribe();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 final isMe =
//                     msg['sender_id'] == supabase.auth.currentUser?.id;
//                 final time = DateFormat.Hm().format(
//                     DateTime.tryParse(msg['created_at'] ?? '') ??
//                         DateTime.now());

//                 return Align(
//                   alignment:
//                       isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.blueAccent : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           msg['message'] ?? '',
//                           style: TextStyle(
//                               color: isMe ? Colors.white : Colors.black,
//                               fontSize: 15),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           time,
//                           style: TextStyle(
//                               color:
//                                   isMe ? Colors.white70 : Colors.black54,
//                               fontSize: 10),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           SafeArea(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _msgController,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message...',
//                         border: OutlineInputBorder(),
//                         isDense: true,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     color: Colors.blueAccent,
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   Future<void> _fetchMessages() async {
//     final response = await supabase
//         .from('messages')
//         .select()
//         .eq('order_id', widget.orderId)
//         .order('created_at', ascending: true);
//     setState(() => _messages = List<Map<String, dynamic>>.from(response));
//   }

//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');

//     _channel!.onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'messages',
//       callback: (payload) {
//         final newMsg = payload.newRecord;
//         if (newMsg != null && newMsg['order_id'] == widget.orderId) {
//           setState(() => _messages.add(Map<String, dynamic>.from(newMsg)));
//         }
//       },
//     ).subscribe();
//   }

//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final receiverId = currentUser.id == widget.customerId
//         ? widget.tailorId
//         : widget.customerId;

//     await supabase.from('messages').insert({
//       'sender_id': currentUser.id,
//       'receiver_id': receiverId,
//       'order_id': widget.orderId,
//       'message': text,
//     });

//     _msgController.clear();
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 final isMe =
//                     msg['sender_id'] == supabase.auth.currentUser?.id;
//                 final time = DateFormat.Hm().format(
//                     DateTime.tryParse(msg['created_at'] ?? '') ??
//                         DateTime.now());

//                 return Align(
//                   alignment:
//                       isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.blueAccent : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           msg['message'] ?? '',
//                           style: TextStyle(
//                               color: isMe ? Colors.white : Colors.black,
//                               fontSize: 15),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           time,
//                           style: TextStyle(
//                               color:
//                                   isMe ? Colors.white70 : Colors.black54,
//                               fontSize: 10),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           SafeArea(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _msgController,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message...',
//                         border: OutlineInputBorder(),
//                         isDense: true,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     color: Colors.blueAccent,
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   Future<void> _fetchMessages() async {
//     final response = await supabase
//         .from('messages')
//         .select()
//         .eq('order_id', widget.orderId)
//         .order('created_at', ascending: true);
//     setState(() => _messages = List<Map<String, dynamic>>.from(response));
//   }

//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');

//     _channel!.onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'messages',
//       callback: (payload) {
//         final newMsg = payload.newRecord;
//         if (newMsg != null && newMsg['order_id'] == widget.orderId) {
//           setState(() => _messages.add(Map<String, dynamic>.from(newMsg)));
//         }
//       },
//     ).subscribe();
//   }

//   Future<void> _ensureUserInProfiles(String userId) async {
//     // 🔹 Check if profile exists
//     final existing = await supabase
//         .from('profiles')
//         .select('id')
//         .eq('id', userId)
//         .maybeSingle();

//     // 🔹 If not exists, insert a simple profile
//     if (existing == null) {
//       await supabase.from('profiles').insert({
//         'id': userId,
//         'created_at': DateTime.now().toIso8601String(),
//       });
//     }
//   }

//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final senderId = currentUser.id;
//     final receiverId = senderId == widget.customerId
//         ? widget.tailorId
//         : widget.customerId;

//     try {
//       // ✅ Make sure both users exist in profiles table
//       await _ensureUserInProfiles(senderId);
//       await _ensureUserInProfiles(receiverId);

//       // ✅ Insert message safely
//       await supabase.from('messages').insert({
//         'sender_id': senderId,
//         'receiver_id': receiverId,
//         'order_id': widget.orderId,
//         'message': text,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _msgController.clear();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 final isMe =
//                     msg['sender_id'] == supabase.auth.currentUser?.id;
//                 final time = DateFormat.Hm().format(
//                     DateTime.tryParse(msg['created_at'] ?? '') ??
//                         DateTime.now());

//                 return Align(
//                   alignment:
//                       isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.blueAccent : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           msg['message'] ?? '',
//                           style: TextStyle(
//                               color: isMe ? Colors.white : Colors.black,
//                               fontSize: 15),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           time,
//                           style: TextStyle(
//                               color:
//                                   isMe ? Colors.white70 : Colors.black54,
//                               fontSize: 10),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           SafeArea(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _msgController,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message...',
//                         border: OutlineInputBorder(),
//                         isDense: true,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     color: Colors.blueAccent,
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   Future<void> _fetchMessages() async {
//     final response = await supabase
//         .from('messages')
//         .select()
//         .eq('order_id', widget.orderId)
//         .order('created_at', ascending: true);
//     setState(() => _messages = List<Map<String, dynamic>>.from(response));
//   }

//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');

//     _channel!.onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'messages',
//       callback: (payload) {
//         final newMsg = payload.newRecord;
//         if (newMsg != null && newMsg['order_id'] == widget.orderId) {
//           setState(() => _messages.add(Map<String, dynamic>.from(newMsg)));
//         }
//       },
//     ).subscribe();
//   }

//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final senderId = currentUser.id;
//     final receiverId = senderId == widget.customerId
//         ? widget.tailorId
//         : widget.customerId;

//     try {
//       // ✅ Directly insert message (RLS-safe)
//       await supabase.from('messages').insert({
//         'sender_id': senderId,
//         'receiver_id': receiverId,
//         'order_id': widget.orderId,
//         'message': text,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _msgController.clear();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 final isMe =
//                     msg['sender_id'] == supabase.auth.currentUser?.id;
//                 final time = DateFormat.Hm().format(
//                     DateTime.tryParse(msg['created_at'] ?? '') ??
//                         DateTime.now());

//                 return Align(
//                   alignment:
//                       isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.blueAccent : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           msg['message'] ?? '',
//                           style: TextStyle(
//                               color: isMe ? Colors.white : Colors.black,
//                               fontSize: 15),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           time,
//                           style: TextStyle(
//                               color:
//                                   isMe ? Colors.white70 : Colors.black54,
//                               fontSize: 10),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           SafeArea(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _msgController,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message...',
//                         border: OutlineInputBorder(),
//                         isDense: true,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     color: Colors.blueAccent,
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   Future<void> _fetchMessages() async {
//     final response = await supabase
//         .from('messages')
//         .select()
//         .eq('order_id', widget.orderId)
//         .order('created_at', ascending: true);
//     setState(() => _messages = List<Map<String, dynamic>>.from(response));
//   }

//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');

//     _channel!.onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'messages',
//       callback: (payload) {
//         final newMsg = payload.newRecord;
//         if (newMsg != null && newMsg['order_id'] == widget.orderId) {
//           setState(() => _messages.add(Map<String, dynamic>.from(newMsg)));
//         }
//       },
//     ).subscribe();
//   }

//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final senderId = currentUser.id;
//     final receiverId = senderId == widget.customerId
//         ? widget.tailorId
//         : widget.customerId;

//     try {
//       // ✅ Direct insert (foreign-key safe; assumes profiles exist)
//       await supabase.from('messages').insert({
//         'sender_id': senderId,
//         'receiver_id': receiverId,
//         'order_id': widget.orderId,
//         'message': text,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _msgController.clear();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 final isMe =
//                     msg['sender_id'] == supabase.auth.currentUser?.id;
//                 final time = DateFormat.Hm().format(
//                     DateTime.tryParse(msg['created_at'] ?? '') ??
//                         DateTime.now());

//                 return Align(
//                   alignment:
//                       isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.blueAccent : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           msg['message'] ?? '',
//                           style: TextStyle(
//                               color: isMe ? Colors.white : Colors.black,
//                               fontSize: 15),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           time,
//                           style: TextStyle(
//                               color:
//                                   isMe ? Colors.white70 : Colors.black54,
//                               fontSize: 10),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           SafeArea(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _msgController,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message...',
//                         border: OutlineInputBorder(),
//                         isDense: true,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     color: Colors.blueAccent,
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   Future<void> _fetchMessages() async {
//     final response = await supabase
//         .from('messages')
//         .select()
//         .eq('order_id', widget.orderId)
//         .order('created_at', ascending: true);

//     setState(() => _messages = List<Map<String, dynamic>>.from(response));
//   }

//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');

//     _channel!.onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'messages',
//       callback: (payload) {
//         final newMsg = payload.newRecord;
//         if (newMsg != null && newMsg['order_id'] == widget.orderId) {
//           setState(() => _messages.add(Map<String, dynamic>.from(newMsg)));
//         }
//       },
//     ).subscribe();
//   }

//   // ✅ Helper function to ensure profile exists before sending message
//   Future<void> _ensureProfileExists(String userId) async {
//     final existing = await supabase
//         .from('profiles')
//         .select('id')
//         .eq('id', userId)
//         .maybeSingle();

//     if (existing == null) {
//       await supabase.from('profiles').insert({
//         'id': userId,
//         'created_at': DateTime.now().toIso8601String(),
//       });
//     }
//   }

//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final senderId = currentUser.id;
//     final receiverId =
//         senderId == widget.customerId ? widget.tailorId : widget.customerId;

//     try {
//       // 🧩 Ensure both sender & receiver exist in profiles
//       await _ensureProfileExists(senderId);
//       await _ensureProfileExists(receiverId);

//       // ✅ Safe insert message
//       await supabase.from('messages').insert({
//         'sender_id': senderId,
//         'receiver_id': receiverId,
//         'order_id': widget.orderId,
//         'message': text,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _msgController.clear();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 final isMe =
//                     msg['sender_id'] == supabase.auth.currentUser?.id;
//                 final time = DateFormat.Hm().format(
//                   DateTime.tryParse(msg['created_at'] ?? '') ??
//                       DateTime.now(),
//                 );

//                 return Align(
//                   alignment:
//                       isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.blueAccent : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           msg['message'] ?? '',
//                           style: TextStyle(
//                             color: isMe ? Colors.white : Colors.black,
//                             fontSize: 15,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           time,
//                           style: TextStyle(
//                             color: isMe ? Colors.white70 : Colors.black54,
//                             fontSize: 10,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           SafeArea(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _msgController,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message...',
//                         border: OutlineInputBorder(),
//                         isDense: true,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     color: Colors.blueAccent,
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   Future<void> _fetchMessages() async {
//     final response = await supabase
//         .from('messages')
//         .select()
//         .eq('order_id', widget.orderId)
//         .order('created_at', ascending: true);

//     setState(() => _messages = List<Map<String, dynamic>>.from(response));
//   }

//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');

//     _channel!.onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'messages',
//       callback: (payload) {
//         final newMsg = payload.newRecord;
//         if (newMsg != null && newMsg['order_id'] == widget.orderId) {
//           setState(() => _messages.add(Map<String, dynamic>.from(newMsg)));
//         }
//       },
//     ).subscribe();
//   }

//   // ✅ Helper: Only ensures the CURRENT user's profile exists
//   Future<void> _ensureCurrentUserProfile() async {
//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final existing = await supabase
//         .from('profiles')
//         .select('id')
//         .eq('id', currentUser.id)
//         .maybeSingle();

//     // Insert only if it doesn't exist
//     if (existing == null) {
//       await supabase.from('profiles').insert({
//         'id': currentUser.id,
//         'email': currentUser.email,
//         'created_at': DateTime.now().toIso8601String(),
//       });
//     }
//   }

//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final senderId = currentUser.id;
//     final receiverId =
//         senderId == widget.customerId ? widget.tailorId : widget.customerId;

//     try {
//       // ✅ Ensure only current user's profile exists
//       await _ensureCurrentUserProfile();

//       // ✅ Safe insert (no receiver profile creation)
//       await supabase.from('messages').insert({
//         'sender_id': senderId,
//         'receiver_id': receiverId,
//         'order_id': widget.orderId,
//         'message': text,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _msgController.clear();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 final isMe =
//                     msg['sender_id'] == supabase.auth.currentUser?.id;
//                 final time = DateFormat.Hm().format(
//                   DateTime.tryParse(msg['created_at'] ?? '') ??
//                       DateTime.now(),
//                 );

//                 return Align(
//                   alignment:
//                       isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.blueAccent : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           msg['message'] ?? '',
//                           style: TextStyle(
//                             color: isMe ? Colors.white : Colors.black,
//                             fontSize: 15,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           time,
//                           style: TextStyle(
//                             color: isMe ? Colors.white70 : Colors.black54,
//                             fontSize: 10,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           SafeArea(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _msgController,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message...',
//                         border: OutlineInputBorder(),
//                         isDense: true,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     color: Colors.blueAccent,
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   Future<void> _fetchMessages() async {
//     final response = await supabase
//         .from('messages')
//         .select()
//         .eq('order_id', widget.orderId)
//         .order('created_at', ascending: true);

//     setState(() => _messages = List<Map<String, dynamic>>.from(response));
//   }

//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');

//     _channel!.onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'messages',
//       callback: (payload) {
//         final newMsg = payload.newRecord;
//         if (newMsg != null && newMsg['order_id'] == widget.orderId) {
//           setState(() => _messages.add(Map<String, dynamic>.from(newMsg)));
//         }
//       },
//     ).subscribe();
//   }

//   /// ✅ Helper: ensures profile exists (for both sender & receiver)
//   Future<void> _ensureProfileExists(String userId, String? email) async {
//     try {
//       final existing = await supabase
//           .from('profiles')
//           .select('id')
//           .eq('id', userId)
//           .maybeSingle();

//       if (existing == null) {
//         await supabase.from('profiles').insert({
//           'id': userId,
//           'email': email ?? 'unknown@email.com',
//           'created_at': DateTime.now().toIso8601String(),
//         });
//       }
//     } catch (e) {
//       debugPrint('⚠️ Profile check failed: $e');
//     }
//   }

//   /// ✅ Safe send message function
//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final senderId = currentUser.id;
//     final receiverId =
//         senderId == widget.customerId ? widget.tailorId : widget.customerId;

//     try {
//       // 🧩 Ensure both sender & receiver profiles exist
//       await _ensureProfileExists(senderId, currentUser.email);
//       await _ensureProfileExists(receiverId, null);

//       // ✅ Insert message safely
//       await supabase.from('messages').insert({
//         'sender_id': senderId,
//         'receiver_id': receiverId,
//         'order_id': widget.orderId,
//         'message': text,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _msgController.clear();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 final isMe =
//                     msg['sender_id'] == supabase.auth.currentUser?.id;
//                 final time = DateFormat.Hm().format(
//                   DateTime.tryParse(msg['created_at'] ?? '') ??
//                       DateTime.now(),
//                 );

//                 return Align(
//                   alignment:
//                       isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.blueAccent : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           msg['message'] ?? '',
//                           style: TextStyle(
//                             color: isMe ? Colors.white : Colors.black,
//                             fontSize: 15,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           time,
//                           style: TextStyle(
//                             color: isMe ? Colors.white70 : Colors.black54,
//                             fontSize: 10,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           SafeArea(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _msgController,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message...',
//                         border: OutlineInputBorder(),
//                         isDense: true,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     color: Colors.blueAccent,
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   Future<void> _fetchMessages() async {
//     final response = await supabase
//         .from('messages')
//         .select()
//         .eq('order_id', widget.orderId)
//         .order('created_at', ascending: true);

//     setState(() => _messages = List<Map<String, dynamic>>.from(response));
//   }

//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');

//     _channel!.onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'messages',
//       callback: (payload) {
//         final newMsg = payload.newRecord;
//         if (newMsg != null && newMsg['order_id'] == widget.orderId) {
//           setState(() => _messages.add(Map<String, dynamic>.from(newMsg)));
//         }
//       },
//     ).subscribe();
//   }

//   /// ✅ Safe send message function with FLUTTER SIDE FIX
//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final senderId = currentUser.id;
//     final receiverId =
//         senderId == widget.customerId ? widget.tailorId : widget.customerId;

//     try {
//       // 🧩 Ensure both users exist in profiles table before inserting message
//       await supabase.rpc('ensure_message_ready', params: {
//         'p_sender_id': senderId,
//         'p_receiver_id': receiverId,
//       });

//       // ✅ Insert message safely
//       await supabase.from('messages').insert({
//         'sender_id': senderId,
//         'receiver_id': receiverId,
//         'order_id': widget.orderId,
//         'message': text,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _msgController.clear();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 final isMe =
//                     msg['sender_id'] == supabase.auth.currentUser?.id;
//                 final time = DateFormat.Hm().format(
//                   DateTime.tryParse(msg['created_at'] ?? '') ??
//                       DateTime.now(),
//                 );

//                 return Align(
//                   alignment:
//                       isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.blueAccent : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           msg['message'] ?? '',
//                           style: TextStyle(
//                             color: isMe ? Colors.white : Colors.black,
//                             fontSize: 15,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           time,
//                           style: TextStyle(
//                             color: isMe ? Colors.white70 : Colors.black54,
//                             fontSize: 10,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           SafeArea(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _msgController,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message...',
//                         border: OutlineInputBorder(),
//                         isDense: true,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     color: Colors.blueAccent,
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   Future<void> _fetchMessages() async {
//     final response = await supabase
//         .from('messages')
//         .select()
//         .eq('order_id', widget.orderId)
//         .order('created_at', ascending: true);

//     setState(() => _messages = List<Map<String, dynamic>>.from(response));
//   }

//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');

//     _channel!.onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'messages',
//       callback: (payload) {
//         final newMsg = payload.newRecord;
//         if (newMsg != null && newMsg['order_id'] == widget.orderId) {
//           setState(() => _messages.add(Map<String, dynamic>.from(newMsg)));
//         }
//       },
//     ).subscribe();
//   }

//   /// ✅ Safe send message function (no FK errors)
//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final senderId = currentUser.id;
//     final receiverId =
//         senderId == widget.customerId ? widget.tailorId : widget.customerId;

//     try {
//       // ✅ Ensure receiver exists in profiles table
//       final receiverProfile = await supabase
//           .from('profiles')
//           .select('id')
//           .eq('id', receiverId)
//           .maybeSingle();

//       if (receiverProfile == null) {
//         throw 'Receiver does not exist. Make sure they are registered.';
//       }

//       // ✅ Insert message safely
//       await supabase.from('messages').insert({
//         'sender_id': senderId,
//         'receiver_id': receiverId,
//         'order_id': widget.orderId,
//         'message': text,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _msgController.clear();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 final isMe =
//                     msg['sender_id'] == supabase.auth.currentUser?.id;
//                 final time = DateFormat.Hm().format(
//                   DateTime.tryParse(msg['created_at'] ?? '') ??
//                       DateTime.now(),
//                 );

//                 return Align(
//                   alignment:
//                       isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.blueAccent : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           msg['message'] ?? '',
//                           style: TextStyle(
//                             color: isMe ? Colors.white : Colors.black,
//                             fontSize: 15,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           time,
//                           style: TextStyle(
//                             color: isMe ? Colors.white70 : Colors.black54,
//                             fontSize: 10,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           SafeArea(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _msgController,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message...',
//                         border: OutlineInputBorder(),
//                         isDense: true,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     color: Colors.blueAccent,
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }saiiiiiiiiiiiiiii
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/utils/profile_helper.dart';


// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   Future<void> _fetchMessages() async {
//     final response = await supabase
//         .from('messages')
//         .select()
//         .eq('order_id', widget.orderId)
//         .order('created_at', ascending: true);

//     setState(() => _messages = List<Map<String, dynamic>>.from(response));
//   }

//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');

//     _channel!.onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'messages',
//       callback: (payload) {
//         final newMsg = payload.newRecord;
//         if (newMsg != null && newMsg['order_id'] == widget.orderId) {
//           setState(() => _messages.add(Map<String, dynamic>.from(newMsg)));
//         }
//       },
//     ).subscribe();
//   }

//   /// ✅ Safe send message function with graceful handling
//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final senderId = currentUser.id;
//     final receiverId =
//         senderId == widget.customerId ? widget.tailorId : widget.customerId;

//     try {
//       // Ensure sender profile exists
//       await ensureUserProfileExists(senderId, email: currentUser.email);

//       // Check if receiver exists in Auth
//       final receiver = await supabase.auth.admin.getUserById(receiverId);

//       // Ensure receiver profile exists
//       await ensureUserProfileExists(receiverId);

//       // Insert the message safely
//       await supabase.from('messages').insert({
//         'sender_id': senderId,
//         'receiver_id': receiverId,
//         'order_id': widget.orderId,
//         'message': text,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _msgController.clear();
//     } catch (e) {
//       // Fallback error handling
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 final isMe =
//                     msg['sender_id'] == supabase.auth.currentUser?.id;
//                 final time = DateFormat.Hm().format(
//                   DateTime.tryParse(msg['created_at'] ?? '') ??
//                       DateTime.now(),
//                 );

//                 return Align(
//                   alignment:
//                       isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.blueAccent : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           msg['message'] ?? '',
//                           style: TextStyle(
//                             color: isMe ? Colors.white : Colors.black,
//                             fontSize: 15,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           time,
//                           style: TextStyle(
//                             color: isMe ? Colors.white70 : Colors.black54,
//                             fontSize: 10,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           SafeArea(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _msgController,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message...',
//                         border: OutlineInputBorder(),
//                         isDense: true,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     color: Colors.blueAccent,
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/utils/profile_helper.dart';


// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   Future<void> _fetchMessages() async {
//     final response = await supabase
//         .from('messages')
//         .select()
//         .eq('order_id', widget.orderId)
//         .order('created_at', ascending: true);

//     setState(() => _messages = List<Map<String, dynamic>>.from(response));
//   }

//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');

//     _channel!.onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'messages',
//       callback: (payload) {
//         final newMsg = payload.newRecord;
//         if (newMsg != null && newMsg['order_id'] == widget.orderId) {
//           setState(() => _messages.add(Map<String, dynamic>.from(newMsg)));
//         }
//       },
//     ).subscribe();
//   }

//   /// ✅ Safe send message function with graceful handling
//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final senderId = currentUser.id;
//     final receiverId =
//         senderId == widget.customerId ? widget.tailorId : widget.customerId;

//     try {
//       // Ensure sender profile exists
//       await ensureUserProfileExists(senderId, currentUser.email);

//       // Check if receiver exists in Auth
//       final receiverResponse = await supabase.auth.admin.getUserById(receiverId);
//       final receiver = receiverResponse.user;

//       if (receiver == null) {
//         // Show friendly in-chat message
//         setState(() {
//           _messages.add({
//             'sender_id': senderId,
//             'receiver_id': receiverId,
//             'order_id': widget.orderId,
//             'message':
//                 'Cannot send message. The other user has not registered yet.',
//             'created_at': DateTime.now().toIso8601String(),
//           });
//         });
//         _msgController.clear();
//         return;
//       }

//       // Ensure receiver profile exists
//       await ensureUserProfileExists(receiverId, receiver.email);

//       // Insert the message safely
//       await supabase.from('messages').insert({
//         'sender_id': senderId,
//         'receiver_id': receiverId,
//         'order_id': widget.orderId,
//         'message': text,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _msgController.clear();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 final isMe =
//                     msg['sender_id'] == supabase.auth.currentUser?.id;
//                 final time = DateFormat.Hm().format(
//                   DateTime.tryParse(msg['created_at'] ?? '') ??
//                       DateTime.now(),
//                 );

//                 return Align(
//                   alignment:
//                       isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.blueAccent : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           msg['message'] ?? '',
//                           style: TextStyle(
//                             color: isMe ? Colors.white : Colors.black,
//                             fontSize: 15,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           time,
//                           style: TextStyle(
//                             color: isMe ? Colors.white70 : Colors.black54,
//                             fontSize: 10,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           SafeArea(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _msgController,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message...',
//                         border: OutlineInputBorder(),
//                         isDense: true,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     color: Colors.blueAccent,
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/utils/profile_helper.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   Future<void> _fetchMessages() async {
//     final response = await supabase
//         .from('messages')
//         .select()
//         .eq('order_id', widget.orderId)
//         .order('created_at', ascending: true);

//     setState(() => _messages = List<Map<String, dynamic>>.from(response));
//   }

//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');

//     _channel!.onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'messages',
//       callback: (payload) {
//         final newMsg = payload.newRecord;
//         if (newMsg != null && newMsg['order_id'] == widget.orderId) {
//           setState(() => _messages.add(Map<String, dynamic>.from(newMsg)));
//         }
//       },
//     ).subscribe();
//   }

//   /// ✅ Safe send message function without Admin API
//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final senderId = currentUser.id;
//     final receiverId =
//         senderId == widget.customerId ? widget.tailorId : widget.customerId;

//     try {
//       // Ensure sender profile exists
//       await ensureUserProfileExists(senderId, currentUser.email);

//       // Ensure receiver exists in profiles table
//       final receiverProfile = await supabase
//           .from('profiles')
//           .select('id')
//           .eq('id', receiverId)
//           .maybeSingle();

//       if (receiverProfile == null) {
//         // Show friendly in-chat message
//         setState(() {
//           _messages.add({
//             'sender_id': senderId,
//             'receiver_id': receiverId,
//             'order_id': widget.orderId,
//             'message':
//                 'Cannot send message. The other user has not registered yet.',
//             'created_at': DateTime.now().toIso8601String(),
//           });
//         });
//         _msgController.clear();
//         return;
//       }

//       // Insert the message safely
//       await supabase.from('messages').insert({
//         'sender_id': senderId,
//         'receiver_id': receiverId,
//         'order_id': widget.orderId,
//         'message': text,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _msgController.clear();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 final isMe =
//                     msg['sender_id'] == supabase.auth.currentUser?.id;
//                 final time = DateFormat.Hm().format(
//                   DateTime.tryParse(msg['created_at'] ?? '') ??
//                       DateTime.now(),
//                 );

//                 return Align(
//                   alignment:
//                       isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.blueAccent : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           msg['message'] ?? '',
//                           style: TextStyle(
//                             color: isMe ? Colors.white : Colors.black,
//                             fontSize: 15,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           time,
//                           style: TextStyle(
//                             color: isMe ? Colors.white70 : Colors.black54,
//                             fontSize: 10,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           SafeArea(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _msgController,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message...',
//                         border: OutlineInputBorder(),
//                         isDense: true,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     color: Colors.blueAccent,
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }1000000000000000000000000000000000000
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/utils/profile_helper.dart';


// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   Future<void> _fetchMessages() async {
//     final response = await supabase
//         .from('messages')
//         .select()
//         .eq('order_id', widget.orderId)
//         .order('created_at', ascending: true);

//     setState(() => _messages = List<Map<String, dynamic>>.from(response));
//   }

//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');
//     _channel!
//         .onPostgresChanges(
//           event: PostgresChangeEvent.insert,
//           schema: 'public',
//           table: 'messages',
//           callback: (payload) {
//             final newMsg = payload.newRecord;
//             if (newMsg != null && newMsg['order_id'] == widget.orderId) {
//               setState(() => _messages.add(Map<String, dynamic>.from(newMsg)));
//             }
//           },
//         )
//         .subscribe();
//   }

//   /// ✅ Fixed Send Message Function
//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final senderId = currentUser.id;
//     final receiverId =
//         senderId == widget.customerId ? widget.tailorId : widget.customerId;

//     try {
//       // ✅ Ensure both users exist in profiles
//       await ensureUserProfileExists(senderId, currentUser.email);
//       await ensureUserProfileExists(receiverId, null);

//       // ✅ Now send the message
//       await supabase.from('messages').insert({
//         'sender_id': senderId,
//         'receiver_id': receiverId,
//         'order_id': widget.orderId,
//         'message': text,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _msgController.clear();
//     } catch (e) {
//       debugPrint('❌ Error sending message: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 final isMe = msg['sender_id'] == supabase.auth.currentUser?.id;
//                 final time = DateFormat.Hm().format(
//                   DateTime.tryParse(msg['created_at'] ?? '') ?? DateTime.now(),
//                 );

//                 return Align(
//                   alignment:
//                       isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.blueAccent : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           msg['message'] ?? '',
//                           style: TextStyle(
//                             color: isMe ? Colors.white : Colors.black,
//                             fontSize: 15,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           time,
//                           style: TextStyle(
//                             color: isMe ? Colors.white70 : Colors.black54,
//                             fontSize: 10,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           SafeArea(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _msgController,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message...',
//                         border: OutlineInputBorder(),
//                         isDense: true,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     color: Colors.blueAccent,
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/utils/profile_helper.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   Future<void> _fetchMessages() async {
//     final response = await supabase
//         .from('messages')
//         .select()
//         .eq('order_id', widget.orderId)
//         .order('created_at', ascending: true);

//     setState(() => _messages = List<Map<String, dynamic>>.from(response));
//   }

//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');
//     _channel!
//         .onPostgresChanges(
//           event: PostgresChangeEvent.insert,
//           schema: 'public',
//           table: 'messages',
//           callback: (payload) {
//             final newMsg = payload.newRecord;
//             if (newMsg != null && newMsg['order_id'] == widget.orderId) {
//               setState(() => _messages.add(Map<String, dynamic>.from(newMsg)));
//             }
//           },
//         )
//         .subscribe();
//   }

//   /// ✅ Fixed Send Message Function with Debug Prints
//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final senderId = currentUser.id;
//     final receiverId =
//         senderId == widget.customerId ? widget.tailorId : widget.customerId;

//     // 👇 Debug prints to trace IDs
//     print('📩 senderId: $senderId');
//     print('📩 receiverId: $receiverId');
//     print('📦 orderId: ${widget.orderId}');

//     try {
//       // ✅ Ensure both users exist in profiles
//       await ensureUserProfileExists(senderId, currentUser.email);
//       await ensureUserProfileExists(receiverId, null);

//       // ✅ Now send the message
//       await supabase.from('messages').insert({
//         'sender_id': senderId,
//         'receiver_id': receiverId,
//         'order_id': widget.orderId,
//         'message': text,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _msgController.clear();
//     } catch (e) {
//       debugPrint('❌ Error sending message: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 final isMe = msg['sender_id'] == supabase.auth.currentUser?.id;
//                 final time = DateFormat.Hm().format(
//                   DateTime.tryParse(msg['created_at'] ?? '') ?? DateTime.now(),
//                 );

//                 return Align(
//                   alignment:
//                       isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.blueAccent : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           msg['message'] ?? '',
//                           style: TextStyle(
//                             color: isMe ? Colors.white : Colors.black,
//                             fontSize: 15,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           time,
//                           style: TextStyle(
//                             color: isMe ? Colors.white70 : Colors.black54,
//                             fontSize: 10,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _msgController,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message...',
//                         border: OutlineInputBorder(),
//                         isDense: true,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     color: Colors.blueAccent,
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/utils/profile_helper.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   /// ✅ Fetch all messages for this order between these two users
//   Future<void> _fetchMessages() async {
//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final response = await supabase
//         .from('messages')
//         .select()
//         .eq('order_id', widget.orderId)
//         .order('created_at', ascending: true);

//     setState(() {
//       _messages = List<Map<String, dynamic>>.from(response);
//     });

//     print("✅ Loaded ${_messages.length} messages");
//   }

//   /// ✅ Subscribe to realtime new messages
//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');
//     _channel!
//         .onPostgresChanges(
//           event: PostgresChangeEvent.insert,
//           schema: 'public',
//           table: 'messages',
//           callback: (payload) {
//             final newMsg = payload.newRecord;
//             if (newMsg == null) return;

//             // Filter messages by same order_id
//             if (newMsg['order_id'] == widget.orderId) {
//               setState(() {
//                 _messages.add(Map<String, dynamic>.from(newMsg));
//               });
//               print("💬 New message added: ${newMsg['message']}");
//             }
//           },
//         )
//         .subscribe();
//   }

//   /// ✅ Send Message
//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final senderId = currentUser.id;
//     final receiverId =
//         senderId == widget.customerId ? widget.tailorId : widget.customerId;

//     // 👇 Debug prints to trace IDs
//     print('📩 senderId: $senderId');
//     print('📩 receiverId: $receiverId');
//     print('📦 orderId: ${widget.orderId}');

//     try {
//       // ✅ Ensure both users exist in profiles
//       await ensureUserProfileExists(senderId, currentUser.email);
//       await ensureUserProfileExists(receiverId, null);

//       // ✅ Insert the message
//       await supabase.from('messages').insert({
//         'sender_id': senderId,
//         'receiver_id': receiverId,
//         'order_id': widget.orderId,
//         'message': text,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _msgController.clear();

//       // ✅ Immediately show in local UI (no need to wait for realtime)
//       setState(() {
//         _messages.add({
//           'sender_id': senderId,
//           'receiver_id': receiverId,
//           'order_id': widget.orderId,
//           'message': text,
//           'created_at': DateTime.now().toIso8601String(),
//         });
//       });
//     } catch (e) {
//       debugPrint('❌ Error sending message: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: _messages.isEmpty
//                 ? const Center(child: Text("No messages yet"))
//                 : ListView.builder(
//                     padding: const EdgeInsets.all(10),
//                     itemCount: _messages.length,
//                     itemBuilder: (context, index) {
//                       final msg = _messages[index];
//                       final isMe =
//                           msg['sender_id'] == supabase.auth.currentUser?.id;
//                       final time = DateFormat.Hm().format(
//                         DateTime.tryParse(msg['created_at'] ?? '') ??
//                             DateTime.now(),
//                       );

//                       return Align(
//                         alignment: isMe
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(vertical: 4),
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color:
//                                 isMe ? Colors.blueAccent : Colors.grey[300],
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text(
//                                 msg['message'] ?? '',
//                                 style: TextStyle(
//                                   color: isMe ? Colors.white : Colors.black,
//                                   fontSize: 15,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 time,
//                                 style: TextStyle(
//                                   color: isMe
//                                       ? Colors.white70
//                                       : Colors.black54,
//                                   fontSize: 10,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//           const Divider(height: 1),
//           SafeArea(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _msgController,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message...',
//                         border: OutlineInputBorder(),
//                         isDense: true,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     color: Colors.blueAccent,
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/utils/profile_helper.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   /// ✅ Fetch all messages for this order between these two users
//   Future<void> _fetchMessages() async {
//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final response = await supabase
//         .from('messages')
//         .select()
//         .eq('order_id', widget.orderId)
//         .order('created_at', ascending: true);

//     setState(() {
//       _messages = List<Map<String, dynamic>>.from(response);
//     });

//     print("✅ Loaded ${_messages.length} messages");
//   }

//   /// ✅ Subscribe to realtime new messages
//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');
//     _channel!
//         .onPostgresChanges(
//           event: PostgresChangeEvent.insert,
//           schema: 'public',
//           table: 'messages',
//           callback: (payload) {
//             final newMsg = payload.newRecord;
//             if (newMsg == null) return;

//             // Filter messages by same order_id
//             if (newMsg['order_id'] == widget.orderId) {
//               setState(() {
//                 _messages.add(Map<String, dynamic>.from(newMsg));
//               });
//               print("💬 New message added: ${newMsg['message']}");
//             }
//           },
//         )
//         .subscribe();
//   }

//   /// ✅ Send Message
//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final senderId = currentUser.id;
//     final receiverId =
//         senderId == widget.customerId ? widget.tailorId : widget.customerId;

//     // 👇 Debug prints to trace IDs
//     print('📩 senderId: $senderId');
//     print('📩 receiverId: $receiverId');
//     print('📦 orderId: ${widget.orderId}');

//     try {
//       // ✅ Ensure both users exist in profiles
//       await ensureUserProfileExists(senderId, currentUser.email);
//       await ensureUserProfileExists(receiverId, null);

//       // ✅ Insert the message
//       await supabase.from('messages').insert({
//         'sender_id': senderId,
//         'receiver_id': receiverId,
//         'order_id': widget.orderId,
//         'message': text,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _msgController.clear();

//       // ✅ Immediately show in local UI
//       setState(() {
//         _messages.add({
//           'sender_id': senderId,
//           'receiver_id': receiverId,
//           'order_id': widget.orderId,
//           'message': text,
//           'created_at': DateTime.now().toIso8601String(),
//         });
//       });
//     } catch (e) {
//       debugPrint('❌ Error sending message: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset:
//           true, // ✅ allows screen to adjust when keyboard opens
//       appBar: AppBar(title: const Text('Chat')),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ✅ Messages List
//             Expanded(
//               child: _messages.isEmpty
//                   ? const Center(child: Text("No messages yet"))
//                   : ListView.builder(
//                       padding: const EdgeInsets.all(10),
//                       itemCount: _messages.length,
//                       reverse:
//                           false, // keep newest messages at bottom like WhatsApp
//                       itemBuilder: (context, index) {
//                         final msg = _messages[index];
//                         final isMe =
//                             msg['sender_id'] == supabase.auth.currentUser?.id;
//                         final time = DateFormat.Hm().format(
//                           DateTime.tryParse(msg['created_at'] ?? '') ??
//                               DateTime.now(),
//                         );

//                         return Align(
//                           alignment: isMe
//                               ? Alignment.centerRight
//                               : Alignment.centerLeft,
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 4),
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color:
//                                   isMe ? Colors.blueAccent : Colors.grey[300],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   msg['message'] ?? '',
//                                   style: TextStyle(
//                                     color:
//                                         isMe ? Colors.white : Colors.black87,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   time,
//                                   style: TextStyle(
//                                     color:
//                                         isMe ? Colors.white70 : Colors.black54,
//                                     fontSize: 10,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),

//             // ✅ Message Input Field
//             const Divider(height: 1),
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: SafeArea(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _msgController,
//                         decoration: const InputDecoration(
//                           hintText: 'Type a message...',
//                           border: OutlineInputBorder(),
//                           isDense: true,
//                         ),
//                         onSubmitted: (_) => _sendMessage(),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     IconButton(
//                       icon: const Icon(Icons.send),
//                       color: Colors.blueAccent,
//                       onPressed: _sendMessage,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/utils/profile_helper.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   /// ✅ Fetch all messages for this order between these two users
//   Future<void> _fetchMessages() async {
//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final response = await supabase
//         .from('messages')
//         .select()
//         .eq('order_id', widget.orderId)
//         .order('created_at', ascending: true);

//     setState(() {
//       _messages = List<Map<String, dynamic>>.from(response);
//     });

//     _scrollToBottom();
//     print("✅ Loaded ${_messages.length} messages");
//   }

//   /// ✅ Subscribe to realtime new messages
//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');
//     _channel!
//         .onPostgresChanges(
//           event: PostgresChangeEvent.insert,
//           schema: 'public',
//           table: 'messages',
//           callback: (payload) {
//             final newMsg = payload.newRecord;
//             if (newMsg == null) return;

//             // Filter messages by same order_id
//             if (newMsg['order_id'] == widget.orderId) {
//               setState(() {
//                 _messages.add(Map<String, dynamic>.from(newMsg));
//               });
//               _scrollToBottom();
//               print("💬 New message added: ${newMsg['message']}");
//             }
//           },
//         )
//         .subscribe();
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//       }
//     });
//   }

//   /// ✅ Send Message
//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final senderId = currentUser.id;
//     final receiverId =
//         senderId == widget.customerId ? widget.tailorId : widget.customerId;

//     print('📩 senderId: $senderId');
//     print('📩 receiverId: $receiverId');
//     print('📦 orderId: ${widget.orderId}');

//     try {
//       // ✅ Ensure both users exist in profiles
//       await ensureUserProfileExists(senderId, currentUser.email);
//       await ensureUserProfileExists(receiverId, null);

//       // ✅ Insert the message
//       await supabase.from('messages').insert({
//         'sender_id': senderId,
//         'receiver_id': receiverId,
//         'order_id': widget.orderId,
//         'message': text,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _msgController.clear();

//       // ✅ Immediately show in local UI
//       setState(() {
//         _messages.add({
//           'sender_id': senderId,
//           'receiver_id': receiverId,
//           'order_id': widget.orderId,
//           'message': text,
//           'created_at': DateTime.now().toIso8601String(),
//         });
//       });

//       _scrollToBottom();
//     } catch (e) {
//       debugPrint('❌ Error sending message: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset:
//           true, // ✅ Screen adjusts when keyboard opens
//       appBar: AppBar(title: const Text('Chat')),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ✅ Messages List
//             Expanded(
//               child: _messages.isEmpty
//                   ? const Center(child: Text("No messages yet"))
//                   : ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.all(10),
//                       itemCount: _messages.length,
//                       reverse: false,
//                       itemBuilder: (context, index) {
//                         final msg = _messages[index];
//                         final isMe =
//                             msg['sender_id'] == supabase.auth.currentUser?.id;
//                         final time = DateFormat.Hm().format(
//                           DateTime.tryParse(msg['created_at'] ?? '') ??
//                               DateTime.now(),
//                         );

//                         return Align(
//                           alignment: isMe
//                               ? Alignment.centerRight
//                               : Alignment.centerLeft,
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 4),
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color:
//                                   isMe ? Colors.blueAccent : Colors.grey[300],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   msg['message'] ?? '',
//                                   style: TextStyle(
//                                     color:
//                                         isMe ? Colors.white : Colors.black87,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   time,
//                                   style: TextStyle(
//                                     color:
//                                         isMe ? Colors.white70 : Colors.black54,
//                                     fontSize: 10,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),

//             // ✅ Input Field (Fixed Overflow)
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
//               child: SafeArea(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _msgController,
//                         decoration: const InputDecoration(
//                           hintText: 'Type a message...',
//                           border: OutlineInputBorder(),
//                           isDense: true,
//                           contentPadding:
//                               EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                         ),
//                         onSubmitted: (_) => _sendMessage(),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     IconButton(
//                       icon: const Icon(Icons.send),
//                       color: Colors.blueAccent,
//                       onPressed: _sendMessage,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }pkaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/utils/profile_helper.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   /// Fetch all messages for this order (both sides)
//   Future<void> _fetchMessages() async {
//     final response = await supabase
//         .from('messages')
//         .select()
//         .eq('order_id', widget.orderId)
//         .order('created_at', ascending: true);

//     setState(() {
//       _messages = List<Map<String, dynamic>>.from(response);
//     });

//     _scrollToBottom();
//     print("✅ Loaded ${_messages.length} messages (both sides)");
//   }

//   /// Subscribe to realtime messages for this order
//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');
//     _channel!
//         .onPostgresChanges(
//           event: PostgresChangeEvent.insert,
//           schema: 'public',
//           table: 'messages',
//           callback: (payload) {
//             final newMsg = payload.newRecord;
//             if (newMsg == null) return;

//             // ✅ Only add messages for this order
//             if (newMsg['order_id'] == widget.orderId) {
//               setState(() {
//                 _messages.add(Map<String, dynamic>.from(newMsg));
//               });
//               _scrollToBottom();
//               print("💬 New message added: ${newMsg['message']}");
//             }
//           },
//         )
//         .subscribe();
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//       }
//     });
//   }

//   /// Send message
//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final senderId = currentUser.id;
//     final receiverId =
//         senderId == widget.customerId ? widget.tailorId : widget.customerId;

//     try {
//       await ensureUserProfileExists(senderId, currentUser.email);
//       await ensureUserProfileExists(receiverId, null);

//       final newMessage = {
//         'sender_id': senderId,
//         'receiver_id': receiverId,
//         'order_id': widget.orderId,
//         'message': text,
//         'created_at': DateTime.now().toIso8601String(),
//       };

//       await supabase.from('messages').insert(newMessage);

//       _msgController.clear();

//       setState(() {
//         _messages.add(newMessage);
//       });

//       _scrollToBottom();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: _messages.isEmpty
//                   ? const Center(child: Text("No messages yet"))
//                   : ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.all(10),
//                       itemCount: _messages.length,
//                       itemBuilder: (context, index) {
//                         final msg = _messages[index];
//                         final isMe =
//                             msg['sender_id'] == supabase.auth.currentUser?.id;
//                         final time = DateFormat.Hm().format(
//                           DateTime.tryParse(msg['created_at'] ?? '') ??
//                               DateTime.now(),
//                         );

//                         return Align(
//                           alignment: isMe
//                               ? Alignment.centerRight
//                               : Alignment.centerLeft,
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 4),
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color:
//                                   isMe ? Colors.blueAccent : Colors.grey[300],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   msg['message'] ?? '',
//                                   style: TextStyle(
//                                     color:
//                                         isMe ? Colors.white : Colors.black87,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   time,
//                                   style: TextStyle(
//                                     color:
//                                         isMe ? Colors.white70 : Colors.black54,
//                                     fontSize: 10,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
//               child: SafeArea(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _msgController,
//                         decoration: const InputDecoration(
//                           hintText: 'Type a message...',
//                           border: OutlineInputBorder(),
//                           isDense: true,
//                           contentPadding:
//                               EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                         ),
//                         onSubmitted: (_) => _sendMessage(),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     IconButton(
//                       icon: const Icon(Icons.send),
//                       color: Colors.blueAccent,
//                       onPressed: _sendMessage,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/utils/profile_helper.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   /// ✅ Fetch all messages for this order (Tailor + Customer)
//   Future<void> _fetchMessages() async {
//     final response = await supabase
//         .from('messages')
//         .select()
//         .eq('order_id', widget.orderId)
//         .order('created_at', ascending: true);

//     setState(() {
//       _messages = List<Map<String, dynamic>>.from(response);
//     });

//     _scrollToBottom();
//     print("✅ Loaded ${_messages.length} messages (both sides)");
//   }

//   /// ✅ Realtime subscription for this order
//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');
//     _channel!.onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'messages',
//       callback: (payload) {
//         final newMsg = payload.newRecord;
//         if (newMsg == null) return;

//         if (newMsg['order_id'] == widget.orderId) {
//           setState(() {
//             _messages.add(Map<String, dynamic>.from(newMsg));
//           });
//           _scrollToBottom();
//         }
//       },
//     ).subscribe();
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController
//             .jumpTo(_scrollController.position.maxScrollExtent);
//       }
//     });
//   }

//   /// ✅ Send message
//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     final senderId = currentUser.id;
//     final receiverId =
//         senderId == widget.customerId ? widget.tailorId : widget.customerId;

//     final newMessage = {
//       'sender_id': senderId,
//       'receiver_id': receiverId,
//       'order_id': widget.orderId,
//       'message': text,
//       'created_at': DateTime.now().toIso8601String(),
//     };

//     try {
//       await ensureUserProfileExists(senderId, currentUser.email);
//       await ensureUserProfileExists(receiverId, null);

//       await supabase.from('messages').insert(newMessage);

//       _msgController.clear();

//       setState(() {
//         _messages.add(newMessage);
//       });

//       _scrollToBottom();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: _messages.isEmpty
//                   ? const Center(child: Text("No messages yet"))
//                   : ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.all(10),
//                       itemCount: _messages.length,
//                       itemBuilder: (context, index) {
//                         final msg = _messages[index];
//                         final isMe =
//                             msg['sender_id'] == supabase.auth.currentUser?.id;
//                         final time = DateFormat.Hm().format(
//                           DateTime.tryParse(msg['created_at'] ?? '') ??
//                               DateTime.now(),
//                         );

//                         return Align(
//                           alignment: isMe
//                               ? Alignment.centerRight
//                               : Alignment.centerLeft,
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 4),
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color:
//                                   isMe ? Colors.blueAccent : Colors.grey[300],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   msg['message'] ?? '',
//                                   style: TextStyle(
//                                     color:
//                                         isMe ? Colors.white : Colors.black87,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   time,
//                                   style: TextStyle(
//                                     color:
//                                         isMe ? Colors.white70 : Colors.black54,
//                                     fontSize: 10,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
//               child: SafeArea(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _msgController,
//                         decoration: const InputDecoration(
//                           hintText: 'Type a message...',
//                           border: OutlineInputBorder(),
//                           isDense: true,
//                           contentPadding:
//                               EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                         ),
//                         onSubmitted: (_) => _sendMessage(),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     IconButton(
//                       icon: const Icon(Icons.send),
//                       color: Colors.blueAccent,
//                       onPressed: _sendMessage,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/utils/profile_helper.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String tailorId;
//   final String customerId;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.tailorId,
//     required this.customerId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   /// Fetch all messages for this order (Tailor + Customer)
//   Future<void> _fetchMessages() async {
//     try {
//       final response = await supabase
//           .from('messages')
//           .select()
//           .eq('order_id', widget.orderId)
//           .order('created_at', ascending: true);

//       setState(() {
//         _messages = List<Map<String, dynamic>>.from(response);
//       });

//       _scrollToBottom();
//       print("✅ Loaded ${_messages.length} messages (both sides)");
//     } catch (e) {
//       debugPrint('❌ Failed to fetch messages: $e');
//     }
//   }

//   /// Subscribe to new messages in realtime
//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');
//     _channel!.onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'messages',
//       callback: (payload) {
//         final newMsg = payload.newRecord;
//         if (newMsg == null) return;

//         // Only messages for this order
//         if (newMsg['order_id'] == widget.orderId) {
//           setState(() {
//             _messages.add(Map<String, dynamic>.from(newMsg));
//           });
//           _scrollToBottom();
//         }
//       },
//     ).subscribe();
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController
//             .jumpTo(_scrollController.position.maxScrollExtent);
//       }
//     });
//   }

//   /// Send message
//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     // Receiver is the other user
//     final senderId = currentUser.id;
//     final receiverId =
//         senderId == widget.customerId ? widget.tailorId : widget.customerId;

//     final newMessage = {
//       'sender_id': senderId,
//       'receiver_id': receiverId,
//       'order_id': widget.orderId,
//       'message': text,
//       'created_at': DateTime.now().toIso8601String(),
//     };

//     try {
//       await ensureUserProfileExists(senderId, currentUser.email);
//       await ensureUserProfileExists(receiverId, null);

//       await supabase.from('messages').insert(newMessage);

//       _msgController.clear();

//       setState(() {
//         _messages.add(newMessage);
//       });

//       _scrollToBottom();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: _messages.isEmpty
//                   ? const Center(child: Text("No messages yet"))
//                   : ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.all(10),
//                       itemCount: _messages.length,
//                       itemBuilder: (context, index) {
//                         final msg = _messages[index];
//                         final isMe =
//                             msg['sender_id'] == supabase.auth.currentUser?.id;
//                         final time = DateFormat.Hm().format(
//                           DateTime.tryParse(msg['created_at'] ?? '') ??
//                               DateTime.now(),
//                         );

//                         return Align(
//                           alignment: isMe
//                               ? Alignment.centerRight
//                               : Alignment.centerLeft,
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 4),
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color:
//                                   isMe ? Colors.blueAccent : Colors.grey[300],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   msg['message'] ?? '',
//                                   style: TextStyle(
//                                     color:
//                                         isMe ? Colors.white : Colors.black87,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   time,
//                                   style: TextStyle(
//                                     color:
//                                         isMe ? Colors.white70 : Colors.black54,
//                                     fontSize: 10,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
//               child: SafeArea(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _msgController,
//                         decoration: const InputDecoration(
//                           hintText: 'Type a message...',
//                           border: OutlineInputBorder(),
//                           isDense: true,
//                           contentPadding:
//                               EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                         ),
//                         onSubmitted: (_) => _sendMessage(),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     IconButton(
//                       icon: const Icon(Icons.send),
//                       color: Colors.blueAccent,
//                       onPressed: _sendMessage,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/utils/profile_helper.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;

//   const ChatScreen({super.key, required this.orderId});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   /// Fetch all messages for this order
//   Future<void> _fetchMessages() async {
//     try {
//       final response = await supabase
//           .from('messages')
//           .select()
//           .eq('order_id', widget.orderId)
//           .order('created_at', ascending: true);

//       setState(() {
//         _messages = List<Map<String, dynamic>>.from(response);
//       });

//       _scrollToBottom();
//       print("✅ Loaded ${_messages.length} messages for order ${widget.orderId}");
//     } catch (e) {
//       debugPrint('❌ Failed to fetch messages: $e');
//     }
//   }

//   /// Realtime subscription to new messages
//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');
//     _channel!.onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'messages',
//       callback: (payload) {
//         final newMsg = payload.newRecord;
//         if (newMsg == null) return;

//         // Only show messages for this order
//         if (newMsg['order_id'] == widget.orderId) {
//           setState(() {
//             _messages.add(Map<String, dynamic>.from(newMsg));
//           });
//           _scrollToBottom();
//         }
//       },
//     ).subscribe();
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//       }
//     });
//   }

//   /// Send message to the other party
//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     // Determine receiver: first message from the other user
//     final receiverId = _messages.isNotEmpty
//         ? _messages.firstWhere(
//             (m) => m['sender_id'] != currentUser.id,
//             orElse: () => {'sender_id': currentUser.id},
//           )['sender_id']
//         : null;

//     if (receiverId == null) return;

//     final newMessage = {
//       'sender_id': currentUser.id,
//       'receiver_id': receiverId,
//       'order_id': widget.orderId,
//       'message': text,
//       'created_at': DateTime.now().toIso8601String(),
//     };

//     try {
//       await ensureUserProfileExists(currentUser.id, currentUser.email);
//       await ensureUserProfileExists(receiverId, null);

//       await supabase.from('messages').insert(newMessage);

//       _msgController.clear();
//       setState(() {
//         _messages.add(newMessage);
//       });

//       _scrollToBottom();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentUser = supabase.auth.currentUser;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: _messages.isEmpty
//                   ? const Center(child: Text("No messages yet"))
//                   : ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.all(10),
//                       itemCount: _messages.length,
//                       itemBuilder: (context, index) {
//                         final msg = _messages[index];
//                         final isMe = msg['sender_id'] == currentUser?.id;
//                         final time = DateFormat.Hm().format(
//                           DateTime.tryParse(msg['created_at'] ?? '') ??
//                               DateTime.now(),
//                         );

//                         return Align(
//                           alignment:
//                               isMe ? Alignment.centerRight : Alignment.centerLeft,
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 4),
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: isMe ? Colors.blueAccent : Colors.grey[300],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   msg['message'] ?? '',
//                                   style: TextStyle(
//                                     color: isMe ? Colors.white : Colors.black87,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   time,
//                                   style: TextStyle(
//                                     color:
//                                         isMe ? Colors.white70 : Colors.black54,
//                                     fontSize: 10,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
//               child: SafeArea(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _msgController,
//                         decoration: const InputDecoration(
//                           hintText: 'Type a message...',
//                           border: OutlineInputBorder(),
//                           isDense: true,
//                           contentPadding:
//                               EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                         ),
//                         onSubmitted: (_) => _sendMessage(),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     IconButton(
//                       icon: const Icon(Icons.send),
//                       color: Colors.blueAccent,
//                       onPressed: _sendMessage,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }fixxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/utils/profile_helper.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;

//   const ChatScreen({super.key, required this.orderId});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   /// Fetch all messages for this order
//   Future<void> _fetchMessages() async {
//     try {
//       final response = await supabase
//           .from('messages')
//           .select()
//           .eq('order_id', widget.orderId)
//           .order('created_at', ascending: true);

//       setState(() {
//         _messages = List<Map<String, dynamic>>.from(response);
//       });

//       _scrollToBottom();
//       print("✅ Loaded ${_messages.length} messages for order ${widget.orderId}");
//     } catch (e) {
//       debugPrint('❌ Failed to fetch messages: $e');
//     }
//   }

//   /// Realtime subscription to new messages
//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');
//     _channel!.onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'messages',
//       callback: (payload) {
//         final newMsg = payload.newRecord;
//         if (newMsg == null) return;

//         if (newMsg['order_id'] == widget.orderId) {
//           setState(() {
//             _messages.add(Map<String, dynamic>.from(newMsg));
//           });
//           _scrollToBottom();
//         }
//       },
//     ).subscribe();
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//       }
//     });
//   }

//   /// Send message
//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     // Determine receiver: pick first sender not current user
//     final receiverId = _messages.isNotEmpty
//         ? _messages.firstWhere(
//             (m) => m['sender_id'] != currentUser.id,
//             orElse: () => {'sender_id': currentUser.id},
//           )['sender_id']
//         : null;

//     if (receiverId == null) return;

//     final newMessage = {
//       'sender_id': currentUser.id,
//       'receiver_id': receiverId,
//       'order_id': widget.orderId,
//       'message': text,
//       'created_at': DateTime.now().toIso8601String(),
//     };

//     try {
//       await ensureUserProfileExists(currentUser.id, currentUser.email);
//       await ensureUserProfileExists(receiverId, null);

//       await supabase.from('messages').insert(newMessage);

//       _msgController.clear();
//       setState(() {
//         _messages.add(newMessage);
//       });

//       _scrollToBottom();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentUser = supabase.auth.currentUser;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: _messages.isEmpty
//                   ? const Center(child: Text("No messages yet"))
//                   : ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.all(10),
//                       itemCount: _messages.length,
//                       itemBuilder: (context, index) {
//                         final msg = _messages[index];
//                         final isMe = msg['sender_id'] == currentUser?.id;
//                         final time = DateFormat.Hm().format(
//                           DateTime.tryParse(msg['created_at'] ?? '') ??
//                               DateTime.now(),
//                         );

//                         return Align(
//                           alignment:
//                               isMe ? Alignment.centerRight : Alignment.centerLeft,
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 4),
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: isMe ? Colors.blueAccent : Colors.grey[300],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   msg['message'] ?? '',
//                                   style: TextStyle(
//                                     color: isMe ? Colors.white : Colors.black87,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   time,
//                                   style: TextStyle(
//                                     color:
//                                         isMe ? Colors.white70 : Colors.black54,
//                                     fontSize: 10,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
//               child: SafeArea(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _msgController,
//                         decoration: const InputDecoration(
//                           hintText: 'Type a message...',
//                           border: OutlineInputBorder(),
//                           isDense: true,
//                           contentPadding:
//                               EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                         ),
//                         onSubmitted: (_) => _sendMessage(),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     IconButton(
//                       icon: const Icon(Icons.send),
//                       color: Colors.blueAccent,
//                       onPressed: _sendMessage,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/utils/profile_helper.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;

//   const ChatScreen({super.key, required this.orderId});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _msgController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   List<Map<String, dynamic>> _messages = [];
//   RealtimeChannel? _channel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMessages();
//     _subscribeToMessages();
//   }

//   /// Fetch all messages for this order
//   Future<void> _fetchMessages() async {
//     try {
//       final response = await supabase
//           .from('messages')
//           .select()
//           .eq('order_id', widget.orderId)
//           .order('created_at', ascending: true);

//       setState(() {
//         _messages = List<Map<String, dynamic>>.from(response);
//       });

//       _scrollToBottom();
//       print("✅ Loaded ${_messages.length} messages for order ${widget.orderId}");
//     } catch (e) {
//       debugPrint('❌ Failed to fetch messages: $e');
//     }
//   }

//   /// Realtime subscription to new messages
//   void _subscribeToMessages() {
//     _channel = supabase.channel('public:messages');
//     _channel!.onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'messages',
//       callback: (payload) {
//         final newMsg = payload.newRecord;
//         if (newMsg == null) return;

//         if (newMsg['order_id'] == widget.orderId) {
//           setState(() {
//             _messages.add(Map<String, dynamic>.from(newMsg));
//           });
//           _scrollToBottom();
//         }
//       },
//     ).subscribe();
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//       }
//     });
//   }

//   /// Send message
//   Future<void> _sendMessage() async {
//     final text = _msgController.text.trim();
//     if (text.isEmpty) return;

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     // Determine receiver: pick first sender not current user
//     String? receiverId;
//     if (_messages.isNotEmpty) {
//       final otherMsg = _messages.firstWhere(
//         (m) => m['sender_id'] != currentUser.id,
//         orElse: () => {'sender_id': currentUser.id},
//       );
//       receiverId = otherMsg['sender_id'].toString();
//     }

//     if (receiverId == null || receiverId == currentUser.id) {
//       // Cannot determine receiver, exit
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Cannot determine receiver')),
//       );
//       return;
//     }

//     final newMessage = {
//       'sender_id': currentUser.id,
//       'receiver_id': receiverId,
//       'order_id': widget.orderId,
//       'message': text,
//       'created_at': DateTime.now().toIso8601String(),
//     };

//     try {
//       // Ensure users exist in profiles table
//       await ensureUserProfileExists(currentUser.id, currentUser.email);
//       await ensureUserProfileExists(receiverId, null);

//       // Insert message
//       await supabase.from('messages').insert(newMessage);

//       // Clear input and hide keyboard
//       _msgController.clear();
//       FocusScope.of(context).unfocus();

//       // Update UI immediately
//       setState(() {
//         _messages.add(newMessage);
//       });

//       _scrollToBottom();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Message failed: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _msgController.dispose();
//     _channel?.unsubscribe();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentUser = supabase.auth.currentUser;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: _messages.isEmpty
//                   ? const Center(child: Text("No messages yet"))
//                   : ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.all(10),
//                       itemCount: _messages.length,
//                       itemBuilder: (context, index) {
//                         final msg = _messages[index];
//                         final isMe = msg['sender_id'] == currentUser?.id;
//                         final time = DateFormat.Hm().format(
//                           DateTime.tryParse(msg['created_at'] ?? '') ??
//                               DateTime.now(),
//                         );

//                         return Align(
//                           alignment:
//                               isMe ? Alignment.centerRight : Alignment.centerLeft,
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 4),
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color:
//                                   isMe ? Colors.blueAccent : Colors.grey[300],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   msg['message'] ?? '',
//                                   style: TextStyle(
//                                     color: isMe ? Colors.white : Colors.black87,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   time,
//                                   style: TextStyle(
//                                     color:
//                                         isMe ? Colors.white70 : Colors.black54,
//                                     fontSize: 10,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
//               child: SafeArea(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _msgController,
//                         decoration: const InputDecoration(
//                           hintText: 'Type a message...',
//                           border: OutlineInputBorder(),
//                           isDense: true,
//                           contentPadding:
//                               EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                         ),
//                         onSubmitted: (_) => _sendMessage(),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     IconButton(
//                       icon: const Icon(Icons.send),
//                       color: Colors.blueAccent,
//                       onPressed: _sendMessage,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailor_clothing_application/utils/profile_helper.dart';

class ChatScreen extends StatefulWidget {
  final String orderId;
  final String senderId;
  final String receiverId;

  const ChatScreen({
    super.key,
    required this.orderId,
    required this.senderId,
    required this.receiverId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final supabase = Supabase.instance.client;
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _subscribeToMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      final response = await supabase
          .from('messages')
          .select()
          .eq('order_id', widget.orderId)
          .order('created_at', ascending: true);

      setState(() {
        _messages = List<Map<String, dynamic>>.from(response);
      });
      _scrollToBottom();
    } catch (e) {
      debugPrint('❌ Failed to fetch messages: $e');
    }
  }

  void _subscribeToMessages() {
    _channel = supabase.channel('public:messages');
    _channel!.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'messages',
      callback: (payload) {
        final newMsg = payload.newRecord;
        if (newMsg != null && newMsg['order_id'] == widget.orderId) {
          setState(() => _messages.add(Map<String, dynamic>.from(newMsg)));
          _scrollToBottom();
        }
      },
    ).subscribe();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    final newMessage = {
      'sender_id': widget.senderId,
      'receiver_id': widget.receiverId,
      'order_id': widget.orderId,
      'message': text,
      'created_at': DateTime.now().toIso8601String(),
    };

    try {
      await ensureUserProfileExists(widget.senderId, null);
      await ensureUserProfileExists(widget.receiverId, null);

      await supabase.from('messages').insert(newMessage);

      _msgController.clear();
      FocusScope.of(context).unfocus();

      setState(() => _messages.add(newMessage));
      _scrollToBottom();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message failed: $e')),
      );
    }
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    _channel?.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? const Center(child: Text('No messages yet'))
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(10),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        final isMe = msg['sender_id'] == widget.senderId;
                        final time = DateFormat.Hm().format(
                          DateTime.tryParse(msg['created_at'] ?? '') ??
                              DateTime.now(),
                        );

                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Colors.blueAccent
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  msg['message'] ?? '',
                                  style: TextStyle(
                                    color: isMe
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  time,
                                  style: TextStyle(
                                    color: isMe
                                        ? Colors.white70
                                        : Colors.black54,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: Colors.blueAccent,
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
