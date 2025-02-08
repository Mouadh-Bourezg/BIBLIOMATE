import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/list.dart'; // Import your List model

class ListService {
  final SupabaseClient client;

  ListService(this.client);

  // Function to create a new list for the current user
  Future<void> createList(String title) async {
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('User is not authenticated');
    }

    try {
      await client.from('lists').insert({
        'title': title,
        'user_id': userId, // Associate the list with the current user
        'created_at': DateTime.now().toIso8601String(), // Set created_at
        'updated_at': DateTime.now().toIso8601String(), // Set updated_at
      }).execute();
      print('List created successfully.');
    } catch (e) {
      print('Error creating list: $e');
      throw e; // Rethrow the error for further handling
    }
  }

  // Function to fetch all lists for the current user
  Future<List<ListModel>> fetchUserLists() async {
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('User is not authenticated');
    }

    try {
      final response = await client
          .from('lists')
          .select()
          .eq('user_id', userId) // Filter lists by the current user
          .execute();

      // Map the response to a list of ListModel objects
      final List<dynamic> data = response.data;
      return data.map((doc) => ListModel.fromMap(doc)).toList();
    } catch (e) {
      print('Error fetching lists: $e');
      throw e; // Rethrow the error for further handling
    }
  }

  // Add this new method inside ListService class
  Future<void> editList(String listId, String newTitle) async {
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('User is not authenticated');
    }

    try {
      await client.from('lists').update({
        'title': newTitle,
        'updated_at': DateTime.now().toIso8601String(),
      }).match({
        'id': listId,
        'user_id': userId, // Ensure user owns the list
      }).execute();
    } catch (e) {
      print('Error updating list: $e');
      throw e;
    }
  }

  Future<void> deleteList(String listId) async {
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('User is not authenticated');
    }

    try {
      await client.from('lists').delete().match({
        'id': listId,
        'user_id': userId, // Ensure user owns the list
      }).execute();
    } catch (e) {
      print('Error deleting list: $e');
      throw e;
    }
  }
}