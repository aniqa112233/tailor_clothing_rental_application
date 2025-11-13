
import 'dart:io';
// ignore: unused_import
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailor_clothing_application/providers/catalog_provider.dart';

class UploadCustomDesignScreen extends StatefulWidget {
  const UploadCustomDesignScreen({super.key});

  @override
  State<UploadCustomDesignScreen> createState() =>
      _UploadCustomDesignScreenState();
}

class _UploadCustomDesignScreenState extends State<UploadCustomDesignScreen> {
  File? _image;
  final _notesController = TextEditingController();
  bool _uploading = false;
  final ImagePicker _picker = ImagePicker();

  // ✅ Show options (Camera or Gallery)
  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera, color: Colors.blueAccent),
              title: const Text('Take Photo from Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Image picker with both sources
  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1024,
      );

      if (!mounted) return;

      if (picked != null) {
        setState(() => _image = File(picked.path));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image pick failed: $e')),
      );
    }
  }

  // ✅ Upload to Supabase (unchanged)
  Future<void> _upload() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first.')),
      );
      return;
    }

    setState(() => _uploading = true);
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser!.id;
      final bytes = await _image!.readAsBytes();

      await Provider.of<CatalogProvider>(context, listen: false)
          .uploadCustomDesign(bytes, _notesController.text, userId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Design uploaded successfully!')),
      );

      setState(() {
        _image = null;
        _notesController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Custom Design')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _image != null
                  ? Image.file(_image!, height: 180)
                  : const Placeholder(fallbackHeight: 180),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _showImageSourceDialog,
                icon: const Icon(Icons.photo_library),
                label: const Text('Pick Design Image'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Design Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              _uploading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _upload,
                      icon: const Icon(Icons.cloud_upload_outlined),
                      label: const Text('Upload Design'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 14),
                        backgroundColor: Colors.blueAccent,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
