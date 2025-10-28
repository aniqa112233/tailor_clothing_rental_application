// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../widgets/custom_text_field.dart';
// import '../../widgets/primary_button.dart';
// import '../../main.dart';

// class ProfileSetupScreen extends StatefulWidget {
//   const ProfileSetupScreen({super.key});

//   @override
//   State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
// }

// class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
//   final _emailC = TextEditingController();
//   final _nameC = TextEditingController();
//   final _addressC = TextEditingController();

//   // Updated measurement fields
//   final _heightC = TextEditingController();
//   final _shoulderC = TextEditingController();
//   final _lengthC = TextEditingController();

//   bool _loading = false;

//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Profile Setup')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             CustomTextField(label: 'Email', controller: _emailC, keyboardType: TextInputType.emailAddress),
//             const SizedBox(height: 12),
//             CustomTextField(label: 'Full Name', controller: _nameC),
//             const SizedBox(height: 12),
//             CustomTextField(label: 'Address', controller: _addressC),
//             const SizedBox(height: 12),
//             const Text('Basic Measurements (in cm)', style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),

//             Row(
//               children: [
//                 Expanded(child: CustomTextField(label: 'Height', controller: _heightC, keyboardType: TextInputType.number)),
//                 const SizedBox(width: 10),
//                 Expanded(child: CustomTextField(label: 'Shoulder Width', controller: _shoulderC, keyboardType: TextInputType.number)),
//               ],
//             ),
//             const SizedBox(height: 12),
//             CustomTextField(label: 'Length', controller: _lengthC, keyboardType: TextInputType.number),
//             const SizedBox(height: 20),

//             PrimaryButton(
//               label: 'Save & Continue',
//               loading: _loading,
//               onPressed: () async {
//                 setState(() => _loading = true);
//                 await auth.saveProfile(
//                   email: _emailC.text.trim(),
//                   profile: {
//                     'name': _nameC.text,
//                     'address': _addressC.text,
//                     'measurements': {
//                       'height': _heightC.text,
//                       'shoulderWidth': _shoulderC.text,
//                       'length': _lengthC.text,
//                     }
//                   },
//                 );
//                 setState(() => _loading = false);
//                 Navigator.pushReplacementNamed(context, Routes.dashboard);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }wapusssssssssssssssssss

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../widgets/custom_text_field.dart';
// import '../../widgets/primary_button.dart';
// import '../../main.dart';

// class ProfileSetupScreen extends StatefulWidget {
//   const ProfileSetupScreen({super.key});

//   @override
//   State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
// }

// class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
//   final _emailC = TextEditingController();
//   final _nameC = TextEditingController();
//   final _addressC = TextEditingController();
//   final _heightC = TextEditingController();
//   final _shoulderC = TextEditingController();
//   final _lengthC = TextEditingController();
//   String _role = 'customer';
//   bool _loading = false;

//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthProvider>(context);
//     final currentUser = auth.supabase.auth.currentUser;

//     _emailC.text = currentUser?.email ?? '';

//     return Scaffold(
//       appBar: AppBar(title: const Text('Profile Setup')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomTextField(
//               label: 'Email',
//               controller: _emailC,
//               keyboardType: TextInputType.emailAddress,
//               readOnly: true,
//             ),
//             const SizedBox(height: 12),
//             CustomTextField(label: 'Full Name', controller: _nameC),
//             const SizedBox(height: 12),
//             CustomTextField(label: 'Address', controller: _addressC),
//             const SizedBox(height: 12),
//             DropdownButtonFormField<String>(
//               value: _role,
//               decoration: const InputDecoration(labelText: 'Select Role'),
//               items: const [
//                 DropdownMenuItem(value: 'customer', child: Text('Customer')),
//                 DropdownMenuItem(value: 'tailor', child: Text('Tailor')),
//                 DropdownMenuItem(value: 'admin', child: Text('Admin')),
//               ],
//               onChanged: (v) => setState(() => _role = v!),
//             ),
//             const SizedBox(height: 20),
//             const Text('Basic Measurements (in cm)',
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   child: CustomTextField(
//                     label: 'Height',
//                     controller: _heightC,
//                     keyboardType: TextInputType.number,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: CustomTextField(
//                     label: 'Shoulder Width',
//                     controller: _shoulderC,
//                     keyboardType: TextInputType.number,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             CustomTextField(
//               label: 'Length',
//               controller: _lengthC,
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 25),
//             PrimaryButton(
//               label: 'Save & Continue',
//               loading: _loading,
//               onPressed: () async {
//                 setState(() => _loading = true);
//                 await auth.saveProfile(
//                   email: _emailC.text.trim(),
//                   profile: {
//                     'name': _nameC.text.trim(),
//                     'address': _addressC.text.trim(),
//                     'role': _role,
//                     'measurements': {
//                       'height': _heightC.text.trim(),
//                       'shoulderWidth': _shoulderC.text.trim(),
//                       'length': _lengthC.text.trim(),
//                     }
//                   },
//                 );
//                 setState(() => _loading = false);
//                 Navigator.pushReplacementNamed(context, Routes.dashboard);
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
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../main.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _emailC = TextEditingController();
  final _nameC = TextEditingController();
  final _addressC = TextEditingController();
  final _heightC = TextEditingController();
  final _shoulderC = TextEditingController();
  final _lengthC = TextEditingController();
  String _role = 'customer';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final currentUser = auth.supabase.auth.currentUser;
    _emailC.text = currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Setup')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailC,
              keyboardType: TextInputType.emailAddress,
              enabled: false, // ✅ replaced readOnly with enabled:false
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            CustomTextField(label: 'Full Name', controller: _nameC),
            const SizedBox(height: 12),
            CustomTextField(label: 'Address', controller: _addressC),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _role,
              decoration: const InputDecoration(labelText: 'Select Role'),
              items: const [
                DropdownMenuItem(value: 'customer', child: Text('Customer')),
                DropdownMenuItem(value: 'tailor', child: Text('Tailor')),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              onChanged: (v) => setState(() => _role = v!),
            ),
            const SizedBox(height: 20),
            const Text('Basic Measurements (in cm)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'Height',
                    controller: _heightC,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    label: 'Shoulder Width',
                    controller: _shoulderC,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Length',
              controller: _lengthC,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 25),
            PrimaryButton(
              label: 'Save & Continue',
              loading: _loading,
              onPressed: () async {
                setState(() => _loading = true);
                await auth.saveProfile(
                  email: _emailC.text.trim(),
                  profile: {
                    'name': _nameC.text.trim(),
                    'address': _addressC.text.trim(),
                    'role': _role,
                    'measurements': {
                      'height': _heightC.text.trim(),
                      'shoulderWidth': _shoulderC.text.trim(),
                      'length': _lengthC.text.trim(),
                    }
                  },
                );
                setState(() => _loading = false);
                if (mounted) {
                  Navigator.pushReplacementNamed(context, Routes.dashboard);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
