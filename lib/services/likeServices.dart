import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/like.dart'; // Import the Like model

class LikesService {
  final SupabaseClient client;

  LikesService(this.client);

  // Add a like to the database
  Future<void> addLike(String userId, int documentId) async {
    try {
      await client.from('likes').insert({
        'user_id': userId,
        'document_id': documentId,
        'time': DateTime.now().toIso8601String(),
      });
      print('Like added successfully.');
    } catch (e) {
      print('Error adding like: $e');
    }
  }

  // Remove a like from the database
  Future<void> removeLike(String userId, int documentId) async {
    try {
      await client
          .from('likes')
          .delete()
          .eq('user_id', userId)
          .eq('document_id', documentId);
      print('Like removed successfully.');
    } catch (e) {
      print('Error removing like: $e');
    }
  }

  // Check if the current user has liked a document
  Future<bool> hasUserLikedDocument(String userId, int documentId) async {
    try {
      final response = await client
          .from('likes')
          .select()
          .eq('user_id', userId)
          .eq('document_id', documentId)
          .execute();

      return response.data != null && response.data.isNotEmpty;
    } catch (e) {
      print('Error checking like: $e');
      return false;
    }
  }
}