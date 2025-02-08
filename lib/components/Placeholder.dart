import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DocumentCardPlaceholder extends StatelessWidget {
  const DocumentCardPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Dynamic card width (40% of screen width)
    final cardWidth = screenWidth * 0.4;

    // Dynamic padding based on screen width
    final horizontalPadding = screenWidth * 0.02; // 2% of screen width

    return Shimmer.fromColors(
      // Base and highlight colors for the “wave” effect
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      period: const Duration(milliseconds: 1500), // Speed of the animation
      child: Container(
        width: cardWidth,
        margin: EdgeInsets.symmetric(
            vertical: screenHeight * 0.01, horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(screenWidth * 0.03), // 3% of screen width
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(screenWidth * 0.03), // 3% of screen width
          // "Skeleton" structure
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gray rectangle for "image"
              Container(
                height: screenHeight * 0.15, // 15% of screen height
                width: double.infinity,
                color: Colors.grey[300],
              ),
              // "Text lines" placeholders
              Padding(
                padding:
                    EdgeInsets.all(screenWidth * 0.02), // 2% of screen width
                child: Column(
                  children: [
                    // Title placeholder
                    Container(
                      height: screenHeight * 0.02, // 2% of screen height
                      width: cardWidth * 0.7, // 70% of card width
                      color: Colors.grey[300],
                    ),
                    SizedBox(
                        height: screenHeight * 0.01), // 1% of screen height
                    // Uploader label placeholder
                    Container(
                      height: screenHeight * 0.015, // 1.5% of screen height
                      width: cardWidth * 0.4, // 40% of card width
                      color: Colors.grey[200],
                    ),
                    SizedBox(
                        height: screenHeight * 0.015), // 1.5% of screen height
                    // Last line placeholder
                    Container(
                      height: screenHeight * 0.015, // 1.5% of screen height
                      width: cardWidth * 0.3, // 30% of card width
                      color: Colors.grey[200],
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
