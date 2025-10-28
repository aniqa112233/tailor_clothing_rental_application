// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../main.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dashboard'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               auth.logout();
//               Navigator.pushReplacementNamed(context, Routes.login);
//             },
//           )
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
//             const SizedBox(height: 12),
//             const Text('You are logged in!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             if (auth.role != null) Text('Role: ${auth.role}'),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: () => Navigator.pushNamed(context, Routes.profileSetup),
//               child: const Text('Edit Profile'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailor_clothing_application/screens/tailor/tailor_dashboard_screen.dart';
import '../../providers/auth_provider.dart';
import '../../main.dart';
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    // ✅ If user is tailor, open Tailor Dashboard
    if (auth.role == 'tailor') {
      return const TailorDashboardScreen();
    }

    // ✅ Otherwise show simple dashboard (customer/admin etc.)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, Routes.login);
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 80,
            ),
            const SizedBox(height: 12),
            const Text(
              'You are logged in!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (auth.role != null) Text('Role: ${auth.role}'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.profileSetup),
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
