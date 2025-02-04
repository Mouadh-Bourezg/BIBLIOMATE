import 'package:flutter/material.dart';
import 'package:project/components/DocumentCard.dart';
import 'package:project/components/bottomBar.dart';
import 'package:project/documentPage2.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project/services/documentServices.dart'; // Import DocumentService
import 'package:project/models/document.dart'; // Import Document model

class HomePage extends StatefulWidget {
  static final pageRoute = '/HomePage';
  final bool showBottomBar;

  HomePage({this.showBottomBar = true});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final DocumentService _documentService = DocumentService(Supabase.instance.client);
  List<Document> documents = []; // List to hold fetched documents

  @override
  void initState() {
    super.initState();
    _fetchDocuments(); // Fetch documents when the page is initialized
  }

  Future<void> _fetchDocuments() async {
    List<Document> fetchedDocuments = await _documentService.fetchAllDocuments();
    setState(() {
      documents = fetchedDocuments; // Update the state with fetched documents
    });
  }

  // void _navigateToDocumentPage(Document document) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => DocumentPage2(document: document, currentIndex: _currentIndex),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          // Optionally handle scroll events here
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 130.0,
              floating: false,
              pinned: true,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate the collapse progress
                  double collapseProgress = (1.0 -
                      (constraints.maxHeight - kToolbarHeight) /
                          (130.0 - kToolbarHeight))
                      .clamp(0.0, 1.0);

                  return Stack(
                    children: [
                      // Logo (fades out as scrolling progresses)
                      Opacity(
                        opacity: (1.0 - collapseProgress).clamp(0.0, 1.0),
                        child: Center(
                          child: Image.asset(
                            '../assets/logo.png',
                            width: 120,
                            height: 110,
                          ),
                        ),
                      ),
                      // App name (fades in as scrolling progresses)
                      Opacity(
                        opacity: collapseProgress,
                        child: Center(
                          child: Text(
                            'BiblioMate',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Main content
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  if (index < documents.length) {
                    return _buildDocumentRow(documents[index]);
                  } else {
                    return SizedBox(height: 16); // Placeholder for spacing
                  }
                },
                childCount: documents.length,
              ),
            ),
          ],
        ),
      ),
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
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        //onTap: () => _navigateToDocumentPage(document),
        child: DocumentCard(
          title: document.title,
          uploaderName: document.uploaderId!, // Assuming you have a way to get the uploader's name
          imageUrl: document.imageUrl,
          isPdf: true,
        ),
      ),
    );
  }
}