import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project/services/documentServices.dart';
import 'package:project/services/likeServices.dart';
import 'package:project/services/userServices.dart';
import '../models/document.dart';
import '../DocumentPage2.dart';

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
  final DocumentService _documentService = DocumentService(Supabase.instance.client);

  @override
  void initState() {
    super.initState();
    _fetchDocumentDetails();
  }

  Future<void> _fetchDocumentDetails() async {
    try {
      final document = await _documentService.fetchDocumentById(widget.documentId);
      final userInfo = await _userService.getUserInformation(document.uploaderId!);
      final userId = Supabase.instance.client.auth.currentUser?.id;
      final hasLiked = userId != null ? await _likesService.hasUserLikedDocument(userId, document.id) : false;

      setState(() {
        _document = document;
        _uploaderName = "${userInfo['first_name']} ${userInfo['last_name']}";
        _isLiked = hasLiked;
      });
    } catch (e) {
      print('Error fetching document details: $e');
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
      setState(() {
        _isLiked = !_isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_document == null) {
      return Center(child: CircularProgressIndicator());
    }

    final cardWidth = MediaQuery.of(context).size.width * 0.4;
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
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        width: cardWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Image.network(
                    _document!.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 50,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(
                      'PDF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _document!.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'UPLOADED BY',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.orange,
                        child: Icon(
                          Icons.person,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _uploaderName.isNotEmpty ? _uploaderName : 'Loading...',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Likes: ${_document!.likes}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleLike,
                        child: Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked ? Colors.red : Colors.grey,
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
    );
  }
}
