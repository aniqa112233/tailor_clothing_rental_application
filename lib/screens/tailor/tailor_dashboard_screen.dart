
// import 'package:flutter/material.dart';
// import 'tailor_designs_screen.dart';
// import 'tailor_profile_screen.dart';
// import 'tailor_analytics_screen.dart';

// class TailorDashboardScreen extends StatefulWidget {
//   const TailorDashboardScreen({super.key});

//   @override
//   State<TailorDashboardScreen> createState() => _TailorDashboardScreenState();
// }

// class _TailorDashboardScreenState extends State<TailorDashboardScreen> {
//   int _selectedIndex = 0;

//   final List<Widget> _screens = const [
//     TailorDesignsScreen(),
//     TailorAnalyticsScreen(),
//     TailorProfileScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: Colors.blueAccent,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.design_services_outlined),
//             label: 'Designs',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.bar_chart_outlined),
//             label: 'Analytics',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outline),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'tailor_designs_screen.dart';
import 'tailor_profile_screen.dart';
import 'tailor_analytics_screen.dart';

class TailorDashboardScreen extends StatefulWidget {
  const TailorDashboardScreen({super.key});

  @override
  State<TailorDashboardScreen> createState() => _TailorDashboardScreenState();
}

class _TailorDashboardScreenState extends State<TailorDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    TailorDesignsScreen(),
    TailorAnalyticsScreen(),
    TailorProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.design_services_outlined),
            label: 'Designs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
