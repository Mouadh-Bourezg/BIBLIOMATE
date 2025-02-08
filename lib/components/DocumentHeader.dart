import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/pdf_reader_page.dart';
import '../models/document.dart';
import '../services/userServices.dart';

class DocumentHeader extends StatelessWidget {
  final Document document;

  DocumentHeader({Key? key, required this.document}) : super(key: key);

  final userService = UserService(Supabase.instance.client);

  Future<String?> getUploaderName(String uploaderId) async {
    try {
      final userInfo = await userService.getUserInformation(uploaderId);
      return '${userInfo['first_name'] ?? ''} ${userInfo['last_name'] ?? ''}';
    } catch (e) {
      // Log or handle error
      return "Unknown"; // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04, // Increased from 5% to 6%
        vertical: screenHeight * 0.01, // Increased from 2% to 2.4%
      ),
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            screenWidth * 0.024), // Increased from 2% to 2.4%
      ),
      child: Padding(
        padding:
            EdgeInsets.all(screenWidth * 0.048), // Increased from 4% to 4.8%
        child: Row(
          children: [
            // Document Image
            DocumentImage(imageUrl: document.imageUrl),
            SizedBox(width: screenWidth * 0.048), // Increased from 4% to 4.8%
            // Title, Uploader Info, and "Read Now" Button in a column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    document.title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.06, // Increased from 5% to 6%
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                      height:
                          screenHeight * 0.012), // Increased from 1% to 1.2%
                  // Uploader info (FutureBuilder)
                  FutureBuilder<String?>(
                    future: getUploaderName(document.uploaderId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Loading state
                        return Row(
                          children: [
                            Text(
                              'Uploaded by: ',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: screenWidth *
                                    0.036, // Increased from 3% to 3.6%
                              ),
                            ),
                            SizedBox(
                                width: screenWidth *
                                    0.012), // Increased from 1% to 1.2%
                            SizedBox(
                              width: screenWidth *
                                  0.045, // Increased from 3.75% to 4.5%
                              height: screenWidth *
                                  0.045, // Increased from 3.75% to 4.5%
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          ],
                        );
                      } else if (snapshot.hasError) {
                        // Error state
                        return Row(
                          children: [
                            Text(
                              'Uploaded by: ',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: screenWidth *
                                    0.036, // Increased from 3% to 3.6%
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Error loading uploader',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth *
                                      0.036, // Increased from 3% to 3.6%
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      } else {
                        // Success state
                        final uploaderName = snapshot.data ?? "Unknown";
                        return Row(
                          children: [
                            Text(
                              'Uploaded by: ',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: screenWidth *
                                    0.036, // Increased from 3% to 3.6%
                              ),
                            ),
                            Expanded(
                              child: Text(
                                uploaderName.trim().isEmpty
                                    ? "Unknown"
                                    : uploaderName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth *
                                      0.036, // Increased from 3% to 3.6%
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(
                      height:
                          screenHeight * 0.024), // Increased from 2% to 2.4%
                  // Align the button to the right
                  Align(
                    alignment: Alignment.centerRight,
                    child: ReadNowButton(pdfUrl: document.pdfContentUrl),
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

class DocumentImage extends StatelessWidget {
  final String imageUrl;

  const DocumentImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: BorderRadius.circular(
          screenWidth * 0.024), // Increased from 2% to 2.4%
      child: Stack(
        children: [
          // Document cover image
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: screenWidth * 0.24, // Increased from 20% to 24%
            height: screenWidth * 0.36, // Increased from 30% to 36%
            errorBuilder: (context, error, stackTrace) {
              // Fallback if image fails to load
              return Container(
                width: screenWidth * 0.24, // Increased from 20% to 24%
                height: screenWidth * 0.36, // Increased from 30% to 36%
                color: Colors.grey.shade300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: screenWidth * 0.096, // Increased from 8% to 9.6%
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(height: screenWidth * 0.012),
                    Text(
                      'Image\nNot Found',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.032,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: screenWidth * 0.24, // Increased from 20% to 24%
                height: screenWidth * 0.36, // Increased from 30% to 36%
                alignment: Alignment.center,
                color: Colors.grey.shade200,
                child: SizedBox(
                  width: screenWidth * 0.06, // Increased from 5% to 6%
                  height: screenWidth * 0.06, // Increased from 5% to 6%
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
          ),
          // "PDF" label
          Positioned(
            bottom: screenWidth * 0.012, // Increased from 1% to 1.2%
            right: screenWidth * 0.012, // Increased from 1% to 1.2%
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(
                    screenWidth * 0.012), // Increased from 1% to 1.2%
              ),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.024, // Increased from 2% to 2.4%
                vertical: screenWidth * 0.006, // Increased from 0.5% to 0.6%
              ),
              child: Text(
                'PDF',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.036, // Increased from 3% to 3.6%
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReadNowButton extends StatelessWidget {
  final String pdfUrl;

  const ReadNowButton({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: pdfUrl.isNotEmpty
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfReaderPage(pdfPath: pdfUrl),
                ),
              );
            }
          : null, // disable the button if pdfUrl is empty
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.072, // Increased from 6% to 7.2%
          vertical: screenWidth * 0.024, // Increased from 2% to 2.4%
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              screenWidth * 0.024), // Increased from 2% to 2.4%
        ),
      ),
      child: Text(
        'Read Now',
        style: TextStyle(
            fontSize: screenWidth * 0.042), // Increased from 3.5% to 4.2%
      ),
    );
  }
}
