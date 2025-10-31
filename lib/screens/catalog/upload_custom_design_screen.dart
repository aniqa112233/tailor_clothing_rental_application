// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:tailor_clothing_application/providers/catalog_provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class UploadCustomDesignScreen extends StatefulWidget {
//   const UploadCustomDesignScreen({super.key});

//   @override
//   State<UploadCustomDesignScreen> createState() => _UploadCustomDesignScreenState();
// }

// class _UploadCustomDesignScreenState extends State<UploadCustomDesignScreen> {
//   File? _image;
//   final _notesController = TextEditingController();

//   Future<void> _pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) setState(() => _image = File(picked.path));
//   }

//   Future<void> _upload() async {
//     if (_image == null) return;
//     final supabase = Supabase.instance.client;
//     final bytes = await _image!.readAsBytes();
//     final fileName = 'custom_${DateTime.now().millisecondsSinceEpoch}.jpg';
//     final res = await supabase.storage.from('designs').uploadBinary(fileName, bytes);
//     final imageUrl = supabase.storage.from('designs').getPublicUrl(fileName);

//     await Provider.of<CatalogProvider>(context, listen: false)
//         .uploadCustomDesign(imageUrl, _notesController.text);

//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Design Uploaded!')));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Upload Custom Design')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(children: [
//           _image != null
//               ? Image.file(_image!, height: 150)
//               : const Placeholder(fallbackHeight: 150),
//           const SizedBox(height: 10),
//           ElevatedButton(onPressed: _pickImage, child: const Text('Pick Design Image')),
//           const SizedBox(height: 10),
//           TextField(
//             controller: _notesController,
//             decoration: const InputDecoration(labelText: 'Design Notes'),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(onPressed: _upload, child: const Text('Upload')),
//         ]),
//       ),
//     );
//   }
// }
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/providers/catalog_provider.dart';
// class UploadCustomDesignScreen extends StatefulWidget {
//   const UploadCustomDesignScreen({super.key});

//   @override
//   State<UploadCustomDesignScreen> createState() =>
//       _UploadCustomDesignScreenState();
// }

// class _UploadCustomDesignScreenState extends State<UploadCustomDesignScreen> {
//   File? _image;
//   final _notesController = TextEditingController();
//   bool _uploading = false;

//   // 🔹 Pick an image from gallery
//   Future<void> _pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() => _image = File(picked.path));
//     }
//   }

//   // 🔹 Upload the design
//   Future<void> _upload() async {
//     if (_image == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select an image first.')),
//       );
//       return;
//     }

//     setState(() => _uploading = true);

//     try {
//       final supabase = Supabase.instance.client;
//       final userId = supabase.auth.currentUser!.id;
//       final bytes = await _image!.readAsBytes();

//       // 🔹 Upload via provider
//       await Provider.of<CatalogProvider>(context, listen: false)
//           .uploadCustomDesign(bytes, _notesController.text, userId);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Design uploaded successfully!')),
//       );

//       setState(() {
//         _image = null;
//         _notesController.clear();
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Upload failed: $e')),
//       );
//     } finally {
//       setState(() => _uploading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Upload Custom Design')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               _image != null
//                   ? Image.file(_image!, height: 180)
//                   : const Placeholder(fallbackHeight: 180),
//               const SizedBox(height: 16),
//               ElevatedButton.icon(
//                 onPressed: _pickImage,
//                 icon: const Icon(Icons.photo_library),
//                 label: const Text('Pick Design Image'),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _notesController,
//                 decoration: const InputDecoration(
//                   labelText: 'Design Notes',
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 3,
//               ),
//               const SizedBox(height: 30),
//               _uploading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton.icon(
//                       onPressed: _upload,
//                       icon: const Icon(Icons.cloud_upload_outlined),
//                       label: const Text('Upload Design'),
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 30, vertical: 14),
//                         backgroundColor: Colors.blueAccent,
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tailor_clothing_application/providers/catalog_provider.dart';

// class UploadCustomDesignScreen extends StatefulWidget {
//   const UploadCustomDesignScreen({super.key});

//   @override
//   State<UploadCustomDesignScreen> createState() =>
//       _UploadCustomDesignScreenState();
// }

// class _UploadCustomDesignScreenState extends State<UploadCustomDesignScreen> {
//   File? _image;
//   final _notesController = TextEditingController();
//   bool _uploading = false;

//   Future<void> _pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) setState(() => _image = File(picked.path));
//   }

//   Future<void> _upload() async {
//     if (_image == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select an image first.')),
//       );
//       return;
//     }

//     setState(() => _uploading = true);
//     try {
//       final supabase = Supabase.instance.client;
//       final userId = supabase.auth.currentUser!.id;
//       final bytes = await _image!.readAsBytes();

//       await Provider.of<CatalogProvider>(context, listen: false)
//           .uploadCustomDesign(bytes, _notesController.text, userId);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Design uploaded successfully!')),
//       );
//       setState(() {
//         _image = null;
//         _notesController.clear();
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Upload failed: $e')));
//     } finally {
//       setState(() => _uploading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Upload Custom Design')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               _image != null
//                   ? Image.file(_image!, height: 180)
//                   : const Placeholder(fallbackHeight: 180),
//               const SizedBox(height: 16),
//               ElevatedButton.icon(
//                 onPressed: _pickImage,
//                 icon: const Icon(Icons.photo_library),
//                 label: const Text('Pick Design Image'),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _notesController,
//                 decoration: const InputDecoration(
//                   labelText: 'Design Notes',
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 3,
//               ),
//               const SizedBox(height: 30),
//               _uploading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton.icon(
//                       onPressed: _upload,
//                       icon: const Icon(Icons.cloud_upload_outlined),
//                       label: const Text('Upload Design'),
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 30, vertical: 14),
//                         backgroundColor: Colors.blueAccent,
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
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

  // ✅ Safe Image Picker (fixed crash issue)
  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // reduce image size
        maxWidth: 1024,   // prevent memory overload
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
                onPressed: _pickImage,
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
