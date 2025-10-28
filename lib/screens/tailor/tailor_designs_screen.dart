import 'package:flutter/material.dart';
import '../../widgets/image_uploader.dart';
import '../shared/design_card.dart';
import '../shared/empty_state.dart';

class TailorDesignsScreen extends StatefulWidget {
  const TailorDesignsScreen({super.key});

  @override
  State<TailorDesignsScreen> createState() => _TailorDesignsScreenState();
}

class _TailorDesignsScreenState extends State<TailorDesignsScreen> {
  final List<Map<String, dynamic>> _designs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Designs')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newDesign = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ImageUploader()),
          );
          if (newDesign != null) {
            setState(() => _designs.add(newDesign));
          }
        },
        child: const Icon(Icons.add),
      ),
      body: _designs.isEmpty
          ? const EmptyState(message: 'No designs uploaded yet.')
          : ListView.builder(
              itemCount: _designs.length,
              itemBuilder: (_, i) => DesignCard(design: _designs[i]),
            ),
    );
  }
}
