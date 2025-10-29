// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/tailor_provider.dart';
// import '../../widgets/primary_button.dart';

// class TailorProfileScreen extends StatefulWidget {
//   const TailorProfileScreen({super.key});

//   @override
//   State<TailorProfileScreen> createState() => _TailorProfileScreenState();
// }

// class _TailorProfileScreenState extends State<TailorProfileScreen> {
//   final _shopNameC = TextEditingController();
//   final _serviceC = TextEditingController();
//   final _areaC = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final tailor = Provider.of<TailorProvider>(context);
//     final profile = tailor.tailorProfile;

//     _shopNameC.text = profile?['shopName'] ?? '';
//     _serviceC.text = profile?['service'] ?? '';
//     _areaC.text = profile?['area'] ?? '';

//     return Scaffold(
//       appBar: AppBar(title: const Text('Tailor Profile')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(controller: _shopNameC, decoration: const InputDecoration(labelText: 'Shop Name')),
//             const SizedBox(height: 12),
//             TextField(controller: _serviceC, decoration: const InputDecoration(labelText: 'Service')),
//             const SizedBox(height: 12),
//             TextField(controller: _areaC, decoration: const InputDecoration(labelText: 'Delivery Area')),
//             const SizedBox(height: 20),
//             PrimaryButton(
//               label: 'Update',
//               onPressed: () {
//                 tailor.updateTailorProfile({
//                   'shopName': _shopNameC.text,
//                   'service': _serviceC.text,
//                   'area': _areaC.text,
//                 });
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Profile updated!')),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tailor_provider.dart';
import '../../widgets/primary_button.dart';

class TailorProfileScreen extends StatefulWidget {
  const TailorProfileScreen({super.key});

  @override
  State<TailorProfileScreen> createState() => _TailorProfileScreenState();
}

class _TailorProfileScreenState extends State<TailorProfileScreen> {
  final _shopNameC = TextEditingController();
  final _serviceC = TextEditingController();
  final _areaC = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profile = Provider.of<TailorProvider>(context, listen: false).tailorProfile;
    _shopNameC.text = profile?['shop_name'] ?? '';
    _serviceC.text = profile?['services']?.join(', ') ?? '';
    _areaC.text = profile?['delivery_area'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final tailor = Provider.of<TailorProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Tailor Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _shopNameC, decoration: const InputDecoration(labelText: 'Shop Name')),
            const SizedBox(height: 12),
            TextField(controller: _serviceC, decoration: const InputDecoration(labelText: 'Services (comma separated)')),
            const SizedBox(height: 12),
            TextField(controller: _areaC, decoration: const InputDecoration(labelText: 'Delivery Area')),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Update',
              loading: tailor.loading,
              onPressed: () async {
                await tailor.updateTailorProfile({
                  'shop_name': _shopNameC.text,
                  'services': _serviceC.text.split(',').map((e) => e.trim()).toList(),
                  'delivery_area': _areaC.text,
                });
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated!')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
