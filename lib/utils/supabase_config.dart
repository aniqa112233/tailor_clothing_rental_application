
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // 🔗 Your Supabase project credentials
  static const String supabaseUrl = 'https://tmstholzsyegwhbjhryn.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRtc3Rob2x6c3llZ3doYmpocnluIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE1NjMwMjQsImV4cCI6MjA3NzEzOTAyNH0.AuW2S9UVwNPEK1dxAblY-kjZr4hzszAUczUS2ER1A_4';

  // 🧩 Initialize Supabase at app startup
  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: true, // shows Supabase logs in console (optional)
      );
      print('✅ Supabase initialized successfully');
    } catch (e) {
      print('❌ Supabase initialization failed: $e');
      rethrow;
    }
  }

  // 🔁 Client getter for easy access
  static SupabaseClient get client => Supabase.instance.client;
}
