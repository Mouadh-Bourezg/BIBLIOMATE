import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PdfReaderPage extends StatefulWidget {
  final String pdfPath; // This should be the Supabase public URL

  const PdfReaderPage({required this.pdfPath, Key? key}) : super(key: key);

  @override
  _PdfReaderPageState createState() => _PdfReaderPageState();
}

class _PdfReaderPageState extends State<PdfReaderPage> {
  late final WebViewController _webViewController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(
          'https://mozilla.github.io/pdf.js/web/viewer.html?file=${widget.pdfPath}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
