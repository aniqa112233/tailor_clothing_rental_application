
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tailor_clothing_application/providers/catalog_provider.dart';
// import 'package:tailor_clothing_application/providers/tailor_provider.dart';
// import 'package:tailor_clothing_application/providers/auth_provider.dart';
// import 'package:tailor_clothing_application/providers/order_provider.dart';
// import 'package:tailor_clothing_application/screens/tailor/tailor_dashboard_screen.dart';
// import 'package:tailor_clothing_application/utils/app_theme.dart';
// import 'package:tailor_clothing_application/utils/supabase_config.dart';

// // Screens
// import 'screens/auth/login_screen.dart';
// import 'screens/auth/signup_screen.dart';
// import 'screens/auth/role_selection_screen.dart';
// import 'screens/profile/profile_setup_screen.dart';
// import 'screens/dashboard/dashboard_screen.dart';

// // Catalog
// import 'screens/catalog/catalog_home_screen.dart';
// import 'screens/catalog/upload_custom_design_screen.dart';
// import 'screens/catalog/approve_designs_screen.dart';

// // Order
// import 'screens/order/order_list_screen.dart';
// import 'screens/order/order_create_screen.dart';
// import 'screens/order/order_details_screen.dart';
// import 'screens/order/order_status_screen.dart';
// import 'screens/order/order_tracking_screen.dart';

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
//         ChangeNotifierProvider(create: (_) => CatalogProvider()),
//         ChangeNotifierProvider(create: (_) => OrderProvider()),
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
//           Routes.tailorDashboard: (_) => const TailorDashboardScreen(),
//           Routes.catalogHome: (_) => const CatalogHomeScreen(),
//           Routes.uploadDesign: (_) => const UploadCustomDesignScreen(),
//           Routes.approveDesigns: (_) => const ApproveDesignsScreen(),
//           Routes.orderList: (_) {
//             final user = SupabaseConfig.client.auth.currentUser;
//             final userId = user?.id ?? '';
//             return OrderListScreen(userId: userId);
//           },
//           Routes.orderCreate: (_) {
//             final user = SupabaseConfig.client.auth.currentUser;
//             final userId = user?.id ?? '';
//             return OrderCreateScreen(userId: userId);
//           },
//           Routes.orderDetails: (context) {
//             final args = ModalRoute.of(context)!.settings.arguments as String;
//             return OrderDetailsScreen(orderId: args);
//           },
//           Routes.orderStatus: (context) {
//             final args = ModalRoute.of(context)!.settings.arguments as String;
//             return OrderStatusScreen(orderId: args);
//           },
//           Routes.orderTracking: (context) {
//             final args = ModalRoute.of(context)!.settings.arguments as String;
//             return OrderTrackingScreen(orderId: args);
//           },
//         },
//       ),
//     );
//   }
// }

// // -------------------- AuthGate --------------------
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
//         final profileData = await SupabaseConfig.client
//             .from('profiles')
//             .select()
//             .eq('id', session.user.id)
//             .maybeSingle();

//         final role = profileData?['role'];
//         if (role == 'tailor') {
//           Navigator.pushNamedAndRemoveUntil(
//               context, Routes.tailorDashboard, (route) => false);
//         } else {
//           Navigator.pushNamedAndRemoveUntil(
//               context, Routes.dashboard, (route) => false);
//         }
//       } else {
//         _navigated = true;
//         Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
//       }
//     });

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final session = SupabaseConfig.client.auth.currentSession;
//       if (!mounted || _navigated) return;

//       if (session != null) {
//         _navigated = true;
//         final profileData = await SupabaseConfig.client
//             .from('profiles')
//             .select()
//             .eq('id', session.user.id)
//             .maybeSingle();

//         final role = profileData?['role'];
//         if (role == 'tailor') {
//           Navigator.pushNamedAndRemoveUntil(
//               context, Routes.tailorDashboard, (route) => false);
//         } else {
//           Navigator.pushNamedAndRemoveUntil(
//               context, Routes.dashboard, (route) => false);
//         }
//       } else {
//         _navigated = true;
//         Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
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

// // -------------------- Routes --------------------
// class Routes {
//   static const login = '/login';
//   static const signup = '/signup';
//   static const roleSelection = '/role-select';
//   static const profileSetup = '/profile-setup';
//   static const dashboard = '/dashboard'; // Customer
//   static const tailorDashboard = '/tailor-dashboard'; // Tailor

//   static const catalogHome = '/catalog';
//   static const uploadDesign = '/upload-design';
//   static const approveDesigns = '/approve-designs';

//   static const orderList = '/orders';
//   static const orderCreate = '/order-create';
//   static const orderDetails = '/order-details';
//   static const orderStatus = '/order-status';
//   static const orderTracking = '/order-tracking';
// }saiii
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailor_clothing_application/providers/catalog_provider.dart';
import 'package:tailor_clothing_application/providers/tailor_provider.dart';
import 'package:tailor_clothing_application/providers/auth_provider.dart';
import 'package:tailor_clothing_application/providers/order_provider.dart';
import 'package:tailor_clothing_application/screens/tailor/tailor_dashboard_screen.dart';
import 'package:tailor_clothing_application/utils/app_theme.dart';
import 'package:tailor_clothing_application/utils/supabase_config.dart';

// Screens
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/profile/profile_setup_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/auth/splash_screen.dart'; // ✅ Added import

// Catalog
import 'screens/catalog/catalog_home_screen.dart';
import 'screens/catalog/upload_custom_design_screen.dart';
import 'screens/catalog/approve_designs_screen.dart';

// Order
import 'screens/order/order_list_screen.dart';
import 'screens/order/order_create_screen.dart';
import 'screens/order/order_details_screen.dart';
import 'screens/order/order_status_screen.dart';
import 'screens/order/order_tracking_screen.dart';

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
        ChangeNotifierProvider(create: (_) => CatalogProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tailor & Clothing Rental',
        theme: AppTheme.lightTheme,
        // ✅ Splash screen will appear first
        home: const SplashScreen(),
        routes: {
          Routes.splash: (_) => const SplashScreen(), // ✅ Added route
          Routes.login: (_) => const LoginScreen(),
          Routes.signup: (_) => const SignupScreen(),
          Routes.roleSelection: (_) => const RoleSelectionScreen(),
          Routes.profileSetup: (_) => const ProfileSetupScreen(),
          Routes.dashboard: (_) => const DashboardScreen(),
          Routes.tailorDashboard: (_) => const TailorDashboardScreen(),
          Routes.catalogHome: (_) => const CatalogHomeScreen(),
          Routes.uploadDesign: (_) => const UploadCustomDesignScreen(),
          Routes.approveDesigns: (_) => const ApproveDesignsScreen(),
          Routes.orderList: (_) {
            final user = SupabaseConfig.client.auth.currentUser;
            final userId = user?.id ?? '';
            return OrderListScreen(userId: userId);
          },
          Routes.orderCreate: (_) {
            final user = SupabaseConfig.client.auth.currentUser;
            final userId = user?.id ?? '';
            return OrderCreateScreen(userId: userId);
          },
          Routes.orderDetails: (context) {
            final args = ModalRoute.of(context)!.settings.arguments as String;
            return OrderDetailsScreen(orderId: args);
          },
          Routes.orderStatus: (context) {
            final args = ModalRoute.of(context)!.settings.arguments as String;
            return OrderStatusScreen(orderId: args);
          },
          Routes.orderTracking: (context) {
            final args = ModalRoute.of(context)!.settings.arguments as String;
            return OrderTrackingScreen(orderId: args);
          },
        },
      ),
    );
  }
}

// -------------------- AuthGate --------------------
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
        final profileData = await SupabaseConfig.client
            .from('profiles')
            .select()
            .eq('id', session.user.id)
            .maybeSingle();

        final role = profileData?['role'];
        if (role == 'tailor') {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.tailorDashboard, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.dashboard, (route) => false);
        }
      } else {
        _navigated = true;
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.login, (route) => false);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final session = SupabaseConfig.client.auth.currentSession;
      if (!mounted || _navigated) return;

      if (session != null) {
        _navigated = true;
        final profileData = await SupabaseConfig.client
            .from('profiles')
            .select()
            .eq('id', session.user.id)
            .maybeSingle();

        final role = profileData?['role'];
        if (role == 'tailor') {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.tailorDashboard, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.dashboard, (route) => false);
        }
      } else {
        _navigated = true;
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.login, (route) => false);
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

// -------------------- Routes --------------------
class Routes {
  static const splash = '/splash'; // ✅ Added route name
  static const login = '/login';
  static const signup = '/signup';
  static const roleSelection = '/role-select';
  static const profileSetup = '/profile-setup';
  static const dashboard = '/dashboard'; // Customer
  static const tailorDashboard = '/tailor-dashboard'; // Tailor

  static const catalogHome = '/catalog';
  static const uploadDesign = '/upload-design';
  static const approveDesigns = '/approve-designs';

  static const orderList = '/orders';
  static const orderCreate = '/order-create';
  static const orderDetails = '/order-details';
  static const orderStatus = '/order-status';
  static const orderTracking = '/order-tracking';
}

