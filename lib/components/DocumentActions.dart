import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project/services/likeServices.dart';
import 'package:project/services/documentServices.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class DocumentActions extends StatefulWidget {
  final VoidCallback onAddToList;
  final int documentId;

  DocumentActions({required this.onAddToList, required this.documentId});

  @override
  _DocumentActionsState createState() => _DocumentActionsState();
}

class _DocumentActionsState extends State<DocumentActions> {
  bool _isLiked = false;
  int _likesCount = 0;
  bool _isDownloading = false;

  final LikesService _likesService = LikesService(Supabase.instance.client);
  final DocumentService _documentService = DocumentService(Supabase.instance.client);

  @override
  void initState() {
    super.initState();
    _fetchLikeStatus();
  }

  Future<void> _fetchLikeStatus() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        final hasLiked = await _likesService.hasUserLikedDocument(userId, widget.documentId);
        final document = await _documentService.fetchDocumentById(widget.documentId);
        setState(() {
          _isLiked = hasLiked;
          _likesCount = document.likes;
        });
      }
    } catch (e) {
      print('Error fetching like status: $e');
    }
  }

  void _toggleLike() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      if (_isLiked) {
        await _likesService.removeLike(userId, widget.documentId);
        await _documentService.decrementLikes(widget.documentId);
        setState(() {
          _isLiked = false;
          _likesCount--;
        });
      } else {
        await _likesService.addLike(userId, widget.documentId);
        await _documentService.incrementLikes(widget.documentId);
        setState(() {
          _isLiked = true;
          _likesCount++;
        });
      }
    }
  }

  Future<void> _downloadPDF() async {
    setState(() => _isDownloading = true);

    try {
      final pdfUrl = await _documentService.getPDFUrl(widget.documentId);
      if (pdfUrl == null) {
        print('No PDF found for this document');
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/document_${widget.documentId}.pdf';

      await Dio().download(pdfUrl, filePath);

      setState(() => _isDownloading = false);

      print('Downloaded to: $filePath');

      // Open the downloaded file
      await OpenFilex.open(filePath);
    } catch (e) {
      print('Error downloading PDF: $e');
      setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: _isDownloading
              ? CircularProgressIndicator() // Show loading if downloading
              : Icon(Icons.download),
          onPressed: _downloadPDF,
        ),
        IconButton(
          icon: Icon(Icons.playlist_add),
          onPressed: widget.onAddToList,
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                color: _isLiked ? Colors.red : Colors.grey,
              ),
              onPressed: _toggleLike,
            ),
            Text('$_likesCount'),
          ],
        ),
      ],
    );
  }
}
