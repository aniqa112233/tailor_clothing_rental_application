
import 'package:flutter/material.dart';

class DesignCard extends StatelessWidget {
  final Map<String, dynamic> design;
  const DesignCard({super.key, required this.design});

  @override
  Widget build(BuildContext context) {
    final imageUrl = design['image_url'];

    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: imageUrl != null
            ? Image.network(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 50);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    width: 60,
                    height: 60,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              )
            : const Icon(Icons.image_not_supported, size: 50),
        title: Text(design['title'] ?? 'Untitled'),
        subtitle: Text('Price: PKR ${design['price'] ?? '-'}'),
      ),
    );
  }
}
