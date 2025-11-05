import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

/// Ensures a user has a profile record in 'profiles' table.
/// If not found, creates one automatically.
Future<void> ensureUserProfileExists([String? userId, String? providedEmail]) async {
  final supabase = Supabase.instance.client;
  final id = userId ?? supabase.auth.currentUser?.id ?? '';
  if (id.isEmpty) return;

  // 🔍 Check if profile already exists
  final existing = await supabase.from('profiles').select().eq('id', id).maybeSingle();
  if (existing != null) {
    debugPrint('ℹ️ Profile already exists for $id');
    return;
  }

  // 🧩 Create new profile safely
  await supabase.from('profiles').insert({
    'id': id,
    'email': providedEmail ?? 'auto_${DateTime.now().millisecondsSinceEpoch}@example.com',
    'role': 'customer',
    'created_at': DateTime.now().toIso8601String(),
  });

  debugPrint('✅ Auto-created profile for $id');
}
