import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/save.dart';

class SaveService {
  final SupabaseClient client;

  SaveService(this.client);

  // In SaveService class
  Future<void> deleteSave(int listId, int documentId) async {
    try {
      final response = await client
          .from('saves')
          .delete()
          .eq('list_id', listId)
          .eq('document_id', documentId)
          .execute();
    } catch (e) {
      print('Error deleting save: $e');
      rethrow; // Rethrow the error for further handling
    }
  }

  // Function to fetch saves by list ID
  Future<List<Save>> fetchSavesByListId(int listId) async {
    try {
      final response = await client
          .from('saves') // Access the saves table
          .select('*')
          .eq('list_id', listId) // Filter by the provided listId
          .execute();
      // Map the response to a list of SaveModel
      final List<dynamic> data = response.data;
      return data.map((item) => Save.fromMap(item)).toList();
    } catch (e) {
      print('Error fetching saves: $e');
      rethrow; // Rethrow the error for further handling
    }
  }

  // Function to insert a save record given listId and documentId
  Future<void> insertSave(int listId, int documentId) async {
    try {
      final response = await client.from('saves').insert({
        'list_id': listId,
        'document_id': documentId, // Set the current timestamp
      }).execute();

      print(
          'Save inserted successfully for document $documentId in list $listId');
    } catch (e) {
      print('Error inserting save: $e');
      rethrow; // Rethrow the error for further handling
    }
  }
}
