// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../utils/supabase_config.dart';

// class AuthProvider extends ChangeNotifier {
//   final supabase = SupabaseConfig.client;
//   bool _loading = false;
//   bool get loading => _loading;

//   String? _userId;
//   String? _role;
//   Map<String, dynamic>? _profile;

//   bool get isLoggedIn => _userId != null;
//   String? get role => _role;
//   Map<String, dynamic>? get profile => _profile;

//   // -------------------------
//   // SIGNUP using Supabase Auth
//   // -------------------------
//   Future<void> signup({
//     required String email,
//     required String password,
//     required String role,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     final response = await supabase.auth.signUp(email: email, password: password);

//     if (response.user != null) {
//       _userId = response.user!.id;

//       // create empty profile in DB
//       await supabase.from('profiles').insert({
//         'id': _userId,
//         'email': email,
//         'role': role,
//       });

//       _role = role;
//     }

//     _loading = false;
//     notifyListeners();
//   }

//   // -------------------------
//   // LOGIN using Supabase Auth
//   // -------------------------
//   Future<bool> login({
//     required String email,
//     required String password,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     final response = await supabase.auth.signInWithPassword(email: email, password: password);

//     if (response.user != null) {
//       _userId = response.user!.id;

//       // fetch profile
//       final profileData = await supabase
//           .from('profiles')
//           .select()
//           .eq('id', _userId!)
//           .maybeSingle();

//       _profile = profileData;
//       _role = profileData?['role'];
//       _loading = false;
//       notifyListeners();
//       return true;
//     }

//     _loading = false;
//     notifyListeners();
//     return false;
//   }

//   // -------------------------
//   // SAVE / UPDATE PROFILE
//   // -------------------------
//   Future<void> saveProfile({
//     required String email,
//     required Map<String, dynamic> profile,
//   }) async {
//     await supabase.from('profiles').update({
//       'email': email,
//       'name': profile['name'],
//       'address': profile['address'],
//       'measurements': profile['measurements'],
//     }).eq('email', email);
//   }

//   // -------------------------
//   // LOGOUT
//   // -------------------------
//   Future<void> logout() async {
//     await supabase.auth.signOut();
//     _userId = null;
//     _role = null;
//     _profile = null;
//     notifyListeners();
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../utils/supabase_config.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthProvider extends ChangeNotifier {
//   final supabase = SupabaseConfig.client;
//   bool _loading = false;
//   bool get loading => _loading;

//   String? _userId;
//   String? _role;
//   Map<String, dynamic>? _profile;

//   bool get isLoggedIn => _userId != null;
//   String? get role => _role;
//   Map<String, dynamic>? get profile => _profile;

//   // -------------------------
//   // SIGNUP using Supabase Auth (Email + Password)
//   // -------------------------
//   Future<void> signup({
//     required String email,
//     required String password,
//     required String role,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     final response = await supabase.auth.signUp(email: email, password: password);

//     if (response.user != null) {
//       _userId = response.user!.id;

//       // create profile in DB
//       await supabase.from('profiles').insert({
//         'id': _userId,
//         'email': email,
//         'role': role,
//       });

//       _role = role;
//     }

//     _loading = false;
//     notifyListeners();
//   }

//   // -------------------------
//   // LOGIN using Supabase Auth (Email + Password)
//   // -------------------------
//   Future<bool> login({
//     required String email,
//     required String password,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     final response =
//         await supabase.auth.signInWithPassword(email: email, password: password);

//     if (response.user != null) {
//       _userId = response.user!.id;

//       // fetch profile
//       final profileData =
//           await supabase.from('profiles').select().eq('id', _userId!).maybeSingle();

//       _profile = profileData;
//       _role = profileData?['role'];
//       _loading = false;
//       notifyListeners();
//       return true;
//     }

//     _loading = false;
//     notifyListeners();
//     return false;
//   }

//   // -------------------------
// // GOOGLE LOGIN (OAuth Sign-In)
// // -------------------------
// Future<void> signInWithGoogle() async {
//   try {
//     // Start Google Sign In flow
//     final googleUser = await GoogleSignIn(scopes: ['email']).signIn();
//     if (googleUser == null) return; // user cancelled

//     final googleAuth = await googleUser.authentication;

//     final idToken = googleAuth.idToken;
//     final accessToken = googleAuth.accessToken;

//     // 🧩 Null safety check (prevents crash)
//     if (idToken == null || accessToken == null) {
//       debugPrint('⚠️ Google tokens are null — check Google Cloud + Supabase config');
//       return;
//     }

//     // Exchange Google tokens for Supabase session
//     final response = await supabase.auth.signInWithIdToken(
//       provider: OAuthProvider.google,
//       idToken: idToken,
//       accessToken: accessToken,
//     );

//     if (response.user != null) {
//       _userId = response.user!.id;

//       // Check if profile already exists
//       final existing = await supabase
//           .from('profiles')
//           .select()
//           .eq('id', _userId!)
//           .maybeSingle();

//       // If no profile exists, create one automatically
//       if (existing == null) {
//         await supabase.from('profiles').insert({
//           'id': _userId,
//           'email': response.user!.email,
//           'role': 'customer', // default role
//         });
//       }

//       notifyListeners();
//     }
//   } catch (e, st) {
//     debugPrint('❌ Google login error: $e');
//     debugPrint('$st');
//   }
// }


//   // -------------------------
//   // SAVE / UPDATE PROFILE
//   // -------------------------
//   Future<void> saveProfile({
//     required String email,
//     required Map<String, dynamic> profile,
//   }) async {
//     await supabase.from('profiles').update({
//       'email': email,
//       'name': profile['name'],
//       'address': profile['address'],
//       'measurements': profile['measurements'],
//     }).eq('email', email);
//   }

//   // -------------------------
//   // LOGOUT
//   // -------------------------
//   Future<void> logout() async {
//     await supabase.auth.signOut();
//     _userId = null;
//     _role = null;
//     _profile = null;
//     notifyListeners();
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../utils/supabase_config.dart';

// class AuthProvider extends ChangeNotifier {
//   final supabase = SupabaseConfig.client;
//   bool _loading = false;
//   bool get loading => _loading;

//   String? _userId;
//   String? _role;
//   Map<String, dynamic>? _profile;

//   bool get isLoggedIn => _userId != null;
//   String? get role => _role;
//   Map<String, dynamic>? get profile => _profile;

//   // -------------------------
//   // SIGNUP using Supabase Auth (Email + Password)
//   // -------------------------
//   Future<void> signup({
//     required String email,
//     required String password,
//     required String role,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     final response = await supabase.auth.signUp(
//       email: email,
//       password: password,
//     );

//     if (response.user != null) {
//       _userId = response.user!.id;

//       // create profile in DB
//       await supabase.from('profiles').insert({
//         'id': _userId,
//         'email': email,
//         'role': role,
//       });

//       _role = role;
//     }

//     _loading = false;
//     notifyListeners();
//   }

//   // -------------------------
//   // LOGIN using Supabase Auth (Email + Password)
//   // -------------------------
//   Future<bool> login({
//     required String email,
//     required String password,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     final response =
//         await supabase.auth.signInWithPassword(email: email, password: password);

//     if (response.user != null) {
//       _userId = response.user!.id;

//       // fetch profile
//       final profileData = await supabase
//           .from('profiles')
//           .select()
//           .eq('id', _userId!)
//           .maybeSingle();

//       _profile = profileData;
//       _role = profileData?['role'];
//       _loading = false;
//       notifyListeners();
//       return true;
//     }

//     _loading = false;
//     notifyListeners();
//     return false;
//   }

//   // -------------------------
//   // GOOGLE LOGIN (Supabase OAuth Sign-In)
//   // -------------------------
//   Future<void> signInWithGoogle() async {
//     try {
//       // This will open a browser tab or native Google sign-in flow
//       await supabase.auth.signInWithOAuth(
//         OAuthProvider.google,
//         redirectTo: 'io.supabase.flutter://login-callback/',
//       );

//       debugPrint('✅ Google login flow started successfully');
//     } catch (e, st) {
//       debugPrint('❌ Google OAuth error: $e');
//       debugPrint('$st');
//     }
//   }

//   // -------------------------
//   // SAVE / UPDATE PROFILE
//   // -------------------------
//   Future<void> saveProfile({
//     required String email,
//     required Map<String, dynamic> profile,
//   }) async {
//     await supabase.from('profiles').update({
//       'email': email,
//       'name': profile['name'],
//       'address': profile['address'],
//       'measurements': profile['measurements'],
//     }).eq('email', email);
//   }

//   // -------------------------
//   // LOGOUT
//   // -------------------------
//   Future<void> logout() async {
//     await supabase.auth.signOut();
//     _userId = null;
//     _role = null;
//     _profile = null;
//     notifyListeners();
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../utils/supabase_config.dart';

// class AuthProvider extends ChangeNotifier {
//   final supabase = SupabaseConfig.client;
//   bool _loading = false;
//   bool get loading => _loading;

//   String? _userId;
//   String? _role;
//   Map<String, dynamic>? _profile;

//   bool get isLoggedIn => _userId != null;
//   String? get role => _role;
//   Map<String, dynamic>? get profile => _profile;

//   // -------------------------
//   // SIGNUP using Supabase Auth (Email + Password)
//   // -------------------------
//   Future<void> signup({
//     required String email,
//     required String password,
//     required String role,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     final response = await supabase.auth.signUp(
//       email: email,
//       password: password,
//     );

//     if (response.user != null) {
//       _userId = response.user!.id;

//       // create profile in DB
//       await supabase.from('profiles').insert({
//         'id': _userId,
//         'email': email,
//         'role': role,
//       });

//       _role = role;
//     }

//     _loading = false;
//     notifyListeners();
//   }

//   // -------------------------
//   // LOGIN using Supabase Auth (Email + Password)
//   // -------------------------
//   Future<bool> login({
//     required String email,
//     required String password,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     final response =
//         await supabase.auth.signInWithPassword(email: email, password: password);

//     if (response.user != null) {
//       _userId = response.user!.id;

//       // fetch profile
//       final profileData = await supabase
//           .from('profiles')
//           .select()
//           .eq('id', _userId!)
//           .maybeSingle();

//       _profile = profileData;
//       _role = profileData?['role'];
//       _loading = false;
//       notifyListeners();
//       return true;
//     }

//     _loading = false;
//     notifyListeners();
//     return false;
//   }

//   // -------------------------
//   // GOOGLE LOGIN (Supabase OAuth Sign-In)
//   // -------------------------
//   Future<void> signInWithGoogle() async {
//     try {
//       // 🧩 Start Google OAuth flow (redirects to app after login)
//       await supabase.auth.signInWithOAuth(
//         OAuthProvider.google,
//         redirectTo: 'io.supabase.flutter://login-callback/', // ✅ exact redirect
//       );

//       debugPrint('✅ Google login flow started successfully');
//     } catch (e, st) {
//       debugPrint('❌ Google OAuth error: $e');
//       debugPrint('$st');
//     }
//   }

//   // -------------------------
//   // SAVE / UPDATE PROFILE
//   // -------------------------
//   Future<void> saveProfile({
//     required String email,
//     required Map<String, dynamic> profile,
//   }) async {
//     await supabase.from('profiles').update({
//       'email': email,
//       'name': profile['name'],
//       'address': profile['address'],
//       'measurements': profile['measurements'],
//     }).eq('email', email);
//   }

//   // -------------------------
//   // LOGOUT
//   // -------------------------
//   Future<void> logout() async {
//     await supabase.auth.signOut();
//     _userId = null;
//     _role = null;
//     _profile = null;
//     notifyListeners();
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../utils/supabase_config.dart';

// class AuthProvider extends ChangeNotifier {
//   final supabase = SupabaseConfig.client;
//   bool _loading = false;
//   bool get loading => _loading;

//   String? _userId;
//   String? _role;
//   Map<String, dynamic>? _profile;

//   bool get isLoggedIn => _userId != null;
//   String? get role => _role;
//   Map<String, dynamic>? get profile => _profile;

//   // -------------------------
//   // EMAIL SIGNUP
//   // -------------------------
//   Future<void> signup({
//     required String email,
//     required String password,
//     required String role,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     final response =
//         await supabase.auth.signUp(email: email, password: password);

//     if (response.user != null) {
//       _userId = response.user!.id;

//       await supabase.from('profiles').upsert({
//         'id': _userId,
//         'email': email,
//         'role': role,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _role = role;
//     }

//     _loading = false;
//     notifyListeners();
//   }

//   // -------------------------
//   // EMAIL LOGIN
//   // -------------------------
//   Future<bool> login({
//     required String email,
//     required String password,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     final response =
//         await supabase.auth.signInWithPassword(email: email, password: password);

//     if (response.user != null) {
//       _userId = response.user!.id;

//       final profileData = await supabase
//           .from('profiles')
//           .select()
//           .eq('id', _userId!)
//           .maybeSingle();

//       _profile = profileData;
//       _role = profileData?['role'];
//       _loading = false;
//       notifyListeners();
//       return true;
//     }

//     _loading = false;
//     notifyListeners();
//     return false;
//   }

//   // -------------------------
//   // GOOGLE SIGN-IN (updated flow)
//   // -------------------------
//   Future<User?> signInWithGoogle(BuildContext context) async {
//     try {
//       const webClientId =
//           '559355267991-rbkeddsaap3oguiaafktluop7m7ror52.apps.googleusercontent.com'; // ✅ same as previous project
//       final googleSignIn = GoogleSignIn(serverClientId: webClientId);

//       // Disconnect old session if exists
//       try {
//         final oldUser = await googleSignIn.signInSilently();
//         if (oldUser != null) await googleSignIn.disconnect();
//       } catch (_) {}

//       // Let user pick account
//       final googleUser = await googleSignIn.signIn();
//       if (googleUser == null) return null; // user cancelled

//       final googleAuth = await googleUser.authentication;
//       if (googleAuth.idToken == null || googleAuth.accessToken == null) {
//         debugPrint('⚠️ Missing Google tokens');
//         return null;
//       }

//       // Authenticate with Supabase
//       final res = await supabase.auth.signInWithIdToken(
//         provider: OAuthProvider.google,
//         idToken: googleAuth.idToken!,
//         accessToken: googleAuth.accessToken!,
//       );

//       final user = res.user;
//       if (user != null) {
//         _userId = user.id;

//         // Ensure user profile exists in DB
//         final existing = await supabase
//             .from('profiles')
//             .select()
//             .eq('id', user.id)
//             .maybeSingle();

//         if (existing == null) {
//           await supabase.from('profiles').insert({
//             'id': user.id,
//             'email': user.email,
//             'role': 'customer',
//             'created_at': DateTime.now().toIso8601String(),
//           });
//         }

//         notifyListeners();
//         debugPrint("✅ Google login successful: ${user.email}");
//         return user;
//       }
//     } catch (e, st) {
//       debugPrint('❌ Google Sign-In failed: $e');
//       debugPrint('$st');
//     }
//     return null;
//   }

//   // -------------------------
//   // LOGOUT
//   // -------------------------
//   Future<void> logout() async {
//     try {
//       await GoogleSignIn().disconnect();
//     } catch (_) {}
//     await supabase.auth.signOut();
//     _userId = null;
//     _role = null;
//     _profile = null;
//     notifyListeners();
//   }

//   Future<void> saveProfile({required String email, required Map<String, Object> profile}) async {}
// }wapussssssssssssssss

// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../utils/supabase_config.dart';
// import '../main.dart';

// class AuthProvider extends ChangeNotifier {
//   final supabase = SupabaseConfig.client;
//   bool _loading = false;
//   bool get loading => _loading;

//   String? _userId;
//   String? _role;
//   Map<String, dynamic>? _profile;

//   bool get isLoggedIn => _userId != null;
//   String? get role => _role;
//   Map<String, dynamic>? get profile => _profile;

//   // -------------------------
//   // EMAIL SIGNUP
//   // -------------------------
//   Future<void> signup({
//     required String email,
//     required String password,
//     required String role,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     final response =
//         await supabase.auth.signUp(email: email, password: password);

//     if (response.user != null) {
//       _userId = response.user!.id;

//       await supabase.from('profiles').upsert({
//         'id': _userId,
//         'email': email,
//         'role': role,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _role = role;
//     }

//     _loading = false;
//     notifyListeners();
//   }

//   // -------------------------
//   // EMAIL LOGIN
//   // -------------------------
//   Future<bool> login({
//     required String email,
//     required String password,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     final response =
//         await supabase.auth.signInWithPassword(email: email, password: password);

//     if (response.user != null) {
//       _userId = response.user!.id;

//       final profileData = await supabase
//           .from('profiles')
//           .select()
//           .eq('id', _userId!)
//           .maybeSingle();

//       _profile = profileData;
//       _role = profileData?['role'];
//       _loading = false;
//       notifyListeners();
//       return true;
//     }

//     _loading = false;
//     notifyListeners();
//     return false;
//   }

//   // -------------------------
//   // GOOGLE SIGN-IN (redirects to profile setup if new user)
//   // -------------------------
//   Future<void> signInWithGoogle(BuildContext context) async {
//     try {
//       const webClientId =
//           '559355267991-rbkeddsaap3oguiaafktluop7m7ror52.apps.googleusercontent.com';
//       final googleSignIn = GoogleSignIn(serverClientId: webClientId);

//       try {
//         final oldUser = await googleSignIn.signInSilently();
//         if (oldUser != null) await googleSignIn.disconnect();
//       } catch (_) {}

//       final googleUser = await googleSignIn.signIn();
//       if (googleUser == null) return; // cancelled

//       final googleAuth = await googleUser.authentication;
//       if (googleAuth.idToken == null || googleAuth.accessToken == null) {
//         debugPrint('⚠️ Missing Google tokens');
//         return;
//       }

//       final res = await supabase.auth.signInWithIdToken(
//         provider: OAuthProvider.google,
//         idToken: googleAuth.idToken!,
//         accessToken: googleAuth.accessToken!,
//       );

//       final user = res.user;
//       if (user != null) {
//         _userId = user.id;

//         // Check if profile already exists
//         final existingProfile = await supabase
//             .from('profiles')
//             .select()
//             .eq('id', user.id)
//             .maybeSingle();

//         if (existingProfile == null) {
//           // 👇 New Google user → go to profile setup
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             Routes.profileSetup,
//             (route) => false,
//           );
//         } else {
//           // Existing Google user → go to dashboard
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             Routes.dashboard,
//             (route) => false,
//           );
//         }
//       }
//     } catch (e, st) {
//       debugPrint('❌ Google Sign-In failed: $e');
//       debugPrint('$st');
//     }
//   }

//   // -------------------------
//   // SAVE PROFILE (Google + Email both)
//   // -------------------------
//   Future<void> saveProfile({
//     required String email,
//     required Map<String, dynamic> profile,
//   }) async {
//     await supabase.from('profiles').upsert({
//       'email': email,
//       'name': profile['name'],
//       'address': profile['address'],
//       'role': profile['role'],
//       'measurements': profile['measurements'],
//       'updated_at': DateTime.now().toIso8601String(),
//     }).eq('email', email);
//   }

//   // -------------------------
//   // LOGOUT
//   // -------------------------
//   Future<void> logout() async {
//     try {
//       await GoogleSignIn().disconnect();
//     } catch (_) {}
//     await supabase.auth.signOut();
//     _userId = null;
//     _role = null;
//     _profile = null;
//     notifyListeners();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../utils/supabase_config.dart';
// import '../main.dart';

// class AuthProvider extends ChangeNotifier {
//   final supabase = SupabaseConfig.client;
//   bool _loading = false;
//   bool get loading => _loading;

//   String? _userId;
//   String? _role;
//   Map<String, dynamic>? _profile;

//   bool get isLoggedIn => _userId != null;
//   String? get role => _role;
//   Map<String, dynamic>? get profile => _profile;

//   // -------------------------
//   // EMAIL SIGNUP
//   // -------------------------
//   Future<void> signup({
//     required String email,
//     required String password,
//     required String role,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     final response =
//         await supabase.auth.signUp(email: email, password: password);

//     if (response.user != null) {
//       _userId = response.user!.id;

//       await supabase.from('profiles').upsert({
//         'id': _userId,
//         'email': email,
//         'role': role,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _role = role;
//     }

//     _loading = false;
//     notifyListeners();
//   }

//   // -------------------------
//   // EMAIL LOGIN
//   // -------------------------
//   Future<bool> login({
//     required String email,
//     required String password,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     final response =
//         await supabase.auth.signInWithPassword(email: email, password: password);

//     if (response.user != null) {
//       _userId = response.user!.id;

//       final profileData = await supabase
//           .from('profiles')
//           .select()
//           .eq('id', _userId!)
//           .maybeSingle();

//       _profile = profileData;
//       _role = profileData?['role'];
//       _loading = false;
//       notifyListeners();
//       return true;
//     }

//     _loading = false;
//     notifyListeners();
//     return false;
//   }

//   // -------------------------
//   // GOOGLE SIGN-IN (redirects to profile setup if new user)
//   // -------------------------
//   Future<User?> signInWithGoogle(BuildContext context) async {
//     try {
//       const webClientId =
//           '559355267991-rbkeddsaap3oguiaafktluop7m7ror52.apps.googleusercontent.com';
//       final googleSignIn = GoogleSignIn(serverClientId: webClientId);

//       // Disconnect previous session silently
//       try {
//         final oldUser = await googleSignIn.signInSilently();
//         if (oldUser != null) await googleSignIn.disconnect();
//       } catch (_) {}

//       // Let user pick an account
//       final googleUser = await googleSignIn.signIn();
//       if (googleUser == null) return null; // cancelled

//       final googleAuth = await googleUser.authentication;
//       if (googleAuth.idToken == null || googleAuth.accessToken == null) {
//         debugPrint('⚠️ Missing Google tokens');
//         return null;
//       }

//       // Authenticate with Supabase
//       final res = await supabase.auth.signInWithIdToken(
//         provider: OAuthProvider.google,
//         idToken: googleAuth.idToken!,
//         accessToken: googleAuth.accessToken!,
//       );

//       final user = res.user;
//       if (user != null) {
//         _userId = user.id;

//         // Check if profile exists
//         final existingProfile = await supabase
//             .from('profiles')
//             .select()
//             .eq('id', user.id)
//             .maybeSingle();

//         if (existingProfile == null) {
//           // 👇 New Google user — send to Profile Setup
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             Routes.profileSetup,
//             (route) => false,
//           );
//         } else {
//           // Existing user — direct Dashboard
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             Routes.dashboard,
//             (route) => false,
//           );
//         }

//         notifyListeners();
//         return user;
//       }
//     } catch (e, st) {
//       debugPrint('❌ Google Sign-In failed: $e');
//       debugPrint('$st');
//     }
//     return null;
//   }

//   // -------------------------
//   // SAVE PROFILE (Email + Google both)
//   // -------------------------
//   Future<void> saveProfile({
//     required String email,
//     required Map<String, dynamic> profile,
//   }) async {
//     await supabase.from('profiles').upsert({
//       'email': email,
//       'name': profile['name'],
//       'address': profile['address'],
//       'role': profile['role'],
//       'measurements': profile['measurements'],
//       'updated_at': DateTime.now().toIso8601String(),
//     }).eq('email', email);
//   }

//   // -------------------------
//   // LOGOUT
//   // -------------------------
//   Future<void> logout() async {
//     try {
//       await GoogleSignIn().disconnect();
//     } catch (_) {}
//     await supabase.auth.signOut();
//     _userId = null;
//     _role = null;
//     _profile = null;
//     notifyListeners();
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../utils/supabase_config.dart';
// import '../main.dart';

// class AuthProvider extends ChangeNotifier {
//   final supabase = SupabaseConfig.client;
//   bool _loading = false;
//   bool get loading => _loading;

//   String? _userId;
//   String? _role;
//   Map<String, dynamic>? _profile;

//   bool get isLoggedIn => _userId != null;
//   String? get role => _role;
//   Map<String, dynamic>? get profile => _profile;

//   // -------------------------
//   // EMAIL SIGNUP
//   // -------------------------
//   Future<void> signup({
//     required String email,
//     required String password,
//     required String role,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     final response =
//         await supabase.auth.signUp(email: email, password: password);

//     if (response.user != null) {
//       _userId = response.user!.id;

//       await supabase.from('profiles').upsert({
//         'id': _userId,
//         'email': email,
//         'role': role,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _role = role;
//     }

//     _loading = false;
//     notifyListeners();
//   }

//   // -------------------------
//   // EMAIL LOGIN
//   // -------------------------
//   Future<bool> login({
//     required String email,
//     required String password,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     final response =
//         await supabase.auth.signInWithPassword(email: email, password: password);

//     if (response.user != null) {
//       _userId = response.user!.id;

//       final profileData = await supabase
//           .from('profiles')
//           .select()
//           .eq('id', _userId!)
//           .maybeSingle();

//       _profile = profileData;
//       _role = profileData?['role'];
//       _loading = false;
//       notifyListeners();
//       return true;
//     }

//     _loading = false;
//     notifyListeners();
//     return false;
//   }

//   // -------------------------
//   // GOOGLE SIGN-IN (redirects to profile setup if new user)
//   // -------------------------
//   Future<User?> signInWithGoogle(BuildContext context) async {
//     try {
//       const webClientId =
//           '559355267991-rbkeddsaap3oguiaafktluop7m7ror52.apps.googleusercontent.com';
//       final googleSignIn = GoogleSignIn(serverClientId: webClientId);

//       // Disconnect previous session silently
//       try {
//         final oldUser = await googleSignIn.signInSilently();
//         if (oldUser != null) await googleSignIn.disconnect();
//       } catch (_) {}

//       // Let user pick an account
//       final googleUser = await googleSignIn.signIn();
//       if (googleUser == null) return null; // cancelled

//       final googleAuth = await googleUser.authentication;
//       if (googleAuth.idToken == null || googleAuth.accessToken == null) {
//         debugPrint('⚠️ Missing Google tokens');
//         return null;
//       }

//       // Authenticate with Supabase
//       final res = await supabase.auth.signInWithIdToken(
//         provider: OAuthProvider.google,
//         idToken: googleAuth.idToken!,
//         accessToken: googleAuth.accessToken!,
//       );

//       final user = res.user;
//       if (user != null) {
//         _userId = user.id;

//         // Check if profile exists
//         final existingProfile = await supabase
//             .from('profiles')
//             .select()
//             .eq('id', user.id)
//             .maybeSingle();

//         if (existingProfile == null) {
//           // 👇 New Google user — send to Profile Setup
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             Routes.profileSetup,
//             (route) => false,
//           );
//         } else {
//           // Existing user — direct Dashboard
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             Routes.dashboard,
//             (route) => false,
//           );
//         }

//         notifyListeners();
//         return user;
//       }
//     } catch (e, st) {
//       debugPrint('❌ Google Sign-In failed: $e');
//       debugPrint('$st');
//     }
//     return null;
//   }

//   // -------------------------
//   // SAVE PROFILE (Email + Google both)
//   // -------------------------
//   Future<void> saveProfile({
//     required String email,
//     required Map<String, dynamic> profile,
//   }) async {
//     await supabase.from('profiles').upsert({
//       'email': email,
//       'name': profile['name'],
//       'address': profile['address'],
//       'role': profile['role'],
//       'measurements': profile['measurements'],
//       // removed 'updated_at' to avoid Postgrest errors when column doesn't exist
//     }).eq('email', email);
//   }

//   // -------------------------
//   // LOGOUT
//   // -------------------------
//   Future<void> logout() async {
//     try {
//       await GoogleSignIn().disconnect();
//     } catch (_) {}
//     await supabase.auth.signOut();
//     _userId = null;
//     _role = null;
//     _profile = null;
//     notifyListeners();
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../utils/supabase_config.dart';
// import '../main.dart';

// class AuthProvider extends ChangeNotifier {
//   final supabase = SupabaseConfig.client;
//   bool _loading = false;
//   bool get loading => _loading;

//   String? _userId;
//   String? _role;
//   Map<String, dynamic>? _profile;

//   bool get isLoggedIn => _userId != null;
//   String? get role => _role;
//   Map<String, dynamic>? get profile => _profile;

//   // -------------------------
//   // EMAIL SIGNUP
//   // -------------------------
//   Future<void> signup({
//     required String email,
//     required String password,
//     required String role,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     final response =
//         await supabase.auth.signUp(email: email, password: password);

//     if (response.user != null) {
//       _userId = response.user!.id;

//       await supabase.from('profiles').upsert({
//         'id': _userId, // ✅ uuid from Supabase Auth
//         'email': email,
//         'role': role,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       _role = role;
//     }

//     _loading = false;
//     notifyListeners();
//   }

//   // -------------------------
//   // EMAIL LOGIN
//   // -------------------------
//   Future<bool> login({
//     required String email,
//     required String password,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     final response =
//         await supabase.auth.signInWithPassword(email: email, password: password);

//     if (response.user != null) {
//       _userId = response.user!.id;

//       final profileData = await supabase
//           .from('profiles')
//           .select()
//           .eq('id', _userId!)
//           .maybeSingle();

//       _profile = profileData;
//       _role = profileData?['role'];
//       _loading = false;
//       notifyListeners();
//       return true;
//     }

//     _loading = false;
//     notifyListeners();
//     return false;
//   }

//   // -------------------------
//   // GOOGLE SIGN-IN (redirects to profile setup if new user)
//   // -------------------------
//   Future<User?> signInWithGoogle(BuildContext context) async {
//     try {
//       const webClientId =
//           '559355267991-rbkeddsaap3oguiaafktluop7m7ror52.apps.googleusercontent.com';
//       final googleSignIn = GoogleSignIn(serverClientId: webClientId);

//       try {
//         final oldUser = await googleSignIn.signInSilently();
//         if (oldUser != null) await googleSignIn.disconnect();
//       } catch (_) {}

//       final googleUser = await googleSignIn.signIn();
//       if (googleUser == null) return null;

//       final googleAuth = await googleUser.authentication;
//       if (googleAuth.idToken == null || googleAuth.accessToken == null) {
//         debugPrint('⚠️ Missing Google tokens');
//         return null;
//       }

//       final res = await supabase.auth.signInWithIdToken(
//         provider: OAuthProvider.google,
//         idToken: googleAuth.idToken!,
//         accessToken: googleAuth.accessToken!,
//       );

//       final user = res.user;
//       if (user != null) {
//         _userId = user.id;

//         final existingProfile = await supabase
//             .from('profiles')
//             .select()
//             .eq('id', user.id)
//             .maybeSingle();

//         if (existingProfile == null) {
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             Routes.profileSetup,
//             (route) => false,
//           );
//         } else {
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             Routes.dashboard,
//             (route) => false,
//           );
//         }

//         notifyListeners();
//         return user;
//       }
//     } catch (e, st) {
//       debugPrint('❌ Google Sign-In failed: $e');
//       debugPrint('$st');
//     }
//     return null;
//   }

//   // -------------------------
//   // SAVE PROFILE (Email + Google both)
//   // -------------------------
//   Future<void> saveProfile({
//     required String email,
//     required Map<String, dynamic> profile,
//   }) async {
//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) {
//       debugPrint('⚠️ No authenticated user found.');
//       return;
//     }

//     final userId = currentUser.id;

//     await supabase.from('profiles').upsert({
//       'id': userId, // ✅ must always include uuid id
//       'email': email,
//       'name': profile['name'],
//       'address': profile['address'],
//       'role': profile['role'],
//       'measurements': profile['measurements'],
//       'created_at': DateTime.now().toIso8601String(),
//     });
//   }

//   // -------------------------
//   // LOGOUT
//   // -------------------------
//   Future<void> logout() async {
//     try {
//       await GoogleSignIn().disconnect();
//     } catch (_) {}
//     await supabase.auth.signOut();
//     _userId = null;
//     _role = null;
//     _profile = null;
//     notifyListeners();
//   }
// }1 ky liya saii

// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../utils/supabase_config.dart';
// import '../main.dart';

// class AuthProvider extends ChangeNotifier {
//   final supabase = SupabaseConfig.client;
//   bool _loading = false;
//   bool get loading => _loading;

//   String? _userId;
//   String? _role;
//   Map<String, dynamic>? _profile;

//   bool get isLoggedIn => _userId != null;
//   String? get role => _role;
//   Map<String, dynamic>? get profile => _profile;

//   // -------------------------
//   // EMAIL SIGNUP
//   // -------------------------
//   Future<bool> signup({
//     required String email,
//     required String password,
//     required String role,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     try {
//       final response =
//           await supabase.auth.signUp(email: email, password: password);

//       if (response.user != null) {
//         _userId = response.user!.id;

//         await supabase.from('profiles').upsert({
//           'id': _userId, // uuid from Supabase Auth
//           'email': email,
//           'role': role,
//           'created_at': DateTime.now().toIso8601String(),
//         });

//         _role = role;
//         return true;
//       } else {
//         // signUp may return with no user if confirmation required etc.
//         debugPrint('⚠️ signup: no user returned from Supabase (maybe confirm email required).');
//         return false;
//       }
//     } on AuthApiException catch (e) {
//       debugPrint('❌ signup AuthApiException: ${e.message}');
//       return false;
//     } catch (e, st) {
//       debugPrint('❌ signup unexpected error: $e');
//       debugPrint('$st');
//       return false;
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   // -------------------------
//   // EMAIL LOGIN
//   // -------------------------
//   Future<bool> login({
//     required String email,
//     required String password,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     try {
//       final response = await supabase.auth.signInWithPassword(
//         email: email,
//         password: password,
//       );

//       if (response.user != null) {
//         _userId = response.user!.id;

//         final profileData = await supabase
//             .from('profiles')
//             .select()
//             .eq('id', _userId!)
//             .maybeSingle();

//         _profile = profileData;
//         _role = profileData?['role'];
//         return true;
//       } else {
//         // No user returned (shouldn't normally happen for valid credentials)
//         debugPrint('⚠️ login: no user returned from Supabase.');
//         return false;
//       }
//     } on AuthApiException catch (e) {
//       // Invalid credentials or other auth API errors are caught here
//       debugPrint('❌ login AuthApiException: ${e.message}');
//       return false;
//     } catch (e, st) {
//       debugPrint('❌ login unexpected error: $e');
//       debugPrint('$st');
//       return false;
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   // -------------------------
//   // GOOGLE SIGN-IN (redirects to profile setup if new user)
//   // -------------------------
//   Future<User?> signInWithGoogle(BuildContext context) async {
//     try {
//       const webClientId =
//           '559355267991-rbkeddsaap3oguiaafktluop7m7ror52.apps.googleusercontent.com';
//       final googleSignIn = GoogleSignIn(serverClientId: webClientId);

//       // Disconnect previous session silently
//       try {
//         final oldUser = await googleSignIn.signInSilently();
//         if (oldUser != null) await googleSignIn.disconnect();
//       } catch (_) {}

//       // Let user pick an account
//       final googleUser = await googleSignIn.signIn();
//       if (googleUser == null) return null; // user cancelled

//       final googleAuth = await googleUser.authentication;
//       if (googleAuth.idToken == null || googleAuth.accessToken == null) {
//         debugPrint('⚠️ Missing Google tokens');
//         return null;
//       }

//       // Authenticate with Supabase (this may throw AuthApiException)
//       final res = await supabase.auth.signInWithIdToken(
//         provider: OAuthProvider.google,
//         idToken: googleAuth.idToken!,
//         accessToken: googleAuth.accessToken!,
//       );

//       final user = res.user;
//       if (user != null) {
//         _userId = user.id;

//         final existingProfile = await supabase
//             .from('profiles')
//             .select()
//             .eq('id', user.id)
//             .maybeSingle();

//         if (existingProfile == null) {
//           // New Google user — go to profile setup
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             Routes.profileSetup,
//             (route) => false,
//           );
//         } else {
//           // Existing user — go to dashboard
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             Routes.dashboard,
//             (route) => false,
//           );
//         }

//         notifyListeners();
//         return user;
//       } else {
//         debugPrint('⚠️ signInWithGoogle: no user returned from Supabase.');
//         return null;
//       }
//     } on AuthApiException catch (e) {
//       debugPrint('❌ Google Sign-In AuthApiException: ${e.message}');
//       return null;
//     } catch (e, st) {
//       debugPrint('❌ Google Sign-In unexpected error: $e');
//       debugPrint('$st');
//       return null;
//     }
//   }

//   // -------------------------
//   // SAVE PROFILE (Email + Google both)
//   // -------------------------
//   Future<bool> saveProfile({
//     required String email,
//     required Map<String, dynamic> profile,
//   }) async {
//     try {
//       final currentUser = supabase.auth.currentUser;
//       if (currentUser == null) {
//         debugPrint('⚠️ saveProfile: No authenticated user found.');
//         return false;
//       }

//       final userId = currentUser.id;

//       await supabase.from('profiles').upsert({
//         'id': userId, // ensure uuid id
//         'email': email,
//         'name': profile['name'],
//         'address': profile['address'],
//         'role': profile['role'],
//         'measurements': profile['measurements'],
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       return true;
//     } on PostgrestException catch (e) {
//       debugPrint('❌ saveProfile PostgrestException: ${e.message}');
//       return false;
//     } catch (e, st) {
//       debugPrint('❌ saveProfile unexpected error: $e');
//       debugPrint('$st');
//       return false;
//     }
//   }

//   // -------------------------
//   // LOGOUT
//   // -------------------------
//   Future<void> logout() async {
//     try {
//       await GoogleSignIn().disconnect();
//     } catch (_) {}
//     try {
//       await supabase.auth.signOut();
//     } catch (e) {
//       debugPrint('⚠️ supabase.signOut error: $e');
//     }
//     _userId = null;
//     _role = null;
//     _profile = null;
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/supabase_config.dart';
import '../main.dart';

class AuthProvider extends ChangeNotifier {
  final supabase = SupabaseConfig.client;
  bool _loading = false;
  bool get loading => _loading;

  String? _userId;
  String? _role;
  Map<String, dynamic>? _profile;

  bool get isLoggedIn => _userId != null;
  String? get role => _role;
  Map<String, dynamic>? get profile => _profile;

  // -------------------------
  // EMAIL SIGNUP (Safe)
  // -------------------------
  Future<bool> signup({
    required String email,
    required String password,
    required String role,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      final response =
          await supabase.auth.signUp(email: email, password: password);

      // ✅ Supabase returns user null if email confirmation is required
      final user = response.user;

      if (user == null) {
        debugPrint('⚠️ Signup successful but email verification required.');
        return true; // we consider this successful
      }

      _userId = user.id;

      // ✅ Insert profile only if user.id exists in auth.users
      await supabase.from('profiles').upsert({
        'id': _userId,
        'email': email,
        'role': role,
        'created_at': DateTime.now().toIso8601String(),
      });

      _role = role;
      return true;
    } on PostgrestException catch (e) {
      debugPrint('❌ Signup PostgrestException: ${e.message}');
      return false;
    } on AuthApiException catch (e) {
      debugPrint('❌ Signup AuthApiException: ${e.message}');
      return false;
    } catch (e, st) {
      debugPrint('❌ Signup unexpected error: $e');
      debugPrint('$st');
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // -------------------------
  // EMAIL LOGIN
  // -------------------------
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      final response =
          await supabase.auth.signInWithPassword(email: email, password: password);

      if (response.user == null) {
        debugPrint('⚠️ login: Invalid credentials.');
        return false;
      }

      _userId = response.user!.id;

      final profileData = await supabase
          .from('profiles')
          .select()
          .eq('id', _userId!)
          .maybeSingle();

      _profile = profileData;
      _role = profileData?['role'];
      return true;
    } on AuthApiException catch (e) {
      debugPrint('❌ login AuthApiException: ${e.message}');
      return false;
    } catch (e, st) {
      debugPrint('❌ login unexpected error: $e');
      debugPrint('$st');
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // -------------------------
  // GOOGLE SIGN-IN (redirects to profile setup if new user)
  // -------------------------
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      const webClientId =
          '559355267991-rbkeddsaap3oguiaafktluop7m7ror52.apps.googleusercontent.com';
      final googleSignIn = GoogleSignIn(serverClientId: webClientId);

      try {
        final oldUser = await googleSignIn.signInSilently();
        if (oldUser != null) await googleSignIn.disconnect();
      } catch (_) {}

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null || googleAuth.accessToken == null) {
        debugPrint('⚠️ Missing Google tokens');
        return null;
      }

      final res = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken!,
      );

      final user = res.user;
      if (user != null) {
        _userId = user.id;

        final existingProfile = await supabase
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();

        if (existingProfile == null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.profileSetup,
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.dashboard,
            (route) => false,
          );
        }

        notifyListeners();
        return user;
      } else {
        debugPrint('⚠️ signInWithGoogle: no user returned from Supabase.');
        return null;
      }
    } on AuthApiException catch (e) {
      debugPrint('❌ Google Sign-In AuthApiException: ${e.message}');
      return null;
    } catch (e, st) {
      debugPrint('❌ Google Sign-In unexpected error: $e');
      debugPrint('$st');
      return null;
    }
  }

  // -------------------------
  // SAVE PROFILE (Email + Google both)
  // -------------------------
  Future<bool> saveProfile({
    required String email,
    required Map<String, dynamic> profile,
  }) async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        debugPrint('⚠️ saveProfile: No authenticated user found.');
        return false;
      }

      final userId = currentUser.id;

      await supabase.from('profiles').upsert({
        'id': userId,
        'email': email,
        'name': profile['name'],
        'address': profile['address'],
        'role': profile['role'],
        'measurements': profile['measurements'],
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } on PostgrestException catch (e) {
      debugPrint('❌ saveProfile PostgrestException: ${e.message}');
      return false;
    } catch (e, st) {
      debugPrint('❌ saveProfile unexpected error: $e');
      debugPrint('$st');
      return false;
    }
  }

  // -------------------------
  // LOGOUT
  // -------------------------
  Future<void> logout() async {
    try {
      await GoogleSignIn().disconnect();
    } catch (_) {}
    try {
      await supabase.auth.signOut();
    } catch (e) {
      debugPrint('⚠️ supabase.signOut error: $e');
    }
    _userId = null;
    _role = null;
    _profile = null;
    notifyListeners();
  }
}
