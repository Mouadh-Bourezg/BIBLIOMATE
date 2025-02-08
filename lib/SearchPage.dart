import 'package:flutter/material.dart';
import 'package:project/services/documentServices.dart';
import 'package:project/components/bottomBar.dart';
import 'package:project/documentPage2.dart';
import 'package:project/models/document.dart';
import 'package:project/components/DocumentCard.dart';
import 'package:project/components/Placeholder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _showResults = false;
  List<Document> _searchResults = [];
  int _currentIndex = 1;
  final DocumentService _documentService =
      DocumentService(Supabase.instance.client);
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Optional: animate icons if desired
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 0),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Handle changes in the search query
  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _showResults = false;
        _searchResults.clear();
      });
      return;
    }
    setState(() {
      _showResults = true;
    });
    try {
      _searchResults = await _documentService.fetchDocumentsBySearch(query);
      setState(() {});
    } catch (e) {
      debugPrint('Error fetching documents: $e');
      setState(() {
        _searchResults.clear();
      });
    }
  }

  /// Clear search field and results
  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _showResults = false;
      _searchResults.clear();
    });
  }

  /// Navigate to a document page
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
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Blue app bar with "SEARCH PAGE" and integrated search
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(screenHeight * 0.18), // 18% of screen height
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: Text(
            'SEARCH PAGE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.05, // 5% of screen width
            ),
          ),
          flexibleSpace: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.08, // 8% of screen height
                left: screenWidth * 0.04, // 4% of screen width
                right: screenWidth * 0.04, // 4% of screen width
              ),
              child: Container(
                height: screenHeight * 0.06, // 6% of screen height
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                      screenWidth * 0.05), // 5% of screen width
                ),
                // The search TextField inside the app bar
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  cursorColor: Colors.blue,
                  cursorWidth: 0.7,
                  decoration: InputDecoration(
                    hintText: "Search something...",
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.035), // 3.5% of screen width
                    prefixIcon: Icon(Icons.search,
                        color: Colors.blue,
                        size: screenWidth * 0.05), // 5% of screen width
                    contentPadding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01), // 1% of screen height
                    border: InputBorder.none,
                    suffixIcon: _showResults
                        ? IconButton(
                            icon: Icon(Icons.clear,
                                size: screenWidth * 0.05), // 5% of screen width
                            color: Colors.blue,
                            onPressed: _clearSearch,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // If we have results, show "X RESULTS"
          if (_showResults && _searchResults.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, // 4% of screen width
                vertical: screenHeight * 0.01, // 1% of screen height
              ),
              child: Text(
                '${_searchResults.length} RESULTS',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.035, // 3.5% of screen width
                ),
              ),
            ),
          // The main list of DocumentCards or placeholders
          Expanded(
            child: _showResults
                ? _searchResults.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                screenWidth * 0.04), // 4% of screen width
                        itemCount: _searchResults.length +
                            1, // +1 for "END OF RESULTS"
                        itemBuilder: (context, index) {
                          if (index < _searchResults.length) {
                            final doc = _searchResults[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: screenHeight *
                                      0.01), // 1% of screen height
                              child: GestureDetector(
                                onTap: () => _navigateToDocumentPage(doc),
                                child: DocumentCard(documentId: doc.id),
                              ),
                            );
                          } else {
                            // Show "END OF RESULTS" after the last card
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight *
                                        0.02), // 2% of screen height
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: screenWidth *
                                          0.12, // 12% of screen width
                                      height: 1,
                                      color: Colors.red,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: screenWidth *
                                              0.02), // 2% of screen width
                                    ),
                                    Text(
                                      'END OF RESULTS',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: screenWidth *
                                            0.03, // 3% of screen width
                                      ),
                                    ),
                                    Container(
                                      width: screenWidth *
                                          0.12, // 12% of screen width
                                      height: 1,
                                      color: Colors.red,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: screenWidth *
                                              0.02), // 2% of screen width
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      )
                    : Center(
                        child: Text(
                          'No results found.',
                          style: TextStyle(
                              fontSize:
                                  screenWidth * 0.04), // 4% of screen width
                        ),
                      )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/EnterKey.jpg', // Make sure to add this image to your assets
                          width: screenWidth * 0.4, // 40% of screen width
                          height: screenWidth * 0.4, // 40% of screen width
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                            height: screenHeight * 0.02), // 2% of screen height
                        Text(
                          'Please search for something',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04, // 4% of screen width
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      // Bottom Nav Bar
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
