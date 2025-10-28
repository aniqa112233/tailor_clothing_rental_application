import 'package:flutter/material.dart';
import '../../main.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Role')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Choose your role:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            RoleCard(
              title: 'Customer',
              subtitle: 'Rent outfits or order stitching services',
              onTap: () => Navigator.pushNamed(context, Routes.signup),
            ),
            const SizedBox(height: 10),
            RoleCard(
              title: 'Tailor',
              subtitle: 'Register and offer your tailoring services',
              onTap: () => Navigator.pushNamed(context, Routes.signup),
            ),
            const SizedBox(height: 10),
            RoleCard(
              title: 'Admin',
              subtitle: 'Manage app & users',
              onTap: () => Navigator.pushNamed(context, Routes.signup),
            ),
          ],
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const RoleCard({super.key, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      ),
    );
  }
}
