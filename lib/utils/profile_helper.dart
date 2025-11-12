
import 'package:supabase_flutter/supabase_flutter.dart';
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
