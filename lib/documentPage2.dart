import 'package:flutter/material.dart';
import 'package:project/services/documentServices.dart'; // Import DocumentService
import 'package:project/models/document.dart'; // Import Document model
import 'components/DocumentHeader.dart';
import 'components/DocumentActions.dart';
import 'components/DocumentDetails.dart';
import 'components/DocumentTags.dart';
import 'components/DocumentDescription.dart';
import 'components/CustomAppBar.dart';
import 'styles.dart';
import 'components/bottomBar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DocumentPage2 extends StatefulWidget {
  static final pageRoute = '/DocumentPage';
  final String documentId; // Accept only the document ID

  DocumentPage2({required this.documentId});

  @override
  _DocumentPage2State createState() => _DocumentPage2State();
}

class _DocumentPage2State extends State<DocumentPage2> {
  late DocumentService _documentService;
  Document? document; // Store the fetched document

  @override
  void initState() {
    super.initState();
    _documentService = DocumentService(Supabase.instance.client);
    _fetchDocument(); // Fetch the document when the page is initialized
  }

  Future<void> _fetchDocument() async {
    try {
      document = await _documentService.fetchDocumentById(widget.documentId);
      setState(() {}); // Update the UI after fetching the document
    } catch (e) {
      print('Error fetching document: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching document: $e')),
      );
    }
  }

  void _showAddToListDialog(BuildContext context) {
    // Implement the logic to fetch lists from the database
    // and show the dialog for adding the document to a list
  }

  @override
  Widget build(BuildContext context) {
    if (document == null) {
      return Center(child: CircularProgressIndicator()); // Show loading indicator while fetching
    }

    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          DocumentHeader(document: document!.toMap()),
          SizedBox(height: 16),
          DocumentActions(
            onAddToList: () => _showAddToListDialog(context),
          ),
          Divider(height: 32, thickness: 1, color: Colors.black26),
          DocumentDetails(),
          SizedBox(height: 8),
          DocumentTags(),
          Divider(height: 32, thickness: 1, color: Colors.black26),
          DocumentDescription(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0, // Update as needed
        onItemSelected: (index) {
          Navigator.pop(context);
        },
      ),
    );
  }
}