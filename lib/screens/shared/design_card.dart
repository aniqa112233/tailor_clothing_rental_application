import 'package:flutter/material.dart';

class DesignCard extends StatelessWidget {
  final Map<String, dynamic> design;
  const DesignCard({super.key, required this.design});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Image.file(design['image'], width: 60, fit: BoxFit.cover),
        title: Text(design['title'] ?? 'Untitled'),
        subtitle: Text('Price: PKR ${design['price'] ?? '-'}'),
      ),
    );
  }
}
