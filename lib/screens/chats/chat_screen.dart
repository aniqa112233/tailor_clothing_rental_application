
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
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
  bool _sending = false;
  bool _uploadingImage = false;
  final ImagePicker _picker = ImagePicker();
  String _receiverName = 'Chat'; // Default title

  @override
  void initState() {
    super.initState();
    _fetchReceiverName();
    _fetchMessages();
    _subscribeToMessages();
  }

  // ✅ FIXED LOGIC for receiver name/email display
  Future<void> _fetchReceiverName() async {
    try {
      final response = await supabase
          .from('profiles')
          .select('name, email')
          .eq('id', widget.receiverId)
          .maybeSingle();

      if (response == null) {
        setState(() => _receiverName = 'Unknown User');
        return;
      }

      final name = (response['name'] as String?)?.trim();
      final email = (response['email'] as String?)?.trim();

      String finalName = 'Unknown User';

      if (name != null && name.isNotEmpty) {
        finalName = name;
      } else if (email != null && email.isNotEmpty) {
        // sirf @ se pehle ka part lo
        var emailName = email.split('@').first;

        // sirf alphabets rakho (digits remove)
        emailName = emailName.replaceAll(RegExp(r'[^a-zA-Z]'), '');

        // agar empty ho gaya to fallback
        finalName = emailName.isNotEmpty ? emailName : 'User';
      }

      setState(() => _receiverName = finalName);
    } catch (e) {
      debugPrint('❌ Failed to fetch receiver name: $e');
      setState(() => _receiverName = 'Unknown User');
    }
  }

  Future<void> _fetchMessages() async {
    try {
      final response = await supabase
          .from('messages')
          .select()
          .eq('order_id', widget.orderId)
          .order('created_at', ascending: true);

      // ignore: unnecessary_null_comparison
      if (response != null) {
        setState(() {
          _messages = List<Map<String, dynamic>>.from(response);
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint('❌ Failed to fetch messages: $e');
    }
  }

  void _subscribeToMessages() {
    _channel = supabase.channel('public:messages');
    _channel!
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'messages',
      callback: (payload) {
        final newMsg = payload.newRecord;
        // ignore: unnecessary_null_comparison
        if (newMsg != null &&
            newMsg['order_id'] != null &&
            newMsg['order_id'] == widget.orderId) {
          setState(() {
            _messages.add(Map<String, dynamic>.from(newMsg));
          });
          _scrollToBottom();
        }
      },
    ).subscribe();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _sendMessage({String? imageUrl}) async {
    final text = _msgController.text.trim();
    if ((text.isEmpty && imageUrl == null) || _sending) return;

    if (widget.senderId.isEmpty ||
        widget.receiverId.isEmpty ||
        widget.senderId == "null" ||
        widget.receiverId == "null") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Invalid sender or receiver ID')),
      );
      return;
    }

    setState(() => _sending = true);

    final newMessage = {
      'sender_id': widget.senderId,
      'receiver_id': widget.receiverId,
      'order_id': widget.orderId,
      'message': (text.isEmpty && imageUrl != null) ? '' : text,
      'image_url': imageUrl ?? '',
      'reaction': null,
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
        SnackBar(content: Text('❌ Message failed: $e')),
      );
    } finally {
      setState(() => _sending = false);
    }
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 70);
      if (picked == null) return;

      setState(() => _uploadingImage = true);

      final file = File(picked.path);
      final fileName =
          '${widget.senderId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      await supabase.storage.from('chat_images').upload(fileName, file);
      final imageUrl =
          supabase.storage.from('chat_images').getPublicUrl(fileName);

      await _sendMessage(imageUrl: imageUrl);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Image upload failed: $e')),
      );
    } finally {
      setState(() => _uploadingImage = false);
    }
  }

  Future<void> _editMessage(Map<String, dynamic> message) async {
    final controller = TextEditingController(text: message['message'] ?? '');
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Message'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final newText = controller.text.trim();
              if (newText.isNotEmpty) {
                await supabase
                    .from('messages')
                    .update({'message': newText})
                    .eq('id', message['id']);
                setState(() {
                  message['message'] = newText;
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteMessage(Map<String, dynamic> message) async {
    final confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true && message['id'] != null) {
      await supabase.from('messages').delete().eq('id', message['id']);
      setState(() => _messages.remove(message));
    }
  }

  Future<void> _reactToMessage(Map<String, dynamic> message) async {
    if (message['id'] == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final reactions = [
          '👍', '❤️', '😂', '😮', '😢', '🔥', '👏', '😎', '🙌', '💯',
          '🤔', '🎉', '😍', '🥰', '😅', '😆', '🙏', '🤯', '😴', '😇'
        ];
        return Container(
          height: 180,
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const Text('React to message',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: reactions.map((emoji) {
                    return GestureDetector(
                      onTap: () async {
                        Navigator.pop(ctx);
                        try {
                          await supabase
                              .from('messages')
                              .update({'reaction': emoji})
                              .eq('id', message['id']);
                          setState(() {
                            message['reaction'] = emoji;
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('❌ Failed to add reaction: $e')),
                          );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(emoji, style: const TextStyle(fontSize: 28)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMessageOptions(Map<String, dynamic> msg) {
    final bool isImage = (msg['image_url'] ?? '').toString().isNotEmpty;
    final bool isMyMsg = msg['sender_id'] == widget.senderId;

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.emoji_emotions_outlined),
                title: const Text("React"),
                onTap: () {
                  Navigator.pop(ctx);
                  _reactToMessage(msg);
                },
              ),
              if (isMyMsg && !isImage)
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text("Edit"),
                  onTap: () {
                    Navigator.pop(ctx);
                    _editMessage(msg);
                  },
                ),
              if (isMyMsg)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Delete"),
                  onTap: () {
                    Navigator.pop(ctx);
                    _deleteMessage(msg);
                  },
                ),
            ],
          ),
        );
      },
    );
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
      appBar: AppBar(
        title: Text(
          _receiverName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_uploadingImage)
              Container(
                color: Colors.blue.withOpacity(0.1),
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                    SizedBox(width: 10),
                    Text("Sending image...",
                        style: TextStyle(color: Colors.blueAccent)),
                  ],
                ),
              ),
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
                        final createdAt = msg['created_at']?.toString() ?? '';
                        final time = DateFormat.Hm().format(
                          DateTime.tryParse(createdAt) ?? DateTime.now(),
                        );

                        return GestureDetector(
                          onTap: () => _showMessageOptions(msg),
                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? Colors.blueAccent
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      if ((msg['image_url'] ?? '')
                                          .toString()
                                          .isNotEmpty)
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            msg['image_url'],
                                            width: 200,
                                            height: 200,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(Icons.broken_image),
                                          ),
                                        ),
                                      if ((msg['message'] ?? '')
                                          .toString()
                                          .isNotEmpty)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                            msg['message'],
                                            style: TextStyle(
                                              color: isMe
                                                  ? Colors.white
                                                  : Colors.black87,
                                              fontSize: 15,
                                            ),
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
                              ),
                              if ((msg['reaction'] ?? '').toString().isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 3,
                                    left: isMe ? 0 : 12,
                                    right: isMe ? 12 : 0,
                                  ),
                                  child: Text(
                                    msg['reaction'],
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ),
                            ],
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
                    IconButton(
                      icon: const Icon(Icons.photo_camera),
                      color: Colors.blueAccent,
                      onPressed: _uploadingImage
                          ? null
                          : () => _pickAndUploadImage(ImageSource.camera),
                    ),
                    IconButton(
                      icon: const Icon(Icons.image),
                      color: Colors.blueAccent,
                      onPressed: _uploadingImage
                          ? null
                          : () => _pickAndUploadImage(ImageSource.gallery),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        textInputAction: TextInputAction.send,
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
                      color: _sending ? Colors.grey : Colors.blueAccent,
                      onPressed: _sending ? null : _sendMessage,
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
