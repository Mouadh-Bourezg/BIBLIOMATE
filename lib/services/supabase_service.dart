import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl = "https://glqmcbtatdcqntsdbbnz.supabase.co";
  static const String supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdscW1jYnRhdGRjcW50c2RiYm56Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYzMzQ3NjIsImV4cCI6MjA1MTkxMDc2Mn0.-rgbe9tz3FioPEGMsF33gk1Z8Bs7VU_djzjXpsdtFHw";

  // Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
    print('supabased is ready !');
  }

  // Get the Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;


}
