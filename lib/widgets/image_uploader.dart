
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/tailor_provider.dart';
import 'primary_button.dart';

class ImageUploader extends StatefulWidget {
  const ImageUploader({super.key});

  @override
  State<ImageUploader> createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  File? _image;
  final _titleC = TextEditingController();
  final _priceC = TextEditingController();
  bool _loading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _uploadDesign() async {
    if (_image == null || _titleC.text.isEmpty || _priceC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    setState(() => _loading = true);
    final tailor = Provider.of<TailorProvider>(context, listen: false);

    try {
      await tailor.addDesign({
        'title': _titleC.text,
        'price': double.parse(_priceC.text),
        'image_file': _image!,
      });

      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading design: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Design')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _image == null
                    ? const Center(child: Text('Tap to select image'))
                    : Image.file(
                        _image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.broken_image, size: 50));
                        },
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(controller: _titleC, decoration: const InputDecoration(labelText: 'Design Title')),
            const SizedBox(height: 12),
            TextField(
              controller: _priceC,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price (PKR)'),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Save Design',
              loading: _loading,
              onPressed: _uploadDesign,
            ),
          ],
        ),
      ),
    );
  }
}

