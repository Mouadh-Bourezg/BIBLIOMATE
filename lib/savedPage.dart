import 'package:flutter/material.dart';
import 'package:project/components/DocumentCard.dart';
import 'package:project/components/ListCard.dart';
import 'package:project/components/bottomBar.dart';
import 'package:project/components/documentCardInList.dart'; // Import the new component
import 'package:project/models/list.dart';
import 'package:project/services/listServices.dart'; // Import ListService
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final ListService _listService = ListService(Supabase.instance.client);
  List<ListModel> userLists = []; // Store the user's lists
  String? listName; // Store the input list name.

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

  void _showCreateListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create a New List'),
          content: TextField(
            decoration: InputDecoration(
              hintText: 'Enter list name',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                listName = value;
              });
            },
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // Text color
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog.
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Button color
                foregroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                // Perform list creation logic
                if (listName != null && listName!.trim().isNotEmpty) {
                  try {
                    await _listService.createList(listName!.trim());
                    print('List created: $listName'); // Replace with your logic.
                    listName = null;
                    Navigator.of(context).pop(); // Close the dialog.
                    await _fetchUserLists(); // Refresh the list of user lists
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error creating list: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid list name.')),
                  );
                }
              },
              child: Text('Create List'),
            ),
          ],
        );
      },
    );
  }

  //todo: void _navigateToListDetails(String listId) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ListDetailsPage(listId: listId),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          SizedBox(height: 20),
          GestureDetector(
            onTap: _showCreateListDialog,
            child: ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text('Create a List'),
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          Column(
            children: userLists.map((list) {
              return GestureDetector(
                // todo: onTap: () => _navigateToListDetails(list.title),
                child: ListCard(
                  title: list.title,
                  imageUrl: 'assets/glasses-1052010_640.jpg', // Replace with actual image URL
                ),
              );
            }).toList(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 3, // Update index for saved page
        onItemSelected: (index) {
          setState(() {
            // Handle navigation
          });
        },
      ),
    );
  }
}

class ListDetailsPage extends StatelessWidget {
  final String listName;

  const ListDetailsPage({required this.listName});

  @override
  Widget build(BuildContext context) {
    // Fetch documents for the specific list
    // This part will depend on how you store and retrieve documents for each list
    final documents = []; // Replace with actual fetching logic

    return Scaffold(
      appBar: AppBar(
        title: Text(listName),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: documents.map((document) {
          return DocumentCardInList(
            title: document['title'] ?? 'Unknown Title',
            uploaderName: document['uploaderName'] ?? 'Unknown Uploader',
            description: document['description'] ?? 'No Description',
            imageUrl: document['imageUrl'] ?? '',
            status: document['status'] ?? 'readNow',
          );
        }).toList(),
      ),
    );
  }
}