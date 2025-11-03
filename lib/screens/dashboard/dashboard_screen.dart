
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

//     // ✅ Otherwise show simple dashboard (for customers / admin)
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
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(
//                 Icons.check_circle_outline,
//                 color: Colors.green,
//                 size: 80,
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 'You are logged in!',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               if (auth.role != null) Text('Role: ${auth.role}'),
//               const SizedBox(height: 20),

//               ElevatedButton(
//                 onPressed: () =>
//                     Navigator.pushNamed(context, Routes.profileSetup),
//                 child: const Text('Edit Profile'),
//               ),

//               // 🔹 Catalog Module Section (kept only catalog button)
//               const SizedBox(height: 40),
//               const Divider(thickness: 1),
//               const SizedBox(height: 10),
//               const Text(
//                 'Explore Catalog & Custom Designs',
//                 style: TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blueAccent,
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // 🔸 Button 1: Catalog Home (✅ Only this remains)
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.storefront_outlined),
//                 label: const Text('Open Product & Service Catalog'),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                   backgroundColor: Colors.blueAccent,
//                 ),
//                 onPressed: () {
//                   Navigator.pushNamed(context, Routes.catalogHome);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
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

//     // ✅ Otherwise show simple dashboard (for customers / admin)
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
//           ),
//         ],
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(
//                 Icons.check_circle_outline,
//                 color: Colors.green,
//                 size: 80,
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 'You are logged in!',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               if (auth.role != null) Text('Role: ${auth.role}'),
//               const SizedBox(height: 20),

//               ElevatedButton(
//                 onPressed: () =>
//                     Navigator.pushNamed(context, Routes.profileSetup),
//                 child: const Text('Edit Profile'),
//               ),

//               // 🔹 Catalog Module Section
//               const SizedBox(height: 40),
//               const Divider(thickness: 1),
//               const SizedBox(height: 10),
//               const Text(
//                 'Explore Catalog & Custom Designs',
//                 style: TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blueAccent,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.storefront_outlined),
//                 label: const Text('Open Product & Service Catalog'),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                   backgroundColor: Colors.blueAccent,
//                 ),
//                 onPressed: () {
//                   Navigator.pushNamed(context, Routes.catalogHome);
//                 },
//               ),

//               // 🧾 ===============================
//               // 🧾 ORDER MANAGEMENT SECTION
//               // 🧾 ===============================
//               const SizedBox(height: 40),
//               const Divider(thickness: 1),
//               const SizedBox(height: 10),
//               const Text(
//                 '🧾 Order Management',
//                 style: TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.deepPurple,
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // 🔸 Button 1: View Orders
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.list_alt_rounded),
//                 label: const Text('View My Orders'),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                   backgroundColor: Colors.deepPurpleAccent,
//                 ),
//                 onPressed: () {
//                   Navigator.pushNamed(context, Routes.orderList);
//                 },
//               ),
//               const SizedBox(height: 12),

//               // 🔸 Button 2: Create New Order
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.add_shopping_cart_rounded),
//                 label: const Text('Create New Order'),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                   backgroundColor: Colors.deepPurpleAccent,
//                 ),
//                 onPressed: () {
//                   Navigator.pushNamed(context, Routes.orderCreate);
//                 },
//               ),
//               const SizedBox(height: 12),

//               // 🔸 Button 3: Order Details
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.info_outline),
//                 label: const Text('View Order Details'),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                   backgroundColor: Colors.deepPurpleAccent,
//                 ),
//                 onPressed: () {
//                   // ⚠️ Example order ID for navigation (replace with real one later)
//                   Navigator.pushNamed(context, Routes.orderDetails,
//                       arguments: 'sample-order-id');
//                 },
//               ),
//               const SizedBox(height: 12),

//               // 🔸 Button 4: Order Status
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.assignment_turned_in_outlined),
//                 label: const Text('Check Order Status'),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                   backgroundColor: Colors.deepPurpleAccent,
//                 ),
//                 onPressed: () {
//                   Navigator.pushNamed(context, Routes.orderStatus,
//                       arguments: 'sample-order-id');
//                 },
//               ),
//               const SizedBox(height: 12),

//               // 🔸 Button 5: Track Order
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.local_shipping_outlined),
//                 label: const Text('Track Order'),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                   backgroundColor: Colors.deepPurpleAccent,
//                 ),
//                 onPressed: () {
//                   Navigator.pushNamed(context, Routes.orderTracking,
//                       arguments: 'sample-order-id');
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// lib/screens/dashboard/dashboard_screen.dart
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
          ),
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

              // ✅ Edit Profile Button
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, Routes.profileSetup),
                child: const Text('Edit Profile'),
              ),

              // 🔹 Catalog Module Section
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

              // 🧾 ===============================
              // 🧾 ORDER MANAGEMENT SECTION
              // 🧾 ===============================
              const SizedBox(height: 40),
              const Divider(thickness: 1),
              const SizedBox(height: 10),
              const Text(
                '🧾 Order Management',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),

              // 🔸 Button: View Orders Only (others removed)
              ElevatedButton.icon(
                icon: const Icon(Icons.list_alt_rounded),
                label: const Text('View My Orders'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.deepPurpleAccent,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, Routes.orderList);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
