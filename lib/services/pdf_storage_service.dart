
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pdf_bookmark.dart';

class PdfStorageService {
  static const String _bookmarksKey = 'pdf_bookmarks';
  static const String _highlightsKey = 'pdf_highlights';
  static const String _lastPageKey = 'pdf_last_page';

  Future<void> saveBookmarks(String pdfPath, List<PdfBookmark> bookmarks) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_bookmarksKey}_$pdfPath';
    final data = bookmarks.map((b) => b.toJson()).toList();
    await prefs.setString(key, jsonEncode(data));
  }

  Future<List<PdfBookmark>> loadBookmarks(String pdfPath) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_bookmarksKey}_$pdfPath';
    final data = prefs.getString(key);
    if (data == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => PdfBookmark.fromJson(json)).toList();
  }

  Future<void> saveLastPage(String pdfPath, int page) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_lastPageKey}_$pdfPath';
    await prefs.setInt(key, page);
  }

  Future<int> loadLastPage(String pdfPath) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_lastPageKey}_$pdfPath';
    return prefs.getInt(key) ?? 0;
  }
}