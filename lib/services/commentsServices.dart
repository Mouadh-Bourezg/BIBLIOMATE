import 'package:supabase_flutter/supabase_flutter.dart';

class CommentsService {
  final SupabaseClient client;

  CommentsService(this.client);

  // Fetch comments for a specific document
  Future<List<Map<String, dynamic>>> getCommentsForDocument(
      int documentId) async {
    try {
      final response = await client
          .from('comments')
          .select('id, user_id, content, time')
          .eq('document_id', documentId)
          .order('time', ascending: false)
          .execute();

      final data = response.data as List<dynamic>;
      return data.map((comment) => comment as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching comments: $e');
      return [];
    }
  }

  // Add a new comment
  Future<void> addComment(int documentId, String userId, String content) async {
    if (content.trim().isEmpty) return; // Prevent empty comments

    try {
      await client.from('comments').insert({
        'document_id': documentId,
        'user_id': userId,
        'content': content,
        'time': DateTime.now().toUtc().toIso8601String(), // store UTC timestamp
      }).execute();
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  // Update an existing comment by its ID
  Future<bool> updateComment(int commentId, String newContent) async {
    if (newContent.trim().isEmpty) return false;

    try {
      final response = await client
          .from('comments')
          .update({'content': newContent})
          .eq('id', commentId)
          .execute();

      return response.status == 200;
    } catch (e) {
      print('Error updating comment: $e');
      return false;
    }
  }

  // Delete a comment by its ID
  Future<bool> deleteComment(int commentId) async {
    try {
      final response =
          await client.from('comments').delete().eq('id', commentId).execute();

      return response.status == 200;
    } catch (e) {
      print('Error deleting comment: $e');
      return false;
    }
  }
}
