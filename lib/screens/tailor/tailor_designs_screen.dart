
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/image_uploader.dart';
import '../shared/design_card.dart';
import '../shared/empty_state.dart';
import '../../providers/tailor_provider.dart';

class TailorDesignsScreen extends StatefulWidget {
  const TailorDesignsScreen({super.key});

  @override
  State<TailorDesignsScreen> createState() => _TailorDesignsScreenState();
}

class _TailorDesignsScreenState extends State<TailorDesignsScreen> {
  @override
  void initState() {
    super.initState();
    // Initial fetch of designs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tailor = Provider.of<TailorProvider>(context, listen: false);
      tailor.fetchDesigns();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tailor = Provider.of<TailorProvider>(context);
    final designs = tailor.designs;

    return Scaffold(
      appBar: AppBar(title: const Text('My Designs')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ImageUploader()),
          );
          // Refresh designs after returning
          tailor.fetchDesigns();
        },
        child: const Icon(Icons.add),
      ),
      body: designs.isEmpty
          ? const EmptyState(message: 'No designs uploaded yet.')
          : ListView.builder(
              itemCount: designs.length,
              itemBuilder: (_, i) => DesignCard(design: designs[i]),
            ),
    );
  }
}


