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
        fileOptions: FileOptions(contentType: 'image/jpeg'),
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
        fileOptions: FileOptions(contentType: 'application/pdf'),
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

  // Function to fetch a document by its ID
  Future<Document> fetchDocumentById(String documentId) async {
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
      print('Error fetching document: $e');
      throw e; // Rethrow the error for further handling
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
      final document = Document(
        title: title,
        description: description,
        imageUrl: imageUrl,
        pdfContentUrl: pdfUrl,
        publishDate: DateTime.now(),
        uploaderId: uploaderId,
      );

      try {
        // Insert the document into the database
        await client.from('documents').insert(document.toMap());
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
}