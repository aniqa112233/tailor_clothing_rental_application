
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
  // EMAIL SIGNUP
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
      if (user == null) return true;

      _userId = user.id;

      await supabase.rpc('ensure_profile_exists', params: {
        'p_user_id': _userId,
        'p_email': email,
        'p_role': role,
      });

      if (role == 'tailor') {
        await supabase.rpc('ensure_tailor_exists', params: {
          'p_user_id': _userId,
        });
      }

      _role = role;
      return true;
    } catch (e, st) {
      debugPrint('❌ signup error: $e');
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
    required BuildContext context, // ✅ context required
  }) async {
    _loading = true;
    notifyListeners();
    try {
      final response =
          await supabase.auth.signInWithPassword(email: email, password: password);
      if (response.user == null) return false;

      _userId = response.user!.id;

      final profileData = await supabase
          .from('profiles')
          .select()
          .eq('id', _userId!)
          .maybeSingle();

      _profile = profileData;
      _role = profileData?['role'];

      // Navigate after login
      Navigator.pushReplacementNamed(context, Routes.dashboard);
      return true;
    } catch (e, st) {
      debugPrint('❌ login error: $e');
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
      if (user == null) return null;

      _userId = user.id;
      _role = 'customer';

      // Ensure profile exists
      await supabase.rpc('ensure_profile_exists', params: {
        'p_user_id': _userId,
        'p_email': googleUser.email,
        'p_role': 'customer',
      });

      Navigator.pushReplacementNamed(context, Routes.dashboard);
      notifyListeners();
      return user;
    } catch (e, st) {
      debugPrint('❌ Google sign-in error: $e');
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
      if (currentUser == null) return false;

      final userId = currentUser.id;

      await supabase.from('profiles').upsert({
        'id': userId,
        'email': email,
        'name': profile['name'],
        'address': profile['address'],
        'role': profile['role'],
        'measurements': profile['measurements'],
        'updated_at': DateTime.now().toIso8601String(),
      });

      _profile = {
        'id': userId,
        'email': email,
        'name': profile['name'],
        'address': profile['address'],
        'role': profile['role'],
        'measurements': profile['measurements'],
      };
      _role = profile['role'];

      notifyListeners();
      return true;
    } catch (e, st) {
      debugPrint('❌ saveProfile error: $e');
      debugPrint('$st');
      return false;
    }
  }

  // -------------------------
  // LOGOUT
  // -------------------------
  Future<void> logout(BuildContext context) async {
    try {
      await GoogleSignIn().disconnect();
    } catch (_) {}
    try {
      await supabase.auth.signOut();
    } catch (e) {
      debugPrint('⚠️ signOut error: $e');
    }

    _userId = null;
    _role = null;
    _profile = null;
    notifyListeners();

    Navigator.pushReplacementNamed(context, Routes.login);
  }
}
