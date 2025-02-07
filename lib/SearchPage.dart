import 'package:flutter/material.dart';
import 'package:project/services/documentServices.dart'; // Import DocumentService
import 'components/DocumentCard.dart';
import 'components/bottomBar.dart';
import 'styles.dart';
import 'documentPage2.dart';
import './models/document.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _showResults = false;
  List<Document> _searchResults = []; // Change to List<Document>
  int _currentIndex = 1;

  final DocumentService _documentService = DocumentService(Supabase.instance.client); // Initialize DocumentService

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _showResults = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _showResults = true; // Show results when there is a query
    });

    try {
      // Fetch documents based on the search query
      _searchResults = await _documentService.fetchDocumentsBySearch(query);
      setState(() {}); // Update the UI with the search results
    } catch (e) {
      print('Error fetching documents: $e');
      setState(() {
        _searchResults = []; // Clear results on error
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _showResults = false;
      _searchResults = []; // Clear search results
    });
  }

  void _navigateToDocumentPage(Document document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentPage2(document: document),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          // Search Bar
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Title, author, genre, topic",
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(width: 2, color: Colors.orange),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(width: 2, color: Colors.orange),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.orange),
                fillColor: Colors.white,
                suffixIcon: _showResults
                    ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: _clearSearch,
                )
                    : null,
              ),
              cursorColor: Colors.orange,
              cursorWidth: 0.7,
            ),
          ),
          // Search Results
          Expanded(
            child: Container(
              color: Colors.white,
              child: _showResults
                  ? ListView(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                children: _searchResults.map((doc) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: GestureDetector(
                      onTap: () => _navigateToDocumentPage(doc), // Navigate to document page
                      child: DocumentCard(
                        documentId: doc.id,
                      ),
                    ),
                  );
                }).toList(),
              )
                  : Center(child: Text('No results found.')),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}