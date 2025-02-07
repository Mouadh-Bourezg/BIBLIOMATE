import 'package:flutter/material.dart';
import 'package:project/services/saveServices.dart'; // Import SaveService
import 'package:project/services/documentServices.dart'; // Import DocumentService
import 'package:project/models/document.dart'; // Import Document model
import 'components/DocumentCard.dart'; // Import DocumentCard component
import 'package:supabase_flutter/supabase_flutter.dart';

class DocumentListPage extends StatefulWidget {
  final int listId; // The ID of the list to fetch documents from

  DocumentListPage({required this.listId});

  @override
  _DocumentListPageState createState() => _DocumentListPageState();
}

class _DocumentListPageState extends State<DocumentListPage> {
  final SaveService _saveService = SaveService(Supabase.instance.client);
  final DocumentService _documentService = DocumentService(Supabase.instance.client);
  List<Document> documents = []; // Store fetched documents

  @override
  void initState() {
    super.initState();
    _fetchDocuments(); // Fetch documents when the page is initialized
  }

  Future<void> _fetchDocuments() async {
    try {
      // Fetch saves for the given listId
      final saves = await _saveService.fetchSavesByListId(widget.listId);
      // Fetch documents based on the document IDs from saves
      documents = await Future.wait(saves.map((save) => _documentService.fetchDocumentById(save.documentId)));
      setState(() {});
    } catch (e) {
      print('Error fetching documents: $e');
    }
  }

  Future<void> _deleteDocument(int documentId) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this document from the list?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirm
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await _saveService.deleteSave(widget.listId, documentId); // Call delete method
        setState(() {
          documents.removeWhere((doc) => doc.id == documentId); // Remove document from the list
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Document deleted successfully.')));
      } catch (e) {
        print('Error deleting document: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting document.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documents in List'),
      ),
      body: documents.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Adjust the number of columns as needed
          childAspectRatio: 0.7, // Adjust aspect ratio for cards
        ),
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final document = documents[index];
          return GestureDetector(
            onLongPress: () => _deleteDocument(document.id), // Long press to delete
            child: DocumentCard(
             documentId: document.id,
            ),
          );
        },
      ),
    );
  }
}