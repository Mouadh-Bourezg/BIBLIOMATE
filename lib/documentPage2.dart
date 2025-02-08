import 'package:flutter/material.dart';
import 'package:project/models/list.dart';
import 'package:project/services/documentServices.dart'; // Import DocumentService
import 'package:project/services/listServices.dart'; // Import ListService
import 'package:project/services/saveServices.dart'; // Import SaveService
import 'package:project/models/document.dart'; // Import Document model
import 'components/DocumentHeader.dart';
import 'components/DocumentActions.dart';
import 'components/DocumentDescription.dart';
import 'components/bottomBar.dart';
import 'components/CommentsSection.dart'; // Import CommentsSection
import 'package:supabase_flutter/supabase_flutter.dart';

class DocumentPage2 extends StatefulWidget {
  static const pageRoute = '/DocumentPage';
  final Document document; // Accept the document instance
  const DocumentPage2({super.key, required this.document});

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
      userLists =
          await _listService.fetchUserLists(); // Fetch lists from the service
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
          title: Text(
            'Add to List',
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),
          ),
          content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: userLists.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    userLists[index].title,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                  onTap: () async {
                    // Get the current user ID
                    final userId =
                        Supabase.instance.client.auth.currentUser?.id;
                    if (userId != null) {
                      // Create a save instance
                      await _saveService.insertSave(
                          userLists[index].id, widget.document.id);
                      Navigator.of(context).pop(); // Close the dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Document added to ${userLists[index].title}',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035),
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'User not authenticated',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035),
                          ),
                        ),
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
              child: Text(
                'Cancel',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(screenHeight * 0.10), // 10% of screen height
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false, // Disable default back button
          flexibleSpace: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04), // 4% of screen width
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Vertically center align
                children: [
                  // Back Arrow Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(
                          screenWidth * 0.02), // 2% of screen width
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.blue,
                        size: screenWidth * 0.05, // 5% of screen width
                      ),
                    ),
                  ),
                  // Title
                  Expanded(
                    child: Center(
                      child: Text(
                        'DOCUMENT DETAILS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.05, // 5% of screen width
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // Empty space to balance the layout
                  SizedBox(width: screenWidth * 0.08), // 8% of screen width
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(screenWidth * 0.04), // 4% of screen width
        children: [
          DocumentHeader(document: widget.document),
          SizedBox(height: screenHeight * 0.02), // 2% of screen height
          DocumentActions(
            onAddToList: () => _showAddToListDialog(context),
            documentId: widget.document.id,
          ),
          Divider(
            height: screenHeight * 0.04, // 4% of screen height
            thickness: screenHeight * 0.002, // 0.2% of screen height
            color: Colors.black26,
          ),
          DocumentDescription(description: widget.document.description),
          SizedBox(height: screenHeight * 0.02), // 2% of screen height
          CommentsSection(
            documentId: widget.document.id, // Added CommentsSection
          ),
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
