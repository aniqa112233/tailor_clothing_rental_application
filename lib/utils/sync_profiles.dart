// import 'package:supabase_flutter/supabase_flutter.dart';

// /// One-time sync: ensures every Auth user has a corresponding profile
// Future<void> syncExistingUsersToProfiles() async {
//   final supabase = Supabase.instance.client;

//   try {
//     // Fetch all users from Supabase Auth
//     final List<User> allUsers = await supabase.auth.admin.listUsers();
//     print('Found ${allUsers.length} users in Auth.');

//     for (var user in allUsers) {
//       final userId = user.id;

//       // Check if the profile already exists
//       final existingProfile = await supabase
//           .from('profiles')
//           .select('id')
//           .eq('id', userId)
//           .maybeSingle();

//       if (existingProfile == null) {
//         // Insert minimal profile
//         await supabase.from('profiles').insert({
//           'id': userId,
//           'email': user.email ?? '',
//           'name': '',
//           'address': '',
//           'role': '',
//           'measurements': {},
//           'created_at': DateTime.now().toIso8601String(),
//         });

//         print('✅ Created profile for user: ${user.email ?? userId}');
//       } else {
//         print('ℹ️ Profile already exists for user: ${user.email ?? userId}');
//       }
//     }

//     print('✅ All users synced to profiles.');
//   } catch (e) {
//     print('⚠️ Failed to sync users: $e');
//   }
// }
