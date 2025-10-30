
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/tailor_provider.dart';
import '../../widgets/primary_button.dart';
import '../auth/login_screen.dart'; // 👈 make sure correct import path ho

class TailorProfileScreen extends StatefulWidget {
  const TailorProfileScreen({super.key});

  @override
  State<TailorProfileScreen> createState() => _TailorProfileScreenState();
}

class _TailorProfileScreenState extends State<TailorProfileScreen> {
  final _shopNameC = TextEditingController();
  final _serviceC = TextEditingController();
  final _areaC = TextEditingController();

  File? _profileImage;
  String? _profileImageUrl;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData();
    });
  }

  Future<void> _loadProfileData() async {
    final profile = Provider.of<TailorProvider>(context, listen: false).tailorProfile;
    setState(() {
      _shopNameC.text = profile?['shop_name'] ?? '';
      _serviceC.text = profile?['services']?.join(', ') ?? '';
      _areaC.text = profile?['delivery_area'] ?? '';
      _profileImageUrl = profile?['profile_image'];
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile == null) return;
    setState(() {
      _profileImage = File(pickedFile.path);
    });
  }

  Future<String?> _uploadProfileImage(File file) async {
    try {
      final supabase = Supabase.instance.client;
      final fileExt = file.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      await supabase.storage.from('profile_pictures').upload(fileName, file);
      final url = supabase.storage.from('profile_pictures').getPublicUrl(fileName);
      return url;
    } catch (e) {
      print('❌ Image upload failed: $e');
      return null;
    }
  }

  Future<void> _deleteProfileImage(String imageUrl) async {
    try {
      final supabase = Supabase.instance.client;
      final path = imageUrl.split('/').last;
      await supabase.storage.from('profile_pictures').remove([path]);
      print('✅ Image deleted successfully');
    } catch (e) {
      print('❌ Image delete error: $e');
    }
  }

  Future<void> _saveProfile() async {
    final tailor = Provider.of<TailorProvider>(context, listen: false);
    String? imageUrl = _profileImageUrl;

    if (_profileImage != null) {
      if (imageUrl != null && imageUrl.isNotEmpty) {
        await _deleteProfileImage(imageUrl);
      }
      final uploadedUrl = await _uploadProfileImage(_profileImage!);
      if (uploadedUrl != null) {
        imageUrl = uploadedUrl;
      }
    }

    await tailor.updateTailorProfile({
      'shop_name': _shopNameC.text,
      'services': _serviceC.text.split(',').map((e) => e.trim()).toList(),
      'delivery_area': _areaC.text,
      'profile_image': imageUrl,
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  /// 🔹 Logout function
  Future<void> _logout() async {
    try {
      final supabase = Supabase.instance.client;
      await supabase.auth.signOut();

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      print('❌ Logout failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tailor = Provider.of<TailorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tailor Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Picture Section
            Stack(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : (_profileImageUrl != null && _profileImageUrl!.isNotEmpty
                          ? NetworkImage(_profileImageUrl!) as ImageProvider
                          : null),
                  child: (_profileImage == null && (_profileImageUrl == null || _profileImageUrl!.isEmpty))
                      ? const Icon(Icons.person, size: 55, color: Colors.white70)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'camera') {
                        await _pickImage(ImageSource.camera);
                      } else if (value == 'gallery') {
                        await _pickImage(ImageSource.gallery);
                      } else if (value == 'delete') {
                        if (_profileImageUrl != null) {
                          await _deleteProfileImage(_profileImageUrl!);
                        }
                        setState(() {
                          _profileImage = null;
                          _profileImageUrl = null;
                        });
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'camera', child: Text('Take Photo')),
                      const PopupMenuItem(value: 'gallery', child: Text('Choose from Gallery')),
                      const PopupMenuItem(value: 'delete', child: Text('Remove Photo')),
                    ],
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _shopNameC,
              decoration: const InputDecoration(labelText: 'Shop Name'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _serviceC,
              decoration: const InputDecoration(labelText: 'Services (comma separated)'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _areaC,
              decoration: const InputDecoration(labelText: 'Delivery Area'),
            ),
            const SizedBox(height: 20),

            PrimaryButton(
              label: 'Update Profile',
              loading: tailor.loading,
              onPressed: _saveProfile,
            ),
          ],
        ),
      ),
    );
  }
}

