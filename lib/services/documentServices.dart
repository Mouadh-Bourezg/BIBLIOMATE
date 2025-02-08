import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/document.dart';

class DocumentService {
  final SupabaseClient client;

  DocumentService(this.client);

  // Function to upload an image and get its URL
  Future<String?> uploadImage(File imageFile) async {
    try {
      await client.storage.from('images').upload(
        'documents/${imageFile.uri.pathSegments.last}',
        imageFile,
        fileOptions: const FileOptions(contentType: 'image/jpeg'),
      );

      // Get the public URL of the uploaded image
      final imageUrl = client.storage
          .from('images')
          .getPublicUrl('documents/${imageFile.uri.pathSegments.last}');
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Function to upload a PDF file and get its URL
  Future<String?> uploadPdf(File pdfFile) async {
    try {
      await client.storage.from('pdfs').upload(
        'documents/${pdfFile.uri.pathSegments.last}',
        pdfFile,
        fileOptions: const FileOptions(contentType: 'application/pdf'),
      );

      // Get the public URL of the uploaded PDF
      final pdfUrl = client.storage
          .from('pdfs')
          .getPublicUrl('documents/${pdfFile.uri.pathSegments.last}');
      return pdfUrl;
    } catch (e) {
      print('Error uploading PDF: $e');
      return null;
    }
  }

  // In DocumentService class
  Future<List<Document>> fetchDocumentsBySearch(String query) async {
    try {
      final response = await client
          .from('documents') // Access the documents table
          .select('*') // Select all fields
          .or('title.ilike.%$query%') // Search by title
          .execute();

      // Map the response to a list of Document
      final List<dynamic> data = response.data;
      return data.map((doc) => Document.fromMap(doc)).toList();
    } catch (e) {
      print('Error fetching documents: $e');
      return []; // Return an empty list on error
    }
  }

  Future<List<Document>> fetchDocumentsByUserId(String userId) async {
    try {
      final response = await client
          .from('documents') // Access the documents table
          .select('*') // Select all fields
          .eq('uploader_id', userId) // Filter by uploader_id
          .execute();

      // Map the response to a list of Document
      final List<dynamic> data = response.data;
      return data.map((doc) => Document.fromMap(doc)).toList();
    } catch (e) {
      print('Error fetching documents by user ID: $e');
      return []; // Return an empty list on error
    }
  }

  // Function to fetch a document by its ID
  Future<Document> fetchDocumentById(int documentId) async {
    try {
      final response = await client
          .from('documents')
          .select()
          .eq('id', documentId) // Assuming 'id' is the primary key
          .single() // Fetch a single document
          .execute();

      // Map the response to a Document object
      return Document.fromMap(response.data);
    } catch (e) {
      print('Error fetching document by id: $e');
      rethrow; // Rethrow the error for further handling
    }
  }

  // Function to insert a document into the database
  Future<void> insertDocument({
    required String title,
    required String description,
    required File imageFile,
    required File pdfFile,
    required String? uploaderId,
  }) async {
    // Upload the image and PDF, and get their URLs
    final imageUrl = await uploadImage(imageFile);
    final pdfUrl = await uploadPdf(pdfFile);

    if (imageUrl != null && pdfUrl != null) {
      try {
        // Insert the document into the database
        await client.from('documents').insert({

          'title': title,
          'description': description,
          'image_url': imageUrl,
          'pdf_content_url': pdfUrl,
          'publish_date': DateTime.now().toIso8601String(),
          'uploader_id': uploaderId!,
        });
        print('Document inserted successfully.');
      } catch (e) {
        print('Error inserting document: $e');
      }
    }
  }

  // Function to fetch all documents
  Future<List<Document>> fetchAllDocuments() async {
    try {
      final response = await client.from('documents').select();

      if (response is List<dynamic>) {
        return response.map((doc) => Document.fromMap(doc)).toList();
      } else {
        print('Unexpected response type: ${response.runtimeType}');
        return [];
      }
    } catch (e) {
      print('Error fetching documents: $e');
      return [];
    }
  }
  Future<String?> getPDFUrl(int documentId) async {
    final response = await client
        .from('documents')
        .select('pdf_content_url')
        .eq('id', documentId)
        .single();

    if (response != null && response['pdf_content_url'] != null) {
      return response['pdf_content_url'];
    }
    return null;
  }


  Future<void> incrementLikes(int documentId) async {
    try {
      final response = await client
          .from('documents')
          .select('likes')
          .eq('id', documentId)
          .single(); // Fetch a single document

      int currentLikes = response['likes'] ?? 0; // Handle null case

      await client.from('documents').update({
        'likes': currentLikes + 1
      }).eq('id', documentId);

      print('Likes incremented successfully.');
    } catch (e) {
      print('Error incrementing likes: $e');
    }
  }


  // Decrement the likes count for a document
  Future<void> decrementLikes(int documentId) async {
    try {
      final response = await client
          .from('documents')
          .select('likes')
          .eq('id', documentId)
          .single(); // Fetch a single document

      int currentLikes = response['likes'] ?? 0; // Handle null case

      await client.from('documents').update({
        'likes': currentLikes - 1
      }).eq('id', documentId);

      print('Likes incremented successfully.');
    } catch (e) {
      print('Error incrementing likes: $e');
    }
  }
}
