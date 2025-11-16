import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/tailor_provider.dart';
import '../../widgets/primary_button.dart';
import '../../utils/app_theme.dart';
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
        title: const Text(
          'Tailor Profile',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Picture Section
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primary,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 65,
                    backgroundColor: AppTheme.primary.withOpacity(0.1),
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : (_profileImageUrl != null && _profileImageUrl!.isNotEmpty
                            ? NetworkImage(_profileImageUrl!) as ImageProvider
                            : null),
                    child: (_profileImage == null && (_profileImageUrl == null || _profileImageUrl!.isEmpty))
                        ? Icon(
                            Icons.person,
                            size: 65,
                            color: AppTheme.primary.withOpacity(0.5),
                          )
                        : null,
                  ),
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
                      const PopupMenuItem(
                        value: 'camera',
                        child: Row(
                          children: [
                            Icon(Icons.camera_alt, size: 20),
                            SizedBox(width: 8),
                            Text('Take Photo'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'gallery',
                        child: Row(
                          children: [
                            Icon(Icons.photo_library, size: 20),
                            SizedBox(width: 8),
                            Text('Choose from Gallery'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Remove Photo', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.accent, AppTheme.accent.withOpacity(0.8)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accent.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 22),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Form Fields Section with Card
            Card(
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.store,
                          color: AppTheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Shop Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _shopNameC,
                      decoration: InputDecoration(
                        labelText: 'Shop Name',
                        prefixIcon: Icon(Icons.business, color: AppTheme.primary),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppTheme.primary, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _serviceC,
                      decoration: InputDecoration(
                        labelText: 'Services (comma separated)',
                        prefixIcon: Icon(Icons.design_services, color: AppTheme.primary),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppTheme.primary, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _areaC,
                      decoration: InputDecoration(
                        labelText: 'Delivery Area',
                        prefixIcon: Icon(Icons.location_on, color: AppTheme.primary),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppTheme.primary, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            PrimaryButton(
              label: 'Update Profile',
              loading: tailor.loading,
              onPressed: _saveProfile,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}