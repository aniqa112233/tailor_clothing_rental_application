
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TailorProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool _loading = false;
  bool get loading => _loading;

  Map<String, dynamic>? _tailorProfile;
  Map<String, dynamic>? get tailorProfile => _tailorProfile;

  List<Map<String, dynamic>> _designs = [];
  List<Map<String, dynamic>> get designs => _designs;

  Map<String, dynamic>? _analytics;
  Map<String, dynamic>? get analytics => _analytics;

  // ==========================
  // Safe notifyListeners
  // ==========================
  void safeNotify() {
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle ||
        SchedulerBinding.instance.schedulerPhase ==
            SchedulerPhase.postFrameCallbacks) {
      notifyListeners();
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  // ==========================
  // Fetch Tailor Profile
  // ==========================
  Future<void> fetchTailorProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await _supabase
          .from('tailors')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      _tailorProfile = response;
      safeNotify();
    } catch (e) {
      print('❌ fetchTailorProfile error: $e');
    }
  }

  // ==========================
  // Register Tailor
  // ==========================
  Future<void> registerTailor(Map<String, dynamic> data) async {
    _loading = true;
    safeNotify();
    try {
      final response = await _supabase.from('tailors').insert({
        'user_id': _supabase.auth.currentUser?.id,
        'shop_name': data['shop_name'],
        'services': data['services'],
        'delivery_area': data['delivery_area'],
        'cnic': data['cnic'],
        'profile_image': data['profile_image'] ?? '',
      }).select().single();

      _tailorProfile = response;
    } catch (e) {
      print('❌ registerTailor error: $e');
      rethrow;
    } finally {
      _loading = false;
      safeNotify();
    }
  }

  // ==========================
  // Update Tailor Profile
  // ==========================
  Future<void> updateTailorProfile(Map<String, dynamic> data) async {
    if (_tailorProfile == null) return;

    _loading = true;
    safeNotify();
    try {
      final response = await _supabase
          .from('tailors')
          .update(data)
          .eq('id', _tailorProfile!['id'])
          .select()
          .single();

      _tailorProfile = response;
    } catch (e) {
      print('❌ updateTailorProfile error: $e');
      rethrow;
    } finally {
      _loading = false;
      safeNotify();
    }
  }

  // ==========================
  // Upload Profile Image
  // ==========================
  Future<void> uploadProfileImage(File imageFile) async {
    if (_tailorProfile == null) await fetchTailorProfile();
    if (_tailorProfile == null) return;

    _loading = true;
    safeNotify();

    try {
      final fileExt = imageFile.path.split('.').last;
      final fileName =
          'tailor_${_tailorProfile!['id']}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';

      // Upload image to Supabase Storage
      await _supabase.storage.from('profile_pictures').upload(fileName, imageFile);

      final imageUrl =
          _supabase.storage.from('profile_pictures').getPublicUrl(fileName);

      // Update profile image in database
      final response = await _supabase
          .from('tailors')
          .update({'profile_image': imageUrl})
          .eq('id', _tailorProfile!['id'])
          .select()
          .single();

      _tailorProfile = response;
    } on StorageException catch (e) {
      print('❌ Upload failed: ${e.message}');
    } catch (e) {
      print('❌ uploadProfileImage error: $e');
    } finally {
      _loading = false;
      safeNotify();
    }
  }

  // ==========================
  // Delete Profile Image
  // ==========================
  Future<void> deleteProfileImage() async {
    if (_tailorProfile == null || _tailorProfile!['profile_image'] == null) return;

    _loading = true;
    safeNotify();

    try {
      final imageUrl = _tailorProfile!['profile_image'] as String;
      final fileName = imageUrl.split('/').last;

      // Delete from storage
      await _supabase.storage.from('profile_pictures').remove([fileName]);

      // Remove from database
      final response = await _supabase
          .from('tailors')
          .update({'profile_image': null})
          .eq('id', _tailorProfile!['id'])
          .select()
          .single();

      _tailorProfile = response;
    } catch (e) {
      print('❌ deleteProfileImage error: $e');
    } finally {
      _loading = false;
      safeNotify();
    }
  }

  // ==========================
  // Upload Design
  // ==========================
  Future<void> addDesign(Map<String, dynamic> data) async {
    if (_tailorProfile == null) {
      await fetchTailorProfile();
      if (_tailorProfile == null) return;
    }

    _loading = true;
    safeNotify();

    try {
      final File file = data['image_file'];
      final fileExt = file.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

      await _supabase.storage.from('designs').upload(fileName, file);

      final imageUrl = _supabase.storage.from('designs').getPublicUrl(fileName);

      await _supabase.from('designs').insert({
        'tailor_id': _tailorProfile!['id'],
        'title': data['title'],
        'price': data['price'],
        'image_url': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
      }).select().single();

      SchedulerBinding.instance.addPostFrameCallback((_) {
        _designs.add({
          'title': data['title'],
          'price': data['price'],
          'image': file,
          'image_url': imageUrl,
        });
        _loading = false;
        safeNotify();
      });
    } catch (e) {
      print('❌ addDesign error: $e');
      _loading = false;
      safeNotify();
    }
  }

  // ==========================
  // Fetch Designs
  // ==========================
  Future<void> fetchDesigns() async {
    if (_tailorProfile == null) {
      await fetchTailorProfile();
      if (_tailorProfile == null) return;
    }

    _loading = true;
    safeNotify();

    try {
      final response = await _supabase
          .from('designs')
          .select()
          .eq('tailor_id', _tailorProfile!['id']);

      _designs = List<Map<String, dynamic>>.from(response.map((d) {
        return {
          'title': d['title'],
          'price': d['price'],
          'image_url': d['image_url'],
          'image': null,
        };
      }));
    } catch (e) {
      print('❌ fetchDesigns error: $e');
    } finally {
      _loading = false;
      safeNotify();
    }
  }

  // ==========================
  // Fetch Analytics
  // ==========================
  Future<void> fetchAnalytics() async {
    if (_tailorProfile == null) {
      await fetchTailorProfile();
      if (_tailorProfile == null) return;
    }

    _loading = true;
    safeNotify();

    try {
      final response = await _supabase
          .from('tailor_analytics')
          .select()
          .eq('tailor_id', _tailorProfile!['id'])
          .maybeSingle();

      _analytics = response ?? {};
    } catch (e) {
      print('❌ fetchAnalytics error: $e');
    } finally {
      _loading = false;
      safeNotify();
    }
  }

  // ==========================
  // Update Analytics (RLS-safe)
  // ==========================
  Future<void> updateAnalytics(Map<String, dynamic> data) async {
    if (_tailorProfile == null) return;
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    _loading = true;
    safeNotify();

    try {
      final existing = await _supabase
          .from('tailor_analytics')
          .select()
          .eq('tailor_id', _tailorProfile!['id'])
          .maybeSingle();

      if (existing == null) {
        await _supabase.from('tailor_analytics').insert({
          'tailor_id': _tailorProfile!['id'],
          'orders': data['orders'] ?? 0,
          'earnings': data['earnings'] ?? 0,
          'ratings': data['ratings'] ?? 0.0,
          'active_customers': data['active_customers'] ?? 0,
          'created_at': DateTime.now().toIso8601String(),
          'user_id': userId,
        });
      } else {
        await _supabase
            .from('tailor_analytics')
            .update({
              'orders': data['orders'] ?? existing['orders'],
              'earnings': data['earnings'] ?? existing['earnings'],
              'ratings': data['ratings'] ?? existing['ratings'],
              'active_customers':
                  data['active_customers'] ?? existing['active_customers'],
            })
            .eq('tailor_id', _tailorProfile!['id'])
            .eq('user_id', userId);
      }

      await fetchAnalytics();
    } catch (e) {
      print('❌ updateAnalytics error: $e');
    } finally {
      _loading = false;
      safeNotify();
    }
  }
}
