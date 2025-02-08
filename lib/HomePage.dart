import 'package:flutter/material.dart';
import 'package:project/components/DocumentCard.dart';
import 'package:project/components/bottomBar.dart';
import 'package:project/documentPage2.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project/services/documentServices.dart';
import 'package:project/models/document.dart';
import 'package:project/components/Placeholder.dart';

class HomePage extends StatefulWidget {
  static const pageRoute = '/HomePage';
  final bool showBottomBar;
  const HomePage({Key? key, this.showBottomBar = true}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

// 1. Add SingleTickerProviderStateMixin for animation
class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final DocumentService _documentService =
      DocumentService(Supabase.instance.client);
  List<Document> documents = [];
  bool _isLoading = true;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    // 2. Initialize and start the rotation animation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(); // repeats indefinitely
    _fetchDocuments();
  }

  @override
  void dispose() {
    // Always dispose of the animation controller
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _fetchDocuments() async {
    try {
      List<Document> fetchedDocuments =
          await _documentService.fetchAllDocuments();
      setState(() {
        documents = fetchedDocuments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
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
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      // Ensure content is not hidden behind system UI elements like the camera notch
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Fixed AppBar with title BIBLIOMATE
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              scrolledUnderElevation: 0,
              centerTitle: true,
              title: Text(
                'BIBLIOMATE',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // "Explorer" heading with rotating icon
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04, // 4% of screen width
                  vertical: screenHeight * 0.02, // 2% of screen height
                ),
                child: Row(
                  children: [
                    // 3. Wrap the icon in a RotationTransition
                    RotationTransition(
                      turns: _rotationController, // controls rotation
                      child: Icon(
                        Icons.explore,
                        color: Colors.blue,
                        size: screenWidth * 0.07, // 7% of screen width
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02), // 2% of screen width
                    Text(
                      'Explorer',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045, // 4.5% of screen width
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // The list of documents or placeholders
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (_isLoading) {
                    // Show placeholders
                    if (index < 6) {
                      return const DocumentCardPlaceholder();
                    }
                    return null; // no more items
                  }
                  if (index < documents.length) {
                    return _buildDocumentRow(documents[index]);
                  }
                  return null;
                },
                childCount: _isLoading ? 6 : documents.length,
              ),
            ),
          ],
        ),
      ),
      // Bottom Nav Bar
      bottomNavigationBar: widget.showBottomBar
          ? CustomBottomNavigationBar(
              currentIndex: _currentIndex,
              onItemSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            )
          : null,
    );
  }

  Widget _buildDocumentRow(Document document) {
    return Padding(
      padding: EdgeInsets.only(
          right:
              MediaQuery.of(context).size.width * 0.02), // 2% of screen width
      child: GestureDetector(
        onTap: () => _navigateToDocumentPage(document),
        child: DocumentCard(documentId: document.id),
      ),
    );
  }
}
