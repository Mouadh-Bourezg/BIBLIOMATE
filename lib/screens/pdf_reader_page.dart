import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../services/pdf_storage_service.dart';
import '../models/pdf_bookmark.dart';
import '../models/pdf_highlight.dart';

class PdfReaderPage extends StatefulWidget {
  final String pdfPath;

  const PdfReaderPage({required this.pdfPath, Key? key}) : super(key: key);

  @override
  _PdfReaderPageState createState() => _PdfReaderPageState();
}

class _PdfReaderPageState extends State<PdfReaderPage> {
  PDFViewController? _pdfViewController;
  final PdfStorageService _storageService = PdfStorageService();
  int _totalPages = 0;
  int _currentPage = 0;
  bool _isDarkMode = false;
  List<PdfBookmark> _bookmarks = [];
  List<PdfHighlight> _highlights = [];
  bool _isLoading = true;
  String? _localPdfPath;

  @override
  void initState() {
    super.initState();
    _initializePdf();
  }

  Future<void> _initializePdf() async {
    await _loadPreferences();
    await _loadSavedData();
    setState(() => _localPdfPath = widget.pdfPath);
    setState(() => _isLoading = false);
  }

  Future<void> _loadPreferences() async {
    // Add your preference loading logic here
  }

  Future<void> _loadSavedData() async {
    try {
      final lastPage = await _storageService.loadLastPage(widget.pdfPath);
      final bookmarks = await _storageService.loadBookmarks(widget.pdfPath);

      setState(() {
        _bookmarks = bookmarks;
        if (_pdfViewController != null) {
          _pdfViewController!.setPage(lastPage);
        }
      });
    } catch (e) {
      print('Error loading saved data: $e');
    }
  }

  void _addBookmark() async {
    final bookmark = PdfBookmark(
      pageNumber: _currentPage,
      timestamp: DateTime.now(),
    );

    setState(() {
      _bookmarks.add(bookmark);
    });

    await _storageService.saveBookmarks(widget.pdfPath, _bookmarks);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bookmark added to page ${_currentPage + 1}'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showBookmarks() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: _bookmarks.length,
          itemBuilder: (context, index) {
            final bookmark = _bookmarks[index];
            return ListTile(
              leading: const Icon(Icons.bookmark, color: Colors.blue),
              title: Text('Page ${bookmark.pageNumber + 1}'),
              subtitle: Text(DateFormat.yMMMd().format(bookmark.timestamp)),
              onTap: () {
                _pdfViewController!.setPage(bookmark.pageNumber);
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Reader',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Tooltip(
            message: 'Toggle Dark Mode',
            child: IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: _toggleDarkMode,
            ),
          ),
          Tooltip(
            message: 'Add Bookmark',
            child: IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: _addBookmark,
            ),
          ),
          Tooltip(
            message: 'View Bookmarks',
            child: IconButton(
              icon: const Icon(Icons.bookmarks),
              onPressed: _showBookmarks,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                _localPdfPath == null
                    ? const Center(child: CircularProgressIndicator())
                    : PDFView(
                        filePath: _localPdfPath,
                        enableSwipe: true,
                        swipeHorizontal: true,
                        autoSpacing: true,
                        pageFling: true,
                        onRender: (pages) {
                          setState(() {
                            _totalPages = pages!;
                            _isLoading = false;
                          });
                        },
                        onError: (error) {
                          print('Error: $error');
                        },
                        onPageError: (page, error) {
                          print('Page error: $error');
                        },
                        onViewCreated: (PDFViewController pdfViewController) {
                          setState(() {
                            _pdfViewController = pdfViewController;
                          });
                        },
                        onPageChanged: (int? page, int? total) {
                          if (page != null) {
                            setState(() {
                              _currentPage = page;
                            });
                            _storageService.saveLastPage(widget.pdfPath, page);
                          }
                        },
                      ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: _buildControls(),
                ),
              ],
            ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: _totalPages == 0 ? 0 : (_currentPage + 1) / _totalPages,
            backgroundColor: _isDarkMode ? Colors.grey[800] : Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              _isDarkMode ? Colors.orange : Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.navigate_before),
                onPressed: _currentPage > 0
                    ? () => _pdfViewController?.setPage(_currentPage - 1)
                    : null,
                tooltip: 'Previous Page',
              ),
              Text(
                'Page ${_currentPage + 1} of $_totalPages',
                style: TextStyle(
                  color: _isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.navigate_next),
                onPressed: _currentPage < _totalPages - 1
                    ? () => _pdfViewController?.setPage(_currentPage + 1)
                    : null,
                tooltip: 'Next Page',
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _storageService.saveLastPage(widget.pdfPath, _currentPage);
    super.dispose();
  }
}
