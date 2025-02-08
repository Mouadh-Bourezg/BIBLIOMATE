import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Add this import
import 'package:project/services/saveServices.dart'; // Import SaveService
import 'package:project/services/documentServices.dart'; // Import DocumentService
import 'package:project/models/document.dart'; // Import Document model
import 'components/DocumentCard.dart'; // Import DocumentCard component
import 'package:supabase_flutter/supabase_flutter.dart';

class DocumentListPage extends StatefulWidget {
  final int listId;
  final String listName;

  // Updated constructor: if parameters are not passed, we use Get.arguments.
  DocumentListPage({
    Key? key,
    int? listId,
    String? listName,
  })  : listId = listId ??
            (Get.arguments != null ? Get.arguments["listId"] as int : 0),
        listName = listName ??
            (Get.arguments != null ? Get.arguments["listName"] as String : ''),
        super(key: key);

  @override
  _DocumentListPageState createState() => _DocumentListPageState();
}

class _DocumentListPageState extends State<DocumentListPage> {
  final SaveService _saveService = SaveService(Supabase.instance.client);
  final DocumentService _documentService =
      DocumentService(Supabase.instance.client);
  List<Document> documents = []; // Store fetched documents

  @override
  void initState() {
    super.initState();
    _fetchDocuments(); // Fetch documents when the page is initialized
  }

  Future<void> _fetchDocuments() async {
    try {
      final saves = await _saveService.fetchSavesByListId(widget.listId);
      final futures = saves.map((save) =>
          _documentService.fetchDocumentById(save.documentId).catchError((e) {
            print('Error fetching document id ${save.documentId}: $e');
            return null;
          }));
      final results = await Future.wait(futures);
      setState(() {
        documents = results.whereType<Document>().toList();
      });
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
          title: const Text('Confirm Deletion'),
          content: const Text(
              'Are you sure you want to delete this document from the list?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirm
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await _saveService.deleteSave(
            widget.listId, documentId); // Call delete method
        setState(() {
          documents.removeWhere(
              (doc) => doc.id == documentId); // Remove document from the list
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Document deleted successfully.')));
      } catch (e) {
        print('Error deleting document: $e');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error deleting document.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.10),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.blue,
                        size: screenWidth * 0.05,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'DOCUMENT LIST',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.05,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          widget.listName,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: screenWidth * 0.035,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.08),
                ],
              ),
            ),
          ),
        ),
      ),
      body: documents.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final document = documents[index];
                  return GestureDetector(
                    onLongPress: () => _deleteDocument(document.id),
                    child: DocumentCard(
                      documentId: document.id,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
