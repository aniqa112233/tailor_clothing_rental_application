// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'utils/app_theme.dart';
// import 'providers/auth_provider.dart';
// import 'screens/auth/login_screen.dart';
// import 'screens/auth/signup_screen.dart';
// import 'screens/auth/role_selection_screen.dart';
// import 'screens/profile/profile_setup_screen.dart';
// import 'screens/dashboard/dashboard_screen.dart';

// void main() {
//   runApp(const TailorApp());
// }

// class TailorApp extends StatelessWidget {
//   const TailorApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Tailor & Clothing Rental',
//         theme: AppTheme.lightTheme,
//         initialRoute: Routes.login,
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

// /// Simple route names used in Navigator.pushNamed()
// class Routes {
//   static const login = '/';
//   static const signup = '/signup';
//   static const roleSelection = '/role-select';
//   static const profileSetup = '/profile-setup';
//   static const dashboard = '/dashboard';
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'utils/app_theme.dart';


// import 'utils/supabase_config.dart';
// import 'providers/auth_provider.dart';
// import 'screens/auth/login_screen.dart';
// import 'screens/auth/signup_screen.dart';
// import 'screens/auth/role_selection_screen.dart';
// import 'screens/profile/profile_setup_screen.dart';
// import 'screens/dashboard/dashboard_screen.dart';

// /// 🧩 App Entry Point
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // Initialize Supabase before running app
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
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Tailor & Clothing Rental',
//         theme: AppTheme.lightTheme,
//         initialRoute: Routes.login,
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

// /// 📍 All App Routes
// class Routes {
//   static const login = '/';
//   static const signup = '/signup';
//   static const roleSelection = '/role-select';
//   static const profileSetup = '/profile-setup';
//   static const dashboard = '/dashboard';
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
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
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Tailor & Clothing Rental',
//         theme: AppTheme.lightTheme,
//         home: const AuthGate(), // 👈 replaces initialRoute
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

// /// ✅ AuthGate: Detects Supabase session (email or Google)
// /// and redirects automatically
// class AuthGate extends StatefulWidget {
//   const AuthGate({super.key});

//   @override
//   State<AuthGate> createState() => _AuthGateState();
// }

// class _AuthGateState extends State<AuthGate> {
//   @override
//   void initState() {
//     super.initState();

//     // Listen for Supabase Auth state changes (login/logout)
//     SupabaseConfig.client.auth.onAuthStateChange.listen((data) {
//       final session = data.session;
//       if (session != null && mounted) {
//         // ✅ user logged in successfully (email or Google)
//         Navigator.pushReplacementNamed(context, Routes.dashboard);
//       } else if (mounted) {
//         // 👇 user logged out
//         Navigator.pushReplacementNamed(context, Routes.login);
//       }
//     });

//     // Also check existing session on app start
//     final session = SupabaseConfig.client.auth.currentSession;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (session != null) {
//         Navigator.pushReplacementNamed(context, Routes.dashboard);
//       } else {
//         Navigator.pushReplacementNamed(context, Routes.login);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Temporary splash while deciding route
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
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

// /// AuthGate: Handles both email and Google login redirects
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

//     // Listen for Supabase auth state changes (Google + Email both)
//     SupabaseConfig.client.auth.onAuthStateChange.listen((data) async {
//       final session = data.session;
//       if (session != null && !_navigated && mounted) {
//         _navigated = true;
//         debugPrint("✅ User authenticated via Supabase: ${session.user.email}");
//         await Future.delayed(const Duration(milliseconds: 600));
//         Navigator.pushReplacementNamed(context, Routes.dashboard);
//       } else if (session == null && !_navigated && mounted) {
//         _navigated = true;
//         Navigator.pushReplacementNamed(context, Routes.login);
//       }
//     });

//     // Check any already active session on app start
//     final existingSession = SupabaseConfig.client.auth.currentSession;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (existingSession != null && !_navigated) {
//         _navigated = true;
//         Navigator.pushReplacementNamed(context, Routes.dashboard);
//       } else if (!_navigated) {
//         _navigated = true;
//         Navigator.pushReplacementNamed(context, Routes.login);
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

// /// ✅ AuthGate: Detects both email + Google login sessions and redirects properly
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

//     /// Listen for Supabase Auth state changes (Google or Email)
//     SupabaseConfig.client.auth.onAuthStateChange.listen((data) async {
//       final session = data.session;
//       if (!mounted || _navigated) return;

//       if (session != null) {
//         _navigated = true;
//         debugPrint('✅ User logged in: ${session.user.email}');
//         await Future.delayed(const Duration(milliseconds: 300));

//         // Go to Dashboard after successful login
//         if (mounted) {
//           Navigator.of(context).pushNamedAndRemoveUntil(
//             Routes.dashboard,
//             (route) => false,
//           );
//         }
//       } else {
//         _navigated = true;

//         // Go to Login if no session
//         if (mounted) {
//           Navigator.of(context).pushNamedAndRemoveUntil(
//             Routes.login,
//             (route) => false,
//           );
//         }
//       }
//     });

//     /// Check if already logged in when app starts
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final currentSession = SupabaseConfig.client.auth.currentSession;
//       if (!mounted || _navigated) return;

//       if (currentSession != null) {
//         _navigated = true;
//         Navigator.of(context).pushNamedAndRemoveUntil(
//           Routes.dashboard,
//           (route) => false,
//         );
//       } else {
//         _navigated = true;
//         Navigator.of(context).pushNamedAndRemoveUntil(
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

// /// ✅ AuthGate: Automatically routes based on Supabase session state
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

//     // 🔹 Listen for Supabase Auth state changes (Email + Google)
//     SupabaseConfig.client.auth.onAuthStateChange.listen((data) async {
//       final session = data.session;
//       if (!mounted || _navigated) return;

//       if (session != null) {
//         _navigated = true;
//         debugPrint('✅ Authenticated: ${session.user.email}');
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

//     // 🔹 Check for existing session on startup
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
// }wapussssssssssssssssss
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailor_clothing_application/providers/tailor_provider.dart';
import 'utils/app_theme.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/profile/profile_setup_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'utils/supabase_config.dart';

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
        ChangeNotifierProvider(create: (_) => TailorProvider())
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
        },
      ),
    );
  }
}

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
      body: Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      ),
    );
  }
}

class Routes {
  static const login = '/login';
  static const signup = '/signup';
  static const roleSelection = '/role-select';
  static const profileSetup = '/profile-setup';
  static const dashboard = '/dashboard';
}

