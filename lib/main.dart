
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tailor_clothing_application/providers/tailor_provider.dart';
// import 'utils/app_theme.dart';
// import 'providers/auth_provider.dart';
// import 'screens/auth/login_screen.dart';
// import 'screens/auth/signup_screen.dart';
// import 'screens/auth/role_selection_screen.dart';
// import 'screens/profile/profile_setup_screen.dart';
// import 'screens/dashboard/dashboard_screen.dart';
// import 'utils/supabase_config.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SupabaseConfig.initialize();
//   runApp(const TailorApp());
// }

// class TailorApp extends StatelessWidget {
//   const TailorApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => TailorProvider())
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Tailor & Clothing Rental',
//         theme: AppTheme.lightTheme,
//         home: const AuthGate(),
//         routes: {
//           Routes.login: (_) => const LoginScreen(),
//           Routes.signup: (_) => const SignupScreen(),
//           Routes.roleSelection: (_) => const RoleSelectionScreen(),
//           Routes.profileSetup: (_) => const ProfileSetupScreen(),
//           Routes.dashboard: (_) => const DashboardScreen(),
//         },
//       ),
//     );
//   }
// }

// class AuthGate extends StatefulWidget {
//   const AuthGate({super.key});

//   @override
//   State<AuthGate> createState() => _AuthGateState();
// }

// class _AuthGateState extends State<AuthGate> {
//   bool _navigated = false;

//   @override
//   void initState() {
//     super.initState();

//     SupabaseConfig.client.auth.onAuthStateChange.listen((data) async {
//       final session = data.session;
//       if (!mounted || _navigated) return;

//       if (session != null) {
//         _navigated = true;
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           Routes.dashboard,
//           (route) => false,
//         );
//       } else {
//         _navigated = true;
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           Routes.login,
//           (route) => false,
//         );
//       }
//     });

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final session = SupabaseConfig.client.auth.currentSession;
//       if (!mounted || _navigated) return;

//       if (session != null) {
//         _navigated = true;
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           Routes.dashboard,
//           (route) => false,
//         );
//       } else {
//         _navigated = true;
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           Routes.login,
//           (route) => false,
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: CircularProgressIndicator(color: Colors.blueAccent),
//       ),
//     );
//   }
// }

// class Routes {
//   static const login = '/login';
//   static const signup = '/signup';
//   static const roleSelection = '/role-select';
//   static const profileSetup = '/profile-setup';
//   static const dashboard = '/dashboard';
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tailor_clothing_application/providers/catalog_provider.dart';
// import 'package:tailor_clothing_application/providers/tailor_provider.dart';
// import 'package:tailor_clothing_application/providers/auth_provider.dart';
// import 'package:tailor_clothing_application/screens/catalog/catalog_home_screen.dart';
// import 'package:tailor_clothing_application/screens/catalog/upload_custom_design_screen.dart';
// import 'package:tailor_clothing_application/utils/app_theme.dart';
// import 'package:tailor_clothing_application/utils/supabase_config.dart';

// // === Auth & Dashboard ===
// import 'screens/auth/login_screen.dart';
// import 'screens/auth/signup_screen.dart';
// import 'screens/auth/role_selection_screen.dart';
// import 'screens/profile/profile_setup_screen.dart';
// import 'screens/dashboard/dashboard_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SupabaseConfig.initialize();
//   runApp(const TailorApp());
// }

// class TailorApp extends StatelessWidget {
//   const TailorApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => TailorProvider()),
//         ChangeNotifierProvider(create: (_) => CatalogProvider()), // ✅ Added
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Tailor & Clothing Rental',
//         theme: AppTheme.lightTheme,
//         home: const AuthGate(),
//         routes: {
//           Routes.login: (_) => const LoginScreen(),
//           Routes.signup: (_) => const SignupScreen(),
//           Routes.roleSelection: (_) => const RoleSelectionScreen(),
//           Routes.profileSetup: (_) => const ProfileSetupScreen(),
//           Routes.dashboard: (_) => const DashboardScreen(),

//           // ✅ Added Module 3 routes
//           Routes.catalogHome: (_) => const CatalogHomeScreen(),
//           Routes.uploadDesign: (_) => const UploadCustomDesignScreen(),
//         },
//       ),
//     );
//   }
// }

// // === unchanged AuthGate + Routes ===
// class AuthGate extends StatefulWidget {
//   const AuthGate({super.key});
//   @override
//   State<AuthGate> createState() => _AuthGateState();
// }

// class _AuthGateState extends State<AuthGate> {
//   bool _navigated = false;
//   @override
//   void initState() {
//     super.initState();

//     SupabaseConfig.client.auth.onAuthStateChange.listen((data) async {
//       final session = data.session;
//       if (!mounted || _navigated) return;

//       if (session != null) {
//         _navigated = true;
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           Routes.dashboard,
//           (route) => false,
//         );
//       } else {
//         _navigated = true;
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           Routes.login,
//           (route) => false,
//         );
//       }
//     });

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final session = SupabaseConfig.client.auth.currentSession;
//       if (!mounted || _navigated) return;

//       if (session != null) {
//         _navigated = true;
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           Routes.dashboard,
//           (route) => false,
//         );
//       } else {
//         _navigated = true;
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           Routes.login,
//           (route) => false,
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
//     );
//   }
// }

// class Routes {
//   static const login = '/login';
//   static const signup = '/signup';
//   static const roleSelection = '/role-select';
//   static const profileSetup = '/profile-setup';
//   static const dashboard = '/dashboard';

//   // ✅ Added new route constants
//   static const catalogHome = '/catalog';
//   static const uploadDesign = '/upload-design';
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailor_clothing_application/providers/catalog_provider.dart';
import 'package:tailor_clothing_application/providers/tailor_provider.dart';
import 'package:tailor_clothing_application/providers/auth_provider.dart';
import 'package:tailor_clothing_application/screens/catalog/catalog_home_screen.dart';
import 'package:tailor_clothing_application/screens/catalog/upload_custom_design_screen.dart';
import 'package:tailor_clothing_application/screens/catalog/approve_designs_screen.dart'; // ✅ Added import
import 'package:tailor_clothing_application/utils/app_theme.dart';
import 'package:tailor_clothing_application/utils/supabase_config.dart';

// === Auth & Dashboard ===
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/profile/profile_setup_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  runApp(const TailorApp());
}

class TailorApp extends StatelessWidget {
  const TailorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TailorProvider()),
        ChangeNotifierProvider(create: (_) => CatalogProvider()), // ✅ Added
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tailor & Clothing Rental',
        theme: AppTheme.lightTheme,
        home: const AuthGate(),
        routes: {
          Routes.login: (_) => const LoginScreen(),
          Routes.signup: (_) => const SignupScreen(),
          Routes.roleSelection: (_) => const RoleSelectionScreen(),
          Routes.profileSetup: (_) => const ProfileSetupScreen(),
          Routes.dashboard: (_) => const DashboardScreen(),

          // ✅ Module 3 routes
          Routes.catalogHome: (_) => const CatalogHomeScreen(),
          Routes.uploadDesign: (_) => const UploadCustomDesignScreen(),

          // ✅ Newly added Approve Designs screen route
          Routes.approveDesigns: (_) => const ApproveDesignsScreen(),
        },
      ),
    );
  }
}

// === unchanged AuthGate + Routes ===
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _navigated = false;
  @override
  void initState() {
    super.initState();

    SupabaseConfig.client.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      if (!mounted || _navigated) return;

      if (session != null) {
        _navigated = true;
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.dashboard,
          (route) => false,
        );
      } else {
        _navigated = true;
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.login,
          (route) => false,
        );
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = SupabaseConfig.client.auth.currentSession;
      if (!mounted || _navigated) return;

      if (session != null) {
        _navigated = true;
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.dashboard,
          (route) => false,
        );
      } else {
        _navigated = true;
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.login,
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
    );
  }
}

class Routes {
  static const login = '/login';
  static const signup = '/signup';
  static const roleSelection = '/role-select';
  static const profileSetup = '/profile-setup';
  static const dashboard = '/dashboard';

  // ✅ Added new route constants
  static const catalogHome = '/catalog';
  static const uploadDesign = '/upload-design';
  static const approveDesigns = '/approve-designs'; // ✅ New route constant
}
