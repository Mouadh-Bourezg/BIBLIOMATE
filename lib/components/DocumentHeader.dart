import 'package:flutter/material.dart';
import '../screens/pdf_reader_page.dart';
import '../models/document.dart';
import '../services/userServices.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DocumentHeader extends StatelessWidget {
  final Document document;

  DocumentHeader({required this.document});
  final userService = UserService(Supabase.instance.client);

  Future<String?> getUploaderName(String uploaderId) async {
    try {
      final userInfo = await userService.getUserInformation(uploaderId);
      print('The uploader infos :' + userInfo.toString());
      return userInfo['first_name']! + ' ' + userInfo['last_name']!;
    } catch (e) {
      return "Unknown"; // Handle errors gracefully
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            DocumentImage(imageUrl: document.imageUrl!),
            SizedBox(width: 16),
            Expanded(
              child: FutureBuilder<String?>(
                future: getUploaderName(document.uploaderId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return DocumentTitleAndUploader(
                      title: document.title!,
                      uploaderName: "Loading...",
                    );
                  } else if (snapshot.hasError) {
                    return DocumentTitleAndUploader(
                      title: document.title!,
                      uploaderName: "Error",
                    );
                  } else {
                    return DocumentTitleAndUploader(
                      title: document.title!,
                      uploaderName: snapshot.data ?? "Unknown",
                    );
                  }
                },
              ),
            ),
          ],
        ),
        ReadNowButton(pdfUrl: document.pdfContentUrl)
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
              SizedBox(width: 3),
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
  final String pdfUrl;
  ReadNowButton({required this.pdfUrl});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PdfReaderPage(
                      pdfPath: pdfUrl,
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
