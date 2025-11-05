// import 'package:supabase_flutter/supabase_flutter.dart';

// /// Ensures that the currently signed-in user has a row in the 'profiles' table.
// /// This prevents Postgrest foreign key errors.
// Future<void> ensureUserProfileExists() async {
//   final supabase = Supabase.instance.client;
//   final user = supabase.auth.currentUser;
//   if (user == null) return;

//   try {
//     final existing = await supabase
//         .from('profiles')
//         .select('id')
//         .eq('id', user.id)
//         .maybeSingle();

//     if (existing == null) {
//       await supabase.from('profiles').insert({
//         'id': user.id,
//         'email': user.email ?? '',
//         'created_at': DateTime.now().toIso8601String(),
//       });
//       print('✅ Profile created for ${user.email}');
//     } else {
//       print('ℹ️ Profile already exists for ${user.email}');
//     }
//   } catch (e) {
//     print('⚠️ ensureUserProfileExists failed: $e');
//   }
// }saiiiiiiiiiiiiiiiiiiiiiiiiiiii

// import 'package:supabase_flutter/supabase_flutter.dart';

// /// Ensures that a user has a profile in the 'profiles' table.
// /// Only creates a profile if the user exists in Supabase Auth.
// /// If [userId] is not provided, it checks the currently signed-in user.
// Future<void> ensureUserProfileExists([String? userId, String? email]) async {
//   final supabase = Supabase.instance.client;
//   String id = userId ?? supabase.auth.currentUser?.id ?? '';
//   if (id.isEmpty) return;

//   try {
//     // Check if profile already exists
//     final existing = await supabase
//         .from('profiles')
//         .select('id')
//         .eq('id', id)
//         .maybeSingle();

//     if (existing != null) {
//       print('ℹ️ Profile already exists for $id');
//       return;
//     }

//     // Check if user exists in Auth
//     final user = await supabase.auth.admin.getUserById(id);

//     // Create profile safely
//     await supabase.from('profiles').insert({
//       'id': id,
//       'email': email ?? user.email ?? '',
//       'created_at': DateTime.now().toIso8601String(),
//     });
//     print('✅ Profile created for ${user.email}');
//   } catch (e) {
//     print('⚠️ ensureUserProfileExists failed for $id: $e');
//   }
// }
// import 'package:supabase_flutter/supabase_flutter.dart';

// /// Ensures that a user has a profile in the 'profiles' table.
// /// Only creates a profile if the user exists in Supabase Auth.
// /// If [userId] is not provided, it checks the currently signed-in user.
// Future<void> ensureUserProfileExists([String? userId, String? providedEmail]) async {
//   final supabase = Supabase.instance.client;
//   final String id = userId ?? supabase.auth.currentUser?.id ?? '';
//   if (id.isEmpty) return;

//   try {
//     // Check if profile already exists
//     final existing = await supabase
//         .from('profiles')
//         .select('id')
//         .eq('id', id)
//         .maybeSingle();

//     if (existing != null) {
//       print('ℹ️ Profile already exists for $id');
//       return;
//     }

//     // Check if user exists in Auth
//     final userResponse = await supabase.auth.admin.getUserById(id);
//     final user = userResponse.user;

//     if (user == null) {
//       print('⚠️ User $id does not exist in Auth. Cannot create profile.');
//       return;
//     }

//     // Create profile safely
//     await supabase.from('profiles').insert({
//       'id': id,
//       'email': providedEmail ?? user.email ?? '',
//       'created_at': DateTime.now().toIso8601String(),
//     });
//     print('✅ Profile created for ${user.email ?? 'unknown'}');
//   } catch (e) {
//     print('⚠️ ensureUserProfileExists failed for $id: $e');
//   }
// }
import 'package:supabase_flutter/supabase_flutter.dart';

/// Ensures that a user has a profile in the 'profiles' table.
/// If [userId] is not provided, it checks the currently signed-in user.
Future<void> ensureUserProfileExists([String? userId, String? providedEmail]) async {
  final supabase = Supabase.instance.client;
  final String id = userId ?? supabase.auth.currentUser?.id ?? '';
  if (id.isEmpty) return;

  try {
    // Check if profile already exists
    final existing = await supabase
        .from('profiles')
        .select('id')
        .eq('id', id)
        .maybeSingle();

    if (existing != null) {
      print('ℹ️ Profile already exists for $id');
      return;
    }

    // Create profile safely without Admin API
    await supabase.from('profiles').insert({
      'id': id,
      'email': providedEmail ?? '',
      'created_at': DateTime.now().toIso8601String(),
    });
    print('✅ Profile created for $id');
  } catch (e) {
    print('⚠️ ensureUserProfileExists failed for $id: $e');
  }
}
