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
    bool isLong = widget.description.length > maxLength;
    String shortDescription = isLong
        ? widget.description.substring(0, maxLength) + '...'
        : widget.description;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isExpanded ? widget.description : shortDescription,
          style: TextStyle(fontSize: 14),
        ),
        if (isLong) // Show "Show more" only if the text is long
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? 'Show less' : 'Show more',
              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
