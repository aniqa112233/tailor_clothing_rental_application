
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

//       final response = await _supabase
//           .from('tailors')
//           .select()
//           .eq('user_id', userId)
//           .maybeSingle();

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
//       await fetchTailorProfile();
//       if (_tailorProfile == null) return;
//     }

//     _loading = true;
//     safeNotify();

//     try {
//       final File file = data['image_file'];
//       final fileExt = file.path.split('.').last;
//       final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

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

//       final response = await _supabase.from('designs').insert({
//         'tailor_id': _tailorProfile!['id'],
//         'title': data['title'],
//         'price': data['price'],
//         'image_url': imageUrl,
//         'created_at': DateTime.now().toIso8601String(),
//       }).select().single();

//       // Add design safely to local list
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         _designs.add({
//           'title': data['title'],
//           'price': data['price'],
//           'image': file,       // Local file for preview
//           'image_url': imageUrl
//         });
//         _loading = false;
//         safeNotify();
//       });

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
//       await fetchTailorProfile();
//       if (_tailorProfile == null) return;
//     }

//     _loading = true;
//     safeNotify();

//     try {
//       final response = await _supabase
//           .from('designs')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id']);

//       _designs = List<Map<String, dynamic>>.from(response.map((d) {
//         return {
//           'title': d['title'],
//           'price': d['price'],
//           'image_url': d['image_url'],
//           'image': null, // optional, for Image.file safety
//         };
//       }));
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
//       await fetchTailorProfile();
//       if (_tailorProfile == null) return;
//     }

//     _loading = true;
//     safeNotify();

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

//       final response = await _supabase
//           .from('tailors')
//           .select()
//           .eq('user_id', userId)
//           .maybeSingle();

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
//       await fetchTailorProfile();
//       if (_tailorProfile == null) return;
//     }

//     _loading = true;
//     safeNotify();

//     try {
//       final File file = data['image_file'];
//       final fileExt = file.path.split('.').last;
//       final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

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

//       final response = await _supabase.from('designs').insert({
//         'tailor_id': _tailorProfile!['id'],
//         'title': data['title'],
//         'price': data['price'],
//         'image_url': imageUrl,
//         'created_at': DateTime.now().toIso8601String(),
//       }).select().single();

//       // Add design safely to local list
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         _designs.add({
//           'title': data['title'],
//           'price': data['price'],
//           'image': file,       // Local file for preview
//           'image_url': imageUrl
//         });
//         _loading = false;
//         safeNotify();
//       });

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
//       await fetchTailorProfile();
//       if (_tailorProfile == null) return;
//     }

//     _loading = true;
//     safeNotify();

//     try {
//       final response = await _supabase
//           .from('designs')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id']);

//       _designs = List<Map<String, dynamic>>.from(response.map((d) {
//         return {
//           'title': d['title'],
//           'price': d['price'],
//           'image_url': d['image_url'],
//           'image': null, // optional, for Image.file safety
//         };
//       }));
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
//       await fetchTailorProfile();
//       if (_tailorProfile == null) return;
//     }

//     _loading = true;
//     safeNotify();

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
//       safeNotify();
//     }
//   }

//   // ==========================
//   // Update Analytics (NEW)
//   // ==========================
//   Future<void> updateAnalytics(Map<String, dynamic> data) async {
//     if (_tailorProfile == null) return;

//     _loading = true;
//     safeNotify();

//     try {
//       final existing = await _supabase
//           .from('tailor_analytics')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id'])
//           .maybeSingle();

//       if (existing == null) {
//         // Insert new row
//         await _supabase.from('tailor_analytics').insert({
//           'tailor_id': _tailorProfile!['id'],
//           'orders': data['orders'] ?? 0,
//           'earnings': data['earnings'] ?? 0,
//           'ratings': data['ratings'] ?? 0.0,
//           'active_customers': data['active_customers'] ?? 0,
//           'created_at': DateTime.now().toIso8601String(),
//         });
//       } else {
//         // Update existing row
//         await _supabase
//             .from('tailor_analytics')
//             .update({
//               'orders': data['orders'] ?? existing['orders'],
//               'earnings': data['earnings'] ?? existing['earnings'],
//               'ratings': data['ratings'] ?? existing['ratings'],
//               'active_customers': data['active_customers'] ?? existing['active_customers'],
//             })
//             .eq('tailor_id', _tailorProfile!['id']);
//       }

//       // Refresh analytics in provider
//       await fetchAnalytics();
//     } catch (e) {
//       print('❌ updateAnalytics error: $e');
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

//       final response = await _supabase
//           .from('tailors')
//           .select()
//           .eq('user_id', userId)
//           .maybeSingle();

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
//       await fetchTailorProfile();
//       if (_tailorProfile == null) return;
//     }

//     _loading = true;
//     safeNotify();

//     try {
//       final File file = data['image_file'];
//       final fileExt = file.path.split('.').last;
//       final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

//       try {
//         await _supabase.storage.from('designs').upload(fileName, file);
//       } on StorageException catch (e) {
//         print('❌ Storage upload failed: ${e.message}');
//         _loading = false;
//         safeNotify();
//         return;
//       }

//       final imageUrl = _supabase.storage.from('designs').getPublicUrl(fileName);

//       final response = await _supabase.from('designs').insert({
//         'tailor_id': _tailorProfile!['id'],
//         'title': data['title'],
//         'price': data['price'],
//         'image_url': imageUrl,
//         'created_at': DateTime.now().toIso8601String(),
//       }).select().single();

//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         _designs.add({
//           'title': data['title'],
//           'price': data['price'],
//           'image': file,
//           'image_url': imageUrl
//         });
//         _loading = false;
//         safeNotify();
//       });

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
//       await fetchTailorProfile();
//       if (_tailorProfile == null) return;
//     }

//     _loading = true;
//     safeNotify();

//     try {
//       final response = await _supabase
//           .from('designs')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id']);

//       _designs = List<Map<String, dynamic>>.from(response.map((d) {
//         return {
//           'title': d['title'],
//           'price': d['price'],
//           'image_url': d['image_url'],
//           'image': null,
//         };
//       }));
//     } catch (e) {
//       print('❌ fetchDesigns error: $e');
//     } finally {
//       _loading = false;
//       safeNotify();
//     }
//   }

//   // ==========================
//   // Fetch Analytics (UUID-safe)
//   // ==========================
//   Future<void> fetchAnalytics() async {
//     if (_tailorProfile == null) {
//       await fetchTailorProfile();
//       if (_tailorProfile == null) return;
//     }

//     _loading = true;
//     safeNotify();

//     try {
//       final response = await _supabase
//           .from('tailor_analytics')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id'].toString()) // UUID cast
//           .maybeSingle();

//       _analytics = response ?? {};
//     } catch (e) {
//       print('❌ fetchAnalytics error: $e');
//     } finally {
//       _loading = false;
//       safeNotify();
//     }
//   }

//   // ==========================
//   // Update Analytics (UUID-safe & RLS compliant)
//   // ==========================
//   Future<void> updateAnalytics(Map<String, dynamic> data) async {
//     if (_tailorProfile == null) return;

//     _loading = true;
//     safeNotify();

//     try {
//       final existing = await _supabase
//           .from('tailor_analytics')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id'].toString()) // UUID cast
//           .maybeSingle();

//       if (existing == null) {
//         await _supabase.from('tailor_analytics').insert({
//           'tailor_id': _tailorProfile!['id'].toString(), // UUID cast
//           'orders': data['orders'] ?? 0,
//           'earnings': data['earnings'] ?? 0,
//           'ratings': data['ratings'] ?? 0.0,
//           'active_customers': data['active_customers'] ?? 0,
//           'created_at': DateTime.now().toIso8601String(),
//         });
//       } else {
//         await _supabase
//             .from('tailor_analytics')
//             .update({
//               'orders': data['orders'] ?? existing['orders'],
//               'earnings': data['earnings'] ?? existing['earnings'],
//               'ratings': data['ratings'] ?? existing['ratings'],
//               'active_customers': data['active_customers'] ?? existing['active_customers'],
//             })
//             .eq('tailor_id', _tailorProfile!['id'].toString()); // UUID cast
//       }

//       await fetchAnalytics();
//     } catch (e) {
//       print('❌ updateAnalytics error: $e');
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

//       final response = await _supabase
//           .from('tailors')
//           .select()
//           .eq('user_id', userId)
//           .maybeSingle();

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
//       await fetchTailorProfile();
//       if (_tailorProfile == null) return;
//     }

//     _loading = true;
//     safeNotify();

//     try {
//       final File file = data['image_file'];
//       final fileExt = file.path.split('.').last;
//       final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

//       try {
//         await _supabase.storage.from('designs').upload(fileName, file);
//       } on StorageException catch (e) {
//         print('❌ Storage upload failed: ${e.message}');
//         _loading = false;
//         safeNotify();
//         return;
//       }

//       final imageUrl = _supabase.storage.from('designs').getPublicUrl(fileName);

//       final response = await _supabase.from('designs').insert({
//         'tailor_id': _tailorProfile!['id'],
//         'title': data['title'],
//         'price': data['price'],
//         'image_url': imageUrl,
//         'created_at': DateTime.now().toIso8601String(),
//       }).select().single();

//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         _designs.add({
//           'title': data['title'],
//           'price': data['price'],
//           'image': file,
//           'image_url': imageUrl
//         });
//         _loading = false;
//         safeNotify();
//       });

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
//       await fetchTailorProfile();
//       if (_tailorProfile == null) return;
//     }

//     _loading = true;
//     safeNotify();

//     try {
//       final response = await _supabase
//           .from('designs')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id']);

//       _designs = List<Map<String, dynamic>>.from(response.map((d) {
//         return {
//           'title': d['title'],
//           'price': d['price'],
//           'image_url': d['image_url'],
//           'image': null,
//         };
//       }));
//     } catch (e) {
//       print('❌ fetchDesigns error: $e');
//     } finally {
//       _loading = false;
//       safeNotify();
//     }
//   }

//   // ==========================
//   // Fetch Analytics (UUID-safe)
//   // ==========================
//   Future<void> fetchAnalytics() async {
//     if (_tailorProfile == null) {
//       await fetchTailorProfile();
//       if (_tailorProfile == null) return;
//     }

//     _loading = true;
//     safeNotify();

//     try {
//       final response = await _supabase
//           .from('tailor_analytics')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id'].toString()) // UUID cast
//           .maybeSingle();

//       _analytics = response ?? {};
//     } catch (e) {
//       print('❌ fetchAnalytics error: $e');
//     } finally {
//       _loading = false;
//       safeNotify();
//     }
//   }

//   // ==========================
//   // Update Analytics (UUID-safe & RLS compliant)
//   // ==========================
//   Future<void> updateAnalytics(Map<String, dynamic> data) async {
//     if (_tailorProfile == null) return;

//     _loading = true;
//     safeNotify();

//     try {
//       final existing = await _supabase
//           .from('tailor_analytics')
//           .select()
//           .eq('tailor_id', _tailorProfile!['id'].toString()) // UUID cast
//           .maybeSingle();

//       if (existing == null) {
//         await _supabase.from('tailor_analytics').insert({
//           'tailor_id': _tailorProfile!['id'].toString(), // UUID cast
//           'orders': data['orders'] ?? 0,
//           'earnings': data['earnings'] ?? 0,
//           'ratings': data['ratings'] ?? 0.0,
//           'active_customers': data['active_customers'] ?? 0,
//           'created_at': DateTime.now().toIso8601String(),
//         });
//       } else {
//         await _supabase
//             .from('tailor_analytics')
//             .update({
//               'orders': data['orders'] ?? existing['orders'],
//               'earnings': data['earnings'] ?? existing['earnings'],
//               'ratings': data['ratings'] ?? existing['ratings'],
//               'active_customers': data['active_customers'] ?? existing['active_customers'],
//             })
//             .eq('tailor_id', _tailorProfile!['id'].toString()); // UUID cast
//       }

//       await fetchAnalytics();
//     } catch (e) {
//       print('❌ updateAnalytics error: $e');
//     } finally {
//       _loading = false;
//       safeNotify();
//     }
//   }
// }
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

      try {
        await _supabase.storage.from('designs').upload(fileName, file);
      } on StorageException catch (e) {
        print('❌ Storage upload failed: ${e.message}');
        _loading = false;
        safeNotify();
        return;
      }

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
    if (userId == null) return; // user must be logged in

    _loading = true;
    safeNotify();

    try {
      final existing = await _supabase
          .from('tailor_analytics')
          .select()
          .eq('tailor_id', _tailorProfile!['id'])
          .maybeSingle();

      if (existing == null) {
        // insert only if current user owns the tailor
        await _supabase.from('tailor_analytics').insert({
          'tailor_id': _tailorProfile!['id'],
          'orders': data['orders'] ?? 0,
          'earnings': data['earnings'] ?? 0,
          'ratings': data['ratings'] ?? 0.0,
          'active_customers': data['active_customers'] ?? 0,
          'created_at': DateTime.now().toIso8601String(),
          'user_id': userId, // ensure ownership for RLS
        });
      } else {
        await _supabase
            .from('tailor_analytics')
            .update({
              'orders': data['orders'] ?? existing['orders'],
              'earnings': data['earnings'] ?? existing['earnings'],
              'ratings': data['ratings'] ?? existing['ratings'],
              'active_customers': data['active_customers'] ?? existing['active_customers'],
            })
            .eq('tailor_id', _tailorProfile!['id'])
            .eq('user_id', userId); // RLS-safe update
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
