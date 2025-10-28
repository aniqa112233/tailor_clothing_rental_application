import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tailor_provider.dart';
import '../../widgets/primary_button.dart';
import '../../utils/tailor_constants.dart';
import 'tailor_dashboard_screen.dart';

class TailorRegistrationScreen extends StatefulWidget {
  const TailorRegistrationScreen({super.key});

  @override
  State<TailorRegistrationScreen> createState() =>
      _TailorRegistrationScreenState();
}

class _TailorRegistrationScreenState extends State<TailorRegistrationScreen> {
  final _shopNameC = TextEditingController();
  String? _selectedService;
  String? _selectedArea;
  final _cnicC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tailor = Provider.of<TailorProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Tailor Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _shopNameC,
              decoration: const InputDecoration(labelText: 'Shop Name'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedService,
              items: TailorConstants.services
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedService = v),
              decoration: const InputDecoration(labelText: 'Service Offered'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedArea,
              items: TailorConstants.deliveryAreas
                  .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedArea = v),
              decoration: const InputDecoration(labelText: 'Delivery Area'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cnicC,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'CNIC (optional)'),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Save & Continue',
              loading: tailor.loading,
              onPressed: () async {
                await tailor.registerTailor({
                  'shopName': _shopNameC.text,
                  'service': _selectedService,
                  'area': _selectedArea,
                  'cnic': _cnicC.text,
                });
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const TailorDashboardScreen()),
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
