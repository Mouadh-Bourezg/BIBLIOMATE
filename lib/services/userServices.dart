import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient client;

  UserService(this.client);

  // Function to get user information by user ID
  Future<Map<String, String>> getUserInformation(String userId) async {
    try {
      // Query the public view `user_profiles`
      final response = await client
          .from('users')
          .select('*')
          .eq('id', userId) // Filter by user ID
          .single(); // Fetch a single record

      // Extract user data
      final userData = response as Map<String, dynamic>;

      // Return user information
      return {
        'email': userData['email'] ?? 'Unknown',
        'first_name': userData['first_name'] ?? 'Nan',
        'last_name': userData['last_name'] ?? 'Nan',
      };
    } catch (e) {
      print('Error fetching user information: $e');
      rethrow; // Rethrow the error for further handling
    }
  }
}