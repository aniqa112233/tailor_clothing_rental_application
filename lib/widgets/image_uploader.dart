import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Design')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                final picked = await picker.pickImage(source: ImageSource.gallery);
                if (picked != null) setState(() => _image = File(picked.path));
              },
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _image == null
                    ? const Center(child: Text('Tap to select image'))
                    : Image.file(_image!, fit: BoxFit.cover),
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
              onPressed: () {
                if (_image == null) return;
                Navigator.pop(context, {
                  'image': _image!,
                  'title': _titleC.text,
                  'price': _priceC.text,
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
