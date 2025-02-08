import 'package:flutter/material.dart';
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
  String? listName; // Store the input list name

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
      debugPrint('Error fetching user lists: $e');
    }
  }

  /// Shows a dialog to create a new list (UI Only)
  void _showCreateListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Create a New List',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            decoration: const InputDecoration(
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                if (listName == null || listName!.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a list name'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                try {
                  await _listService.createList(listName!.trim());
                  Navigator.of(context).pop();
                  // Refresh the lists
                  await _fetchUserLists();
                  // Show success message
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('List created successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error creating list: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Create List'),
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
      // ===================== APP BAR ======================
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
                children: [
                  // ===== Back Button =====
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.blue,
                        size: screenWidth * 0.06,
                      ),
                    ),
                  ),
                  // ===== Title in the Middle =====
                  Expanded(
                    child: Center(
                      child: Text(
                        'SAVED LISTS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.05,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.08),
                ],
              ),
            ),
          ),
        ),
      ),
      // ===================== BODY ======================
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: userLists.isEmpty
            // If NO LISTS
            ? Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ===== Placeholder Image =====
                      Image.asset(
                        'assets/no_list.jpg', // <-- Update with your image path
                        width: screenWidth * 0.6,
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // ===== No List Text =====
                      Text(
                        "Oops! There's no list created yet.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // ===== Suggestion Text =====
                      Text(
                        "Tap the + button below to create one.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            // If THERE ARE LISTS
            : ListView.separated(
                itemCount: userLists.length,
                separatorBuilder: (context, index) => SizedBox(
                  height: screenHeight * 0.01,
                ),
                itemBuilder: (context, index) {
                  final list = userLists[index];
                  return ListCard(
                    title: list.title,
                    id: list.id.toString(),
                    onDelete: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text(
                            'Confirm Delete',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            'Are you sure you want to delete "${list.title}"?',
                          ),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey,
                              ),
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () async {
                                try {
                                  await _listService
                                      .deleteList(list.id.toString());
                                  Navigator.pop(ctx);
                                  await _fetchUserLists(); // Refresh the lists
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('List deleted successfully'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Error deleting list: ${e.toString()}'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                    onEdit: () {
                      String newListName =
                          list.title; // Initialize with current name
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text(
                            'Edit List Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Enter new list name',
                              border: OutlineInputBorder(),
                            ),
                            controller: TextEditingController(text: list.title),
                            onChanged: (value) {
                              newListName = value;
                            },
                          ),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () async {
                                if (newListName.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter a list name'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                try {
                                  await _listService.editList(
                                    list.id.toString(),
                                    newListName.trim(),
                                  );
                                  Navigator.pop(ctx);
                                  await _fetchUserLists(); // Refresh the lists
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('List updated successfully'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Error updating list: ${e.toString()}'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
      ),
      // ===================== FLOATING ACTION BUTTON ======================
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateListDialog,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      // ===================== BOTTOM NAVIGATION BAR ======================
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 3, // Saved page index
        onItemSelected: (index) {
          setState(() {
            // Handle navigation if needed
          });
        },
      ),
    );
  }
}

// ===================== LIST DETAILS PAGE ======================
class ListDetailsPage extends StatelessWidget {
  final String listName;
  const ListDetailsPage({super.key, required this.listName});

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
        padding: const EdgeInsets.all(8.0),
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
