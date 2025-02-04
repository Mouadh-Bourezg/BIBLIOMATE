import 'package:flutter/material.dart';
import '../screens/pdf_reader_page.dart';

class DocumentHeader extends StatelessWidget {
  final Map<String, String> document;

  DocumentHeader({required this.document});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            DocumentImage(imageUrl: document['imageUrl']!),
            SizedBox(width: 16),
            DocumentTitleAndUploader(
              title: document['title']!,
              uploaderName: document['uploader']!,
            ),
          ],
        ),
        ReadNowButton()
      ],
    );
  }
}

class DocumentImage extends StatelessWidget {
  final String imageUrl;

  DocumentImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
            8), // Ensure clipping matches the container's radius
        child: Stack(
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: 100,
              height: 120,
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.orange,
                ),
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  'PDF',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DocumentTitleAndUploader extends StatelessWidget {
  final String title;
  final String uploaderName;

  DocumentTitleAndUploader({required this.title, required this.uploaderName});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text('Uploaded by :'),
              SizedBox(width: 8),
              CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/glasses-1052010_640.jpg'), // Replace with actual image URL
              ),
              SizedBox(width: 8),
              Text(
                uploaderName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReadNowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PdfReaderPage(
                      pdfPath: "assets/demo.pdf",
                    )),
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.orange,
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12),
          child: Text('Read Now', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
