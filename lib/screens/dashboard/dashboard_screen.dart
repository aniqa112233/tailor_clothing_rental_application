
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tailor_clothing_application/screens/tailor/tailor_dashboard_screen.dart';
// import '../../providers/auth_provider.dart';
// import '../../main.dart';
// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthProvider>(context);

//     // ✅ If user is tailor, open Tailor Dashboard
//     if (auth.role == 'tailor') {
//       return const TailorDashboardScreen();
//     }

//     // ✅ Otherwise show simple dashboard (customer/admin etc.)
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
//             const Icon(
//               Icons.check_circle_outline,
//               color: Colors.green,
//               size: 80,
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               'You are logged in!',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             if (auth.role != null) Text('Role: ${auth.role}'),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: () =>
//                   Navigator.pushNamed(context, Routes.profileSetup),
//               child: const Text('Edit Profile'),
//             ),
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

    // ✅ Otherwise show simple dashboard (for customers / admin)
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, Routes.profileSetup),
                child: const Text('Edit Profile'),
              ),

              // 🔹 Added Section: Access to Catalog Module (Module 3)
              const SizedBox(height: 40),
              const Divider(thickness: 1),
              const SizedBox(height: 10),
              const Text(
                'Explore Catalog & Custom Designs',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),

              // 🔸 Button 1: Catalog Home
              ElevatedButton.icon(
                icon: const Icon(Icons.storefront_outlined),
                label: const Text('Open Product & Service Catalog'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, Routes.catalogHome);
                },
              ),
              const SizedBox(height: 12),

              // 🔸 Button 2: Upload Custom Design
              ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload_outlined),
                label: const Text('Upload Custom Design'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.teal,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, Routes.uploadDesign);
                },
              ),
              const SizedBox(height: 12),

              // 🔸 Button 3: Fabric Selection (direct access)
              ElevatedButton.icon(
                icon: const Icon(Icons.checkroom_outlined),
                label: const Text('Select Fabric'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.deepPurple,
                ),
                onPressed: () {
                  // You can also open via service detail later
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        // dummy callback (not using fabric data directly)
                        return const Scaffold(
                          body: Center(child: Text('Fabric Selection Screen')),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // 🔸 Button 4: Example direct Service Detail screen
              ElevatedButton.icon(
                icon: const Icon(Icons.design_services_outlined),
                label: const Text('Service Detail Example'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.orange,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Open service detail from catalog by tapping any item.',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
