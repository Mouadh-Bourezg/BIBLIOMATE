import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project/services/documentServices.dart';
import 'package:project/services/likeServices.dart';
import 'package:project/services/userServices.dart';
import '../models/document.dart';
import '../DocumentPage2.dart';
import 'Placeholder.dart'; // Add this import

class DocumentCard extends StatefulWidget {
  final int documentId;
  const DocumentCard({Key? key, required this.documentId}) : super(key: key);

  @override
  _DocumentCardState createState() => _DocumentCardState();
}

class _DocumentCardState extends State<DocumentCard> {
  bool _isLiked = false;
  Document? _document;
  String _uploaderName = '';
  final UserService _userService = UserService(Supabase.instance.client);
  final LikesService _likesService = LikesService(Supabase.instance.client);
  final DocumentService _documentService =
      DocumentService(Supabase.instance.client);

  @override
  void initState() {
    super.initState();
    _fetchDocumentDetails();
  }

  Future<void> _fetchDocumentDetails() async {
    try {
      final document =
          await _documentService.fetchDocumentById(widget.documentId);
      final userInfo =
          await _userService.getUserInformation(document.uploaderId!);
      final userId = Supabase.instance.client.auth.currentUser?.id;
      final hasLiked = userId != null
          ? await _likesService.hasUserLikedDocument(userId, document.id)
          : false;

      setState(() {
        _document = document;
        _uploaderName = "${userInfo['first_name']} ${userInfo['last_name']}";
        _isLiked = hasLiked;
      });
    } catch (e) {
      debugPrint('Error fetching document details: $e');
    }
  }

  void _toggleLike() async {
    if (_document == null) return;
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      if (_isLiked) {
        await _likesService.removeLike(userId, _document!.id);
        await _documentService.decrementLikes(_document!.id);
      } else {
        await _likesService.addLike(userId, _document!.id);
        await _documentService.incrementLikes(_document!.id);
      }
      setState(() => _isLiked = !_isLiked);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_document == null) {
      return const DocumentCardPlaceholder();
    }

    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Dynamic card width (40% of screen width)
    final cardWidth = screenWidth * 0.4;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DocumentPage2(document: _document!),
          ),
        );
      },
      child: Container(
        width: cardWidth,
        margin: EdgeInsets.symmetric(
            vertical: screenHeight * 0.015, horizontal: screenWidth * 0.03),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top image with "PDF" badge
              Stack(
                children: [
                  Image.network(
                    _document!.imageUrl,
                    height: screenHeight * 0.18,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: screenHeight * 0.18,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: screenWidth * 0.1,
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: screenHeight * 0.015,
                    right: screenWidth * 0.03,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[700],
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.015),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.007,
                      ),
                      child: Text(
                        'PDF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Content below image
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Document title
                    Text(
                      _document!.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.035,
                        color: Colors.blue,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: screenHeight * 0.007),
                    // Uploader
                    Row(
                      children: [
                        CircleAvatar(
                          radius: screenWidth * 0.025,
                          backgroundColor: Colors.blue[400],
                          child: Icon(
                            Icons.person,
                            size: screenWidth * 0.025,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: Text(
                            _uploaderName.isNotEmpty
                                ? _uploaderName
                                : 'Loading...',
                            style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    // Likes row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: _isLiked ? Colors.red : Colors.grey,
                              size: screenWidth * 0.05,
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              '${_document!.likes}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.03,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: _toggleLike,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                            child: Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              color: _isLiked ? Colors.red : Colors.grey,
                              size: screenWidth * 0.07,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
