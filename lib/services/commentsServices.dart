import 'package:supabase_flutter/supabase_flutter.dart';

class CommentsService {
  final SupabaseClient client;

  CommentsService(this.client);

  // Fetch comments for a specific document
  Future<List<Map<String, dynamic>>> getCommentsForDocument(int documentId) async {
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
        'time': DateTime.now().toUtc().toIso8601String(), // Ensure timestamp is stored in UTC
      }).execute();
    } catch (e) {
      print('Error adding comment: $e');
    }
  }
}
