
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
  // EMAIL SIGNUP (Safe + Tailor Profile Auto Create)
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

      final user = response.user;

      if (user == null) {
        debugPrint('⚠️ Signup successful but email verification required.');
        return true;
      }

      _userId = user.id;

      // ✅ Insert user profile in 'profiles' table
      if (_userId != null) {
        await supabase.from('profiles').upsert({
          'id': _userId,
          'email': email,
          'role': role,
          'created_at': DateTime.now().toIso8601String(),
        });

        // ✅ If user is a tailor, also create empty tailor record in 'tailors' table
        if (role == 'tailor') {
          final existingTailor = await supabase
              .from('tailors')
              .select('user_id')
              .eq('user_id', _userId!)
              .maybeSingle();

          if (existingTailor == null) {
            await supabase.from('tailors').insert({
              'user_id': _userId,
              'shop_name': '',
              'cnic': '',
              'delivery_area': '',
              'services': [],
              'created_at': DateTime.now().toIso8601String(),
            });
            debugPrint('🧵 Tailor record created successfully for $_userId');
          }
        }
      }

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
      final response = await supabase.auth
          .signInWithPassword(email: email, password: password);

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
  // GOOGLE SIGN-IN
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
  // SAVE PROFILE
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
