import 'package:flutter/material.dart';
import 'package:project/services/documentServices.dart'; // Import DocumentService
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project/components/documentCard.dart'; // Import DocumentCard
import 'models/document.dart';

class MyDocumentsPage extends StatefulWidget {
  @override
  _MyDocumentsPageState createState() => _MyDocumentsPageState();
}

class _MyDocumentsPageState extends State<MyDocumentsPage> {
  final DocumentService _documentService = DocumentService(Supabase.instance.client);
  List<Document> _documents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDocuments(); // Fetch documents when the page is initialized
  }

  Future<void> _fetchDocuments() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id; // Get current user ID
      if (userId != null) {
        _documents = await _documentService.fetchDocumentsByUserId(userId);
      }
    } catch (e) {
      print('Error fetching documents: $e');
    } finally {
      setState(() {
        _isLoading = false; // Update loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Documents'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching
          : _documents.isEmpty
          ? Center(child: Text('No documents found.'))
          : GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two cards per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7, // Adjust the aspect ratio as needed
        ),
        itemCount: _documents.length,
        itemBuilder: (context, index) {
          final document = _documents[index];
          return DocumentCard(
            documentId: document.id,
          );
        },
      ),
    );
  }
}