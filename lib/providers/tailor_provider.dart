// import 'package:flutter/material.dart';

// class TailorProvider extends ChangeNotifier {
//   bool _loading = false;
//   bool get loading => _loading;

//   // Simulated local data (Supabase integration later)
//   Map<String, dynamic>? _tailorProfile;

//   Map<String, dynamic>? get tailorProfile => _tailorProfile;

//   Future<void> registerTailor(Map<String, dynamic> data) async {
//     _loading = true;
//     notifyListeners();

//     await Future.delayed(const Duration(seconds: 2)); // fake API delay
//     _tailorProfile = data;

//     _loading = false;
//     notifyListeners();
//   }

//   Future<void> updateTailorProfile(Map<String, dynamic> data) async {
//     _tailorProfile?.addAll(data);
//     notifyListeners();
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class TailorProvider extends ChangeNotifier {
//   final SupabaseClient _supabase = Supabase.instance.client;

//   bool _loading = false;
//   bool get loading => _loading;

//   Map<String, dynamic>? _tailorProfile;
//   Map<String, dynamic>? get tailorProfile => _tailorProfile;

//   List<Map<String, dynamic>> _designs = [];
//   List<Map<String, dynamic>> get designs => _designs;

//   Map<String, dynamic>? _analytics;
//   Map<String, dynamic>? get analytics => _analytics;

//   // ==========================
//   // Tailor Registration
//   // ==========================
//   Future<void> registerTailor(Map<String, dynamic> data) async {
//     _loading = true;
//     notifyListeners();

//     try {
//       final response = await _supabase.from('tailors').insert({
//         'user_id': _supabase.auth.currentUser?.id,
//         'shop_name': data['shop_name'],
//         'services': data['services'],
//         'delivery_area': data['delivery_area'],
//         'cnic': data['cnic'],
//       }).select().single();

//       _tailorProfile = response;
//     } catch (e) {
//       print('❌ registerTailor error: $e');
//       rethrow;
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   // ==========================
//   // Update Tailor Profile
//   // ==========================
//   Future<void> updateTailorProfile(Map<String, dynamic> data) async {
//     if (_tailorProfile == null) return;

//     _loading = true;
//     notifyListeners();

//     try {
//       final response = await _supabase
//           .from('tailors')
//           .update(data)
//           .eq('id', _tailorProfile!['id'])
//           .select()
//           .single();

//       _tailorProfile = response;
//     } catch (e) {
//       print('❌ updateTailorProfile error: $e');
//       rethrow;
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   // ==========================
//   // Upload Design
//   // ==========================
//   Future<void> addDesign(Map<String, dynamic> data) async {
//     if (_tailorProfile == null) return;

//     _loading = true;
//     notifyListeners();

//     try {
//       final response = await _supabase.from('designs').insert({
//         'tailor_id': _tailorProfile!['id'],
//         'title': data['title'],
//         'description': data['description'],
//         'price': data['price'],
//         'image_url': data['image_url'],
//       }).select().single();

//       _designs.add(response);
//     } catch (e) {
//       print('❌ addDesign error: $e');
//       rethrow;
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   // ==========================
//   // Fetch Designs
//   // ==========================
//   Future<void> fetchDesigns() async {
//     if (_tailorProfile == null) return;

//     _loading = true;
//     notifyListeners();

//     try {
//       final response = await _supabase
//           .from('designs')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id']);

//       _designs = List<Map<String, dynamic>>.from(response);
//     } catch (e) {
//       print('❌ fetchDesigns error: $e');
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   // ==========================
//   // Fetch Analytics
//   // ==========================
//   Future<void> fetchAnalytics() async {
//     if (_tailorProfile == null) return;

//     _loading = true;
//     notifyListeners();

//     try {
//       final response = await _supabase
//           .from('tailor_analytics')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id'])
//           .single();

//       _analytics = response;
//     } catch (e) {
//       print('❌ fetchAnalytics error: $e');
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }
// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class TailorProvider extends ChangeNotifier {
//   final SupabaseClient _supabase = Supabase.instance.client;

//   bool _loading = false;
//   bool get loading => _loading;

//   Map<String, dynamic>? _tailorProfile;
//   Map<String, dynamic>? get tailorProfile => _tailorProfile;

//   List<Map<String, dynamic>> _designs = [];
//   List<Map<String, dynamic>> get designs => _designs;

//   Map<String, dynamic>? _analytics;
//   Map<String, dynamic>? get analytics => _analytics;

//   // ==========================
//   // Tailor Registration
//   // ==========================
//   Future<void> registerTailor(Map<String, dynamic> data) async {
//     _loading = true;
//     notifyListeners();

//     try {
//       final response = await _supabase.from('tailors').insert({
//         'user_id': _supabase.auth.currentUser?.id,
//         'shop_name': data['shop_name'],
//         'services': data['services'],
//         'delivery_area': data['delivery_area'],
//         'cnic': data['cnic'],
//       }).select().single();

//       _tailorProfile = response;
//     } catch (e) {
//       print('❌ registerTailor error: $e');
//       rethrow;
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   // ==========================
//   // Update Tailor Profile
//   // ==========================
//   Future<void> updateTailorProfile(Map<String, dynamic> data) async {
//     if (_tailorProfile == null) return;

//     _loading = true;
//     notifyListeners();

//     try {
//       final response = await _supabase
//           .from('tailors')
//           .update(data)
//           .eq('id', _tailorProfile!['id'])
//           .select()
//           .single();

//       _tailorProfile = response;
//     } catch (e) {
//       print('❌ updateTailorProfile error: $e');
//       rethrow;
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   // ==========================
//   // Upload Design (with Supabase Storage)
//   // ==========================
//   Future<void> addDesign(Map<String, dynamic> data) async {
//     if (_tailorProfile == null) return;

//     _loading = true;
//     notifyListeners();

//     try {
//       final File file = data['image_file'];
//       final fileExt = file.path.split('.').last;
//       final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

//       // 1️⃣ Upload to storage
//       await _supabase.storage.from('designs').upload(fileName, file);

//       // 2️⃣ Get public URL
//       final imageUrl = _supabase.storage.from('designs').getPublicUrl(fileName);

//       // 3️⃣ Insert into designs table
//       final response = await _supabase.from('designs').insert({
//         'tailor_id': _tailorProfile!['id'],
//         'title': data['title'],
//         'price': data['price'],
//         'image_url': imageUrl,
//       }).select().single();

//       _designs.add(response);
//     } catch (e) {
//       print('❌ addDesign error: $e');
//       rethrow;
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   // ==========================
//   // Fetch Designs
//   // ==========================
//   Future<void> fetchDesigns() async {
//     if (_tailorProfile == null) return;

//     _loading = true;
//     notifyListeners();

//     try {
//       final response = await _supabase
//           .from('designs')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id']);

//       _designs = List<Map<String, dynamic>>.from(response);
//     } catch (e) {
//       print('❌ fetchDesigns error: $e');
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   // ==========================
//   // Fetch Analytics
//   // ==========================
//   Future<void> fetchAnalytics() async {
//     if (_tailorProfile == null) return;

//     _loading = true;
//     notifyListeners();

//     try {
//       final response = await _supabase
//           .from('tailor_analytics')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id'])
//           .single();

//       _analytics = response;
//     } catch (e) {
//       print('❌ fetchAnalytics error: $e');
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }
// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class TailorProvider extends ChangeNotifier {
//   final SupabaseClient _supabase = Supabase.instance.client;

//   bool _loading = false;
//   bool get loading => _loading;

//   Map<String, dynamic>? _tailorProfile;
//   Map<String, dynamic>? get tailorProfile => _tailorProfile;

//   List<Map<String, dynamic>> _designs = [];
//   List<Map<String, dynamic>> get designs => _designs;

//   Map<String, dynamic>? _analytics;
//   Map<String, dynamic>? get analytics => _analytics;

//   // ==========================
//   // Tailor Registration
//   // ==========================
//   Future<void> registerTailor(Map<String, dynamic> data) async {
//     _loading = true;
//     notifyListeners();
//     try {
//       final response = await _supabase.from('tailors').insert({
//         'user_id': _supabase.auth.currentUser?.id,
//         'shop_name': data['shop_name'],
//         'services': data['services'],
//         'delivery_area': data['delivery_area'],
//         'cnic': data['cnic'],
//       }).select().single();

//       _tailorProfile = response;
//     } catch (e) {
//       print('❌ registerTailor error: $e');
//       rethrow;
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   // ==========================
//   // Update Tailor Profile
//   // ==========================
//   Future<void> updateTailorProfile(Map<String, dynamic> data) async {
//     if (_tailorProfile == null) return;

//     _loading = true;
//     notifyListeners();
//     try {
//       final response = await _supabase
//           .from('tailors')
//           .update(data)
//           .eq('id', _tailorProfile!['id'])
//           .select()
//           .single();

//       _tailorProfile = response;
//     } catch (e) {
//       print('❌ updateTailorProfile error: $e');
//       rethrow;
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   // ==========================
//   // Upload Design
//   // ==========================
//   Future<void> addDesign(Map<String, dynamic> data) async {
//     if (_tailorProfile == null) return;

//     _loading = true;
//     notifyListeners();

//     try {
//       final File file = data['image_file'];
//       final fileExt = file.path.split('.').last;
//       final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

//       // 1️⃣ Upload to storage bucket "designs"
//       final storageResponse =
//           await _supabase.storage.from('designs').upload(fileName, file);
//       if (storageResponse != null) print('Upload result: $storageResponse');

//       // 2️⃣ Get public URL
//       final imageUrl = _supabase.storage.from('designs').getPublicUrl(fileName);

//       // 3️⃣ Insert into designs table
//       final response = await _supabase.from('designs').insert({
//         'tailor_id': _tailorProfile!['id'],
//         'title': data['title'],
//         'price': data['price'],
//         'image_url': imageUrl,
//       }).select().single();

//       _designs.add(response);
//     } catch (e) {
//       print('❌ addDesign error: $e');
//       rethrow;
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   // ==========================
//   // Fetch Designs
//   // ==========================
//   Future<void> fetchDesigns() async {
//     if (_tailorProfile == null) return;

//     _loading = true;
//     notifyListeners();

//     try {
//       final response = await _supabase
//           .from('designs')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id']);

//       _designs = List<Map<String, dynamic>>.from(response);
//     } catch (e) {
//       print('❌ fetchDesigns error: $e');
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   // ==========================
//   // Fetch Analytics
//   // ==========================
//   Future<void> fetchAnalytics() async {
//     if (_tailorProfile == null) return;

//     _loading = true;
//     notifyListeners();

//     try {
//       final response = await _supabase
//           .from('tailor_analytics')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id'])
//           .maybeSingle();

//       _analytics = response ?? {};
//     } catch (e) {
//       print('❌ fetchAnalytics error: $e');
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }
// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class TailorProvider extends ChangeNotifier {
//   final SupabaseClient _supabase = Supabase.instance.client;

//   bool _loading = false;
//   bool get loading => _loading;

//   Map<String, dynamic>? _tailorProfile;
//   Map<String, dynamic>? get tailorProfile => _tailorProfile;

//   List<Map<String, dynamic>> _designs = [];
//   List<Map<String, dynamic>> get designs => _designs;

//   Map<String, dynamic>? _analytics;
//   Map<String, dynamic>? get analytics => _analytics;

//   // ==========================
//   // Fetch Tailor Profile
//   // ==========================
//   Future<void> fetchTailorProfile() async {
//     try {
//       final userId = _supabase.auth.currentUser?.id;
//       if (userId == null) {
//         print('⚠️ No logged-in user found!');
//         return;
//       }

//       print('📥 Fetching tailor profile for user_id: $userId');

//       final response = await _supabase
//           .from('tailors')
//           .select()
//           .eq('user_id', userId)
//           .maybeSingle();

//       if (response == null) {
//         print('❌ No tailor profile found in DB for this user');
//       } else {
//         print('✅ Tailor profile loaded: $response');
//       }

//       _tailorProfile = response;
//       notifyListeners();
//     } catch (e) {
//       print('❌ fetchTailorProfile error: $e');
//     }
//   }

//   // ==========================
//   // Register Tailor
//   // ==========================
//   Future<void> registerTailor(Map<String, dynamic> data) async {
//     _loading = true;
//     notifyListeners();
//     try {
//       final response = await _supabase.from('tailors').insert({
//         'user_id': _supabase.auth.currentUser?.id,
//         'shop_name': data['shop_name'],
//         'services': data['services'],
//         'delivery_area': data['delivery_area'],
//         'cnic': data['cnic'],
//       }).select().single();

//       _tailorProfile = response;
//       print('✅ Tailor registered successfully: $_tailorProfile');
//     } catch (e) {
//       print('❌ registerTailor error: $e');
//       rethrow;
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   // ==========================
//   // Update Tailor Profile
//   // ==========================
//   Future<void> updateTailorProfile(Map<String, dynamic> data) async {
//     if (_tailorProfile == null) return;

//     _loading = true;
//     notifyListeners();
//     try {
//       final response = await _supabase
//           .from('tailors')
//           .update(data)
//           .eq('id', _tailorProfile!['id'])
//           .select()
//           .single();

//       _tailorProfile = response;
//       print('✅ Tailor profile updated: $_tailorProfile');
//     } catch (e) {
//       print('❌ updateTailorProfile error: $e');
//       rethrow;
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   // ==========================
//   // Upload Design
//   // ==========================
//   Future<void> addDesign(Map<String, dynamic> data) async {
//     if (_tailorProfile == null) {
//       print('⚠️ Cannot upload design — tailorProfile is null!');
//       await fetchTailorProfile(); // try fetching again
//       if (_tailorProfile == null) {
//         print('❌ Still no tailor profile found. Aborting upload.');
//         return;
//       }
//     }

//     _loading = true;
//     notifyListeners();

//     try {
//       final File file = data['image_file'];
//       final fileExt = file.path.split('.').last;
//       final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

//       print('🖼️ Uploading image file: $fileName');

//       // 1️⃣ Upload to storage bucket
//       final storageResponse =
//           await _supabase.storage.from('designs').upload(fileName, file);
//       print('✅ File uploaded: $storageResponse');

//       // 2️⃣ Get public URL
//       final imageUrl = _supabase.storage.from('designs').getPublicUrl(fileName);
//       print('🌐 Image public URL: $imageUrl');

//       // 3️⃣ Insert into designs table
//       final response = await _supabase.from('designs').insert({
//         'tailor_id': _tailorProfile!['id'],
//         'title': data['title'],
//         'price': data['price'],
//         'image_url': imageUrl,
//         'created_at': DateTime.now().toIso8601String(),
//       }).select().single();

//       print('✅ Design inserted into DB: $response');

//       _designs.add(response);
//     } catch (e) {
//       print('❌ addDesign error: $e');
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   // ==========================
//   // Fetch Designs
//   // ==========================
//   Future<void> fetchDesigns() async {
//     if (_tailorProfile == null) {
//       print('⚠️ Cannot fetch designs — tailorProfile is null!');
//       await fetchTailorProfile();
//       if (_tailorProfile == null) return;
//     }

//     _loading = true;
//     notifyListeners();

//     try {
//       print('📦 Fetching designs for tailor_id: ${_tailorProfile!['id']}');

//       final response = await _supabase
//           .from('designs')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id']);

//       _designs = List<Map<String, dynamic>>.from(response);
//       print('✅ Designs fetched: ${_designs.length}');
//     } catch (e) {
//       print('❌ fetchDesigns error: $e');
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   // ==========================
//   // Fetch Analytics
//   // ==========================
//   Future<void> fetchAnalytics() async {
//     if (_tailorProfile == null) {
//       print('⚠️ Cannot fetch analytics — tailorProfile is null!');
//       await fetchTailorProfile();
//       if (_tailorProfile == null) return;
//     }

//     _loading = true;
//     notifyListeners();

//     try {
//       print('📊 Fetching analytics for tailor_id: ${_tailorProfile!['id']}');

//       final response = await _supabase
//           .from('tailor_analytics')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id'])
//           .maybeSingle();

//       _analytics = response ?? {};
//       print('✅ Analytics fetched: $_analytics');
//     } catch (e) {
//       print('❌ fetchAnalytics error: $e');
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }
// }saiiiiiiiiiiiiiiiiiiiii thaaaaaaaaaaaaaaaa
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class TailorProvider extends ChangeNotifier {
//   final SupabaseClient _supabase = Supabase.instance.client;

//   bool _loading = false;
//   bool get loading => _loading;

//   Map<String, dynamic>? _tailorProfile;
//   Map<String, dynamic>? get tailorProfile => _tailorProfile;

//   List<Map<String, dynamic>> _designs = [];
//   List<Map<String, dynamic>> get designs => _designs;

//   Map<String, dynamic>? _analytics;
//   Map<String, dynamic>? get analytics => _analytics;

//   void safeNotify() {
//     if (WidgetsBinding.instance.schedulerPhase == SchedulerPhase.idle ||
//         WidgetsBinding.instance.schedulerPhase == SchedulerPhase.postFrameCallbacks) {
//       notifyListeners();
//     } else {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         notifyListeners();
//       });
//     }
//   }

//   // ==========================
//   // Fetch Tailor Profile
//   // ==========================
//   Future<void> fetchTailorProfile() async {
//     try {
//       final userId = _supabase.auth.currentUser?.id;
//       if (userId == null) {
//         print('⚠️ No logged-in user found!');
//         return;
//       }

//       print('📥 Fetching tailor profile for user_id: $userId');

//       final response = await _supabase
//           .from('tailors')
//           .select()
//           .eq('user_id', userId)
//           .maybeSingle();

//       if (response == null) {
//         print('❌ No tailor profile found in DB for this user');
//       } else {
//         print('✅ Tailor profile loaded: $response');
//       }

//       _tailorProfile = response;
//       safeNotify();
//     } catch (e) {
//       print('❌ fetchTailorProfile error: $e');
//     }
//   }

//   // ==========================
//   // Register Tailor
//   // ==========================
//   Future<void> registerTailor(Map<String, dynamic> data) async {
//     _loading = true;
//     safeNotify();
//     try {
//       final response = await _supabase.from('tailors').insert({
//         'user_id': _supabase.auth.currentUser?.id,
//         'shop_name': data['shop_name'],
//         'services': data['services'],
//         'delivery_area': data['delivery_area'],
//         'cnic': data['cnic'],
//       }).select().single();

//       _tailorProfile = response;
//       print('✅ Tailor registered successfully: $_tailorProfile');
//     } catch (e) {
//       print('❌ registerTailor error: $e');
//       rethrow;
//     } finally {
//       _loading = false;
//       safeNotify();
//     }
//   }

//   // ==========================
//   // Update Tailor Profile
//   // ==========================
//   Future<void> updateTailorProfile(Map<String, dynamic> data) async {
//     if (_tailorProfile == null) return;

//     _loading = true;
//     safeNotify();
//     try {
//       final response = await _supabase
//           .from('tailors')
//           .update(data)
//           .eq('id', _tailorProfile!['id'])
//           .select()
//           .single();

//       _tailorProfile = response;
//       print('✅ Tailor profile updated: $_tailorProfile');
//     } catch (e) {
//       print('❌ updateTailorProfile error: $e');
//       rethrow;
//     } finally {
//       _loading = false;
//       safeNotify();
//     }
//   }

//   // ==========================
//   // Upload Design
//   // ==========================
//   Future<void> addDesign(Map<String, dynamic> data) async {
//     if (_tailorProfile == null) {
//       print('⚠️ Cannot upload design — tailorProfile is null!');
//       await fetchTailorProfile();
//       if (_tailorProfile == null) {
//         print('❌ Still no tailor profile found. Aborting upload.');
//         return;
//       }
//     }

//     _loading = true;
//     safeNotify();

//     try {
//       final File file = data['image_file'];
//       final fileExt = file.path.split('.').last;
//       final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

//       print('🖼️ Uploading image file: $fileName');

//       final storageResponse =
//           await _supabase.storage.from('designs').upload(fileName, file);
//       print('✅ File uploaded: $storageResponse');

//       final imageUrl = _supabase.storage.from('designs').getPublicUrl(fileName);
//       print('🌐 Image public URL: $imageUrl');

//       final response = await _supabase.from('designs').insert({
//         'tailor_id': _tailorProfile!['id'],
//         'title': data['title'],
//         'price': data['price'],
//         'image_url': imageUrl,
//         'created_at': DateTime.now().toIso8601String(),
//       }).select().single();

//       print('✅ Design inserted into DB: $response');
//       _designs.add(response);
//     } catch (e) {
//       print('❌ addDesign error: $e');
//     } finally {
//       _loading = false;
//       safeNotify();
//     }
//   }

//   // ==========================
//   // Fetch Designs
//   // ==========================
//   Future<void> fetchDesigns() async {
//     if (_tailorProfile == null) {
//       print('⚠️ Cannot fetch designs — tailorProfile is null!');
//       await fetchTailorProfile();
//       if (_tailorProfile == null) return;
//     }

//     _loading = true;
//     safeNotify();

//     try {
//       print('📦 Fetching designs for tailor_id: ${_tailorProfile!['id']}');
//       final response = await _supabase
//           .from('designs')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id']);

//       _designs = List<Map<String, dynamic>>.from(response);
//       print('✅ Designs fetched: ${_designs.length}');
//     } catch (e) {
//       print('❌ fetchDesigns error: $e');
//     } finally {
//       _loading = false;
//       safeNotify();
//     }
//   }

//   // ==========================
//   // Fetch Analytics
//   // ==========================
//   Future<void> fetchAnalytics() async {
//     if (_tailorProfile == null) {
//       print('⚠️ Cannot fetch analytics — tailorProfile is null!');
//       await fetchTailorProfile();
//       if (_tailorProfile == null) return;
//     }

//     _loading = true;
//     safeNotify();

//     try {
//       print('📊 Fetching analytics for tailor_id: ${_tailorProfile!['id']}');
//       final response = await _supabase
//           .from('tailor_analytics')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id'])
//           .maybeSingle();

//       _analytics = response ?? {};
//       print('✅ Analytics fetched: $_analytics');
//     } catch (e) {
//       print('❌ fetchAnalytics error: $e');
//     } finally {
//       _loading = false;
//       safeNotify();
//     }
//   }
// }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class TailorProvider extends ChangeNotifier {
//   final SupabaseClient _supabase = Supabase.instance.client;

//   bool _loading = false;
//   bool get loading => _loading;

//   Map<String, dynamic>? _tailorProfile;
//   Map<String, dynamic>? get tailorProfile => _tailorProfile;

//   List<Map<String, dynamic>> _designs = [];
//   List<Map<String, dynamic>> get designs => _designs;

//   Map<String, dynamic>? _analytics;
//   Map<String, dynamic>? get analytics => _analytics;

//   void safeNotify() {
//     if (WidgetsBinding.instance.schedulerPhase == SchedulerPhase.idle ||
//         WidgetsBinding.instance.schedulerPhase == SchedulerPhase.postFrameCallbacks) {
//       notifyListeners();
//     } else {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         notifyListeners();
//       });
//     }
//   }

//   // ==========================
//   // Fetch Tailor Profile
//   // ==========================
//   Future<void> fetchTailorProfile() async {
//     try {
//       final userId = _supabase.auth.currentUser?.id;
//       if (userId == null) {
//         print('⚠️ No logged-in user found!');
//         return;
//       }

//       print('📥 Fetching tailor profile for user_id: $userId');

//       final response = await _supabase
//           .from('tailors')
//           .select()
//           .eq('user_id', userId)
//           .maybeSingle();

//       if (response == null) {
//         print('❌ No tailor profile found in DB for this user');
//       } else {
//         print('✅ Tailor profile loaded: $response');
//       }

//       _tailorProfile = response;
//       safeNotify();
//     } catch (e) {
//       print('❌ fetchTailorProfile error: $e');
//     }
//   }

//   // ==========================
//   // Register Tailor
//   // ==========================
//   Future<void> registerTailor(Map<String, dynamic> data) async {
//     _loading = true;
//     safeNotify();
//     try {
//       final response = await _supabase.from('tailors').insert({
//         'user_id': _supabase.auth.currentUser?.id,
//         'shop_name': data['shop_name'],
//         'services': data['services'],
//         'delivery_area': data['delivery_area'],
//         'cnic': data['cnic'],
//       }).select().single();

//       _tailorProfile = response;
//       print('✅ Tailor registered successfully: $_tailorProfile');
//     } catch (e) {
//       print('❌ registerTailor error: $e');
//       rethrow;
//     } finally {
//       _loading = false;
//       safeNotify();
//     }
//   }

//   // ==========================
//   // Update Tailor Profile
//   // ==========================
//   Future<void> updateTailorProfile(Map<String, dynamic> data) async {
//     if (_tailorProfile == null) return;

//     _loading = true;
//     safeNotify();
//     try {
//       final response = await _supabase
//           .from('tailors')
//           .update(data)
//           .eq('id', _tailorProfile!['id'])
//           .select()
//           .single();

//       _tailorProfile = response;
//       print('✅ Tailor profile updated: $_tailorProfile');
//     } catch (e) {
//       print('❌ updateTailorProfile error: $e');
//       rethrow;
//     } finally {
//       _loading = false;
//       safeNotify();
//     }
//   }

//   // ==========================
//   // Upload Design (safe version)
//   // ==========================
//   Future<void> addDesign(Map<String, dynamic> data) async {
//     if (_tailorProfile == null) {
//       print('⚠️ Cannot upload design — tailorProfile is null!');
//       await fetchTailorProfile();
//       if (_tailorProfile == null) {
//         print('❌ Still no tailor profile found. Aborting upload.');
//         return;
//       }
//     }

//     _loading = true;
//     safeNotify();

//     try {
//       final File file = data['image_file'];
//       final fileExt = file.path.split('.').last;
//       final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

//       print('🖼️ Uploading image file: $fileName');

//       // ✅ SAFE UPLOAD HANDLING HERE
//       try {
//         final storageResponse =
//             await _supabase.storage.from('designs').upload(fileName, file);
//         print('✅ File uploaded: $storageResponse');
//       } on StorageException catch (e) {
//         print('❌ Storage upload failed: ${e.message}');
//         _loading = false;
//         safeNotify();
//         return; // Stop here safely
//       }

//       final imageUrl = _supabase.storage.from('designs').getPublicUrl(fileName);
//       print('🌐 Image public URL: $imageUrl');

//       final response = await _supabase.from('designs').insert({
//         'tailor_id': _tailorProfile!['id'],
//         'title': data['title'],
//         'price': data['price'],
//         'image_url': imageUrl,
//         'created_at': DateTime.now().toIso8601String(),
//       }).select().single();

//       print('✅ Design inserted into DB: $response');
//       _designs.add(response);
//     } catch (e) {
//       print('❌ addDesign error: $e');
//     } finally {
//       _loading = false;
//       safeNotify();
//     }
//   }

//   // ==========================
//   // Fetch Designs
//   // ==========================
//   Future<void> fetchDesigns() async {
//     if (_tailorProfile == null) {
//       print('⚠️ Cannot fetch designs — tailorProfile is null!');
//       await fetchTailorProfile();
//       if (_tailorProfile == null) return;
//     }

//     _loading = true;
//     safeNotify();

//     try {
//       print('📦 Fetching designs for tailor_id: ${_tailorProfile!['id']}');
//       final response = await _supabase
//           .from('designs')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id']);

//       _designs = List<Map<String, dynamic>>.from(response);
//       print('✅ Designs fetched: ${_designs.length}');
//     } catch (e) {
//       print('❌ fetchDesigns error: $e');
//     } finally {
//       _loading = false;
//       safeNotify();
//     }
//   }

//   // ==========================
//   // Fetch Analytics
//   // ==========================
//   Future<void> fetchAnalytics() async {
//     if (_tailorProfile == null) {
//       print('⚠️ Cannot fetch analytics — tailorProfile is null!');
//       await fetchTailorProfile();
//       if (_tailorProfile == null) return;
//     }

//     _loading = true;
//     safeNotify();

//     try {
//       print('📊 Fetching analytics for tailor_id: ${_tailorProfile!['id']}');
//       final response = await _supabase
//           .from('tailor_analytics')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id'])
//           .maybeSingle();

//       _analytics = response ?? {};
//       print('✅ Analytics fetched: $_analytics');
//     } catch (e) {
//       print('❌ fetchAnalytics error: $e');
//     } finally {
//       _loading = false;
//       safeNotify();
//     }
//   }
// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class TailorProvider extends ChangeNotifier {
//   final SupabaseClient _supabase = Supabase.instance.client;

//   bool _loading = false;
//   bool get loading => _loading;

//   Map<String, dynamic>? _tailorProfile;
//   Map<String, dynamic>? get tailorProfile => _tailorProfile;

//   List<Map<String, dynamic>> _designs = [];
//   List<Map<String, dynamic>> get designs => _designs;

//   Map<String, dynamic>? _analytics;
//   Map<String, dynamic>? get analytics => _analytics;

//   // ==========================
//   // Safe notifyListeners
//   // ==========================
//   void safeNotify() {
//     if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle ||
//         SchedulerBinding.instance.schedulerPhase == SchedulerPhase.postFrameCallbacks) {
//       notifyListeners();
//     } else {
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         notifyListeners();
//       });
//     }
//   }

//   // ==========================
//   // Fetch Tailor Profile
//   // ==========================
//   Future<void> fetchTailorProfile() async {
//     try {
//       final userId = _supabase.auth.currentUser?.id;
//       if (userId == null) {
//         print('⚠️ No logged-in user found!');
//         return;
//       }

//       print('📥 Fetching tailor profile for user_id: $userId');

//       final response = await _supabase
//           .from('tailors')
//           .select()
//           .eq('user_id', userId)
//           .maybeSingle();

//       if (response == null) {
//         print('❌ No tailor profile found in DB for this user');
//       } else {
//         print('✅ Tailor profile loaded: $response');
//       }

//       _tailorProfile = response;
//       safeNotify();
//     } catch (e) {
//       print('❌ fetchTailorProfile error: $e');
//     }
//   }

//   // ==========================
//   // Register Tailor
//   // ==========================
//   Future<void> registerTailor(Map<String, dynamic> data) async {
//     _loading = true;
//     safeNotify();
//     try {
//       final response = await _supabase.from('tailors').insert({
//         'user_id': _supabase.auth.currentUser?.id,
//         'shop_name': data['shop_name'],
//         'services': data['services'],
//         'delivery_area': data['delivery_area'],
//         'cnic': data['cnic'],
//       }).select().single();

//       _tailorProfile = response;
//       print('✅ Tailor registered successfully: $_tailorProfile');
//     } catch (e) {
//       print('❌ registerTailor error: $e');
//       rethrow;
//     } finally {
//       _loading = false;
//       safeNotify();
//     }
//   }

//   // ==========================
//   // Update Tailor Profile
//   // ==========================
//   Future<void> updateTailorProfile(Map<String, dynamic> data) async {
//     if (_tailorProfile == null) return;

//     _loading = true;
//     safeNotify();
//     try {
//       final response = await _supabase
//           .from('tailors')
//           .update(data)
//           .eq('id', _tailorProfile!['id'])
//           .select()
//           .single();

//       _tailorProfile = response;
//       print('✅ Tailor profile updated: $_tailorProfile');
//     } catch (e) {
//       print('❌ updateTailorProfile error: $e');
//       rethrow;
//     } finally {
//       _loading = false;
//       safeNotify();
//     }
//   }

//   // ==========================
//   // Upload Design (Safe)
//   // ==========================
//   Future<void> addDesign(Map<String, dynamic> data) async {
//     if (_tailorProfile == null) {
//       print('⚠️ Cannot upload design — tailorProfile is null!');
//       await fetchTailorProfile();
//       if (_tailorProfile == null) {
//         print('❌ Still no tailor profile found. Aborting upload.');
//         return;
//       }
//     }

//     _loading = true;
//     safeNotify();

//     try {
//       final File file = data['image_file'];
//       final fileExt = file.path.split('.').last;
//       final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

//       print('🖼️ Uploading image file: $fileName');

//       // Upload with error handling
//       try {
//         await _supabase.storage.from('designs').upload(fileName, file);
//       } on StorageException catch (e) {
//         print('❌ Storage upload failed: ${e.message}');
//         _loading = false;
//         safeNotify();
//         return;
//       }

//       final imageUrl = _supabase.storage.from('designs').getPublicUrl(fileName);
//       print('🌐 Image public URL: $imageUrl');

//       final response = await _supabase.from('designs').insert({
//         'tailor_id': _tailorProfile!['id'],
//         'title': data['title'],
//         'price': data['price'],
//         'image_url': imageUrl,
//         'created_at': DateTime.now().toIso8601String(),
//       }).select().single();

//       // Update UI safely after DB insert
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         _designs.add(response);
//         _loading = false;
//         safeNotify();
//       });

//       print('✅ Design inserted into DB: $response');
//     } catch (e) {
//       print('❌ addDesign error: $e');
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         _loading = false;
//         safeNotify();
//       });
//     }
//   }

//   // ==========================
//   // Fetch Designs
//   // ==========================
//   Future<void> fetchDesigns() async {
//     if (_tailorProfile == null) {
//       print('⚠️ Cannot fetch designs — tailorProfile is null!');
//       await fetchTailorProfile();
//       if (_tailorProfile == null) return;
//     }

//     _loading = true;
//     safeNotify();

//     try {
//       print('📦 Fetching designs for tailor_id: ${_tailorProfile!['id']}');
//       final response = await _supabase
//           .from('designs')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id']);

//       _designs = List<Map<String, dynamic>>.from(response);
//       print('✅ Designs fetched: ${_designs.length}');
//     } catch (e) {
//       print('❌ fetchDesigns error: $e');
//     } finally {
//       _loading = false;
//       safeNotify();
//     }
//   }

//   // ==========================
//   // Fetch Analytics
//   // ==========================
//   Future<void> fetchAnalytics() async {
//     if (_tailorProfile == null) {
//       print('⚠️ Cannot fetch analytics — tailorProfile is null!');
//       await fetchTailorProfile();
//       if (_tailorProfile == null) return;
//     }

//     _loading = true;
//     safeNotify();

//     try {
//       print('📊 Fetching analytics for tailor_id: ${_tailorProfile!['id']}');
//       final response = await _supabase
//           .from('tailor_analytics')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id'])
//           .maybeSingle();

//       _analytics = response ?? {};
//       print('✅ Analytics fetched: $_analytics');
//     } catch (e) {
//       print('❌ fetchAnalytics error: $e');
//     } finally {
//       _loading = false;
//       safeNotify();
//     }
//   }
// }10000000000000000000000000000000
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
        SchedulerBinding.instance.schedulerPhase == SchedulerPhase.postFrameCallbacks) {
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
      if (userId == null) {
        print('⚠️ No logged-in user found!');
        return;
      }

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
  // Upload Design (Safe)
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

      // Upload with error handling
      try {
        await _supabase.storage.from('designs').upload(fileName, file);
      } on StorageException catch (e) {
        print('❌ Storage upload failed: ${e.message}');
        _loading = false;
        safeNotify();
        return;
      }

      final imageUrl = _supabase.storage.from('designs').getPublicUrl(fileName);

      final response = await _supabase.from('designs').insert({
        'tailor_id': _tailorProfile!['id'],
        'title': data['title'],
        'price': data['price'],
        'image_url': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
      }).select().single();

      // Add design safely to local list
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _designs.add({
          'title': data['title'],
          'price': data['price'],
          'image': file,       // Local file for preview
          'image_url': imageUrl
        });
        _loading = false;
        safeNotify();
      });

    } catch (e) {
      print('❌ addDesign error: $e');
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _loading = false;
        safeNotify();
      });
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
          'image': null, // optional, for Image.file safety
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
}

