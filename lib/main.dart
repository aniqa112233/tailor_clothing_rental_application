
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailor_clothing_application/providers/catalog_provider.dart';
import 'package:tailor_clothing_application/providers/tailor_provider.dart';
import 'package:tailor_clothing_application/providers/auth_provider.dart';
import 'package:tailor_clothing_application/utils/app_theme.dart';
import 'package:tailor_clothing_application/utils/supabase_config.dart';

// === Auth & Dashboard ===
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/profile/profile_setup_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';

// === Catalog Module ===
import 'screens/catalog/catalog_home_screen.dart';
import 'screens/catalog/upload_custom_design_screen.dart';
import 'screens/catalog/approve_designs_screen.dart';

// === 🧾 Order Management Module ===
import 'package:tailor_clothing_application/providers/order_provider.dart';
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
        ChangeNotifierProvider(create: (_) => OrderProvider()), // ✅ Added OrderProvider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tailor & Clothing Rental',
        theme: AppTheme.lightTheme,
        home: const AuthGate(),
        routes: {
          // === Auth Routes ===
          Routes.login: (_) => const LoginScreen(),
          Routes.signup: (_) => const SignupScreen(),
          Routes.roleSelection: (_) => const RoleSelectionScreen(),
          Routes.profileSetup: (_) => const ProfileSetupScreen(),
          Routes.dashboard: (_) => const DashboardScreen(),

          // === Catalog Module Routes ===
          Routes.catalogHome: (_) => const CatalogHomeScreen(),
          Routes.uploadDesign: (_) => const UploadCustomDesignScreen(),
          Routes.approveDesigns: (_) => const ApproveDesignsScreen(),

          // === 🧾 Order Management Routes ===
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

// === unchanged AuthGate ===
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

// === Updated Routes class ===
class Routes {
  // === Auth ===
  static const login = '/login';
  static const signup = '/signup';
  static const roleSelection = '/role-select';
  static const profileSetup = '/profile-setup';
  static const dashboard = '/dashboard';

  // === Catalog ===
  static const catalogHome = '/catalog';
  static const uploadDesign = '/upload-design';
  static const approveDesigns = '/approve-designs';

  // === 🧾 Order Management ===
  static const orderList = '/orders';
  static const orderCreate = '/order-create';
  static const orderDetails = '/order-details';
  static const orderStatus = '/order-status';
  static const orderTracking = '/order-tracking';
}
