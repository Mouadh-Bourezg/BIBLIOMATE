import 'package:flutter/material.dart';
import 'package:project/models/list.dart';
import 'package:project/services/documentServices.dart'; // Import DocumentService
import 'package:project/services/listServices.dart'; // Import ListService
import 'package:project/services/saveServices.dart'; // Import SaveService
import 'package:project/models/document.dart'; // Import Document model
import 'components/DocumentHeader.dart';
import 'components/DocumentActions.dart';
import 'components/DocumentDescription.dart';
import 'components/CustomAppBar.dart';
import 'components/bottomBar.dart';
import 'components/CommentsSection.dart'; // Import CommentsSection
import 'package:supabase_flutter/supabase_flutter.dart';

class DocumentPage2 extends StatefulWidget {
  static final pageRoute = '/DocumentPage';
  final Document document; // Accept the document instance

  DocumentPage2({required this.document});

  @override
  _DocumentPage2State createState() => _DocumentPage2State();
}

class _DocumentPage2State extends State<DocumentPage2> {
  final ListService _listService = ListService(Supabase.instance.client);
  final SaveService _saveService = SaveService(Supabase.instance.client);
  List<ListModel> userLists = []; // Store user lists

  @override
  void initState() {
    super.initState();
    _fetchUserLists(); // Fetch user lists when the page is initialized
  }

  Future<void> _fetchUserLists() async {
    try {
      userLists = await _listService.fetchUserLists(); // Fetch lists from the service
      setState(() {});
    } catch (e) {
      print('Error fetching user lists: $e');
    }
  }

  void _showAddToListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add to List'),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: userLists.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(userLists[index].title),
                  onTap: () async {
                    // Get the current user ID
                    final userId = Supabase.instance.client.auth.currentUser?.id;
                    if (userId != null) {
                      // Create a save instance
                      await _saveService.insertSave(userLists[index].id, widget.document.id);
                      Navigator.of(context).pop(); // Close the dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Document added to ${userLists[index].title}')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User not authenticated')),
                      );
                    }
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          DocumentHeader(document: widget.document),
          SizedBox(height: 16),
          DocumentActions(
            onAddToList: () => _showAddToListDialog(context),
            documentId: widget.document.id,
          ),
          Divider(height: 32, thickness: 1, color: Colors.black26),
          DocumentDescription(description: widget.document.description),
          SizedBox(height: 16),
          CommentsSection(documentId: widget.document.id), // Added CommentsSection
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
