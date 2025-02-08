import 'package:flutter/material.dart';

class DocumentDescription extends StatefulWidget {
  final String description;

  const DocumentDescription({super.key, required this.description});

  @override
  _DocumentDescriptionState createState() => _DocumentDescriptionState();
}

class _DocumentDescriptionState extends State<DocumentDescription> {
  bool isExpanded = false;
  static const int maxLength = 100; // Maximum characters to show initially

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool isLong = widget.description.length > maxLength;
    String shortDescription = isLong
        ? '${widget.description.substring(0, maxLength)}...'
        : widget.description;

    return Container(
      margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.01), // 1% of screen height
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02), // 2% of screen width
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description,
                color: Colors.blue,
                size: screenWidth * 0.05, // 5% of screen width
              ),
              SizedBox(width: screenWidth * 0.02), // 2% of screen width
              Text(
                'Description',
                style: TextStyle(
                  fontSize: screenWidth * 0.04, // 4% of screen width
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01), // 1% of screen height
          // Description Content
          Text(
            isExpanded ? widget.description : shortDescription,
            style: TextStyle(
              fontSize: screenWidth * 0.035, // 3.5% of screen width
              color: Colors.black87,
              height: 1.5, // Line height for better readability
            ),
          ),
          // Show More/Less Button
          if (isLong)
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.01), // 1% of screen height
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.005), // 0.5% of screen height
                  child: Text(
                    isExpanded ? 'Show less' : 'Show more',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.035, // 3.5% of screen width
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
