import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize; // AppBar height

  CustomAppBar() : preferredSize = Size.fromHeight(80.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Icon (Back button)
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Navigate back
              },
              child: CircleAvatar(
                backgroundColor: Colors.orange,
                radius: 17,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
            // Right Icon (Warning/Alert button)
            GestureDetector(
              onTap: () {
                _showReportDialog(context);
              },
              child: CircleAvatar(
                backgroundColor: Colors.red,
                radius: 17,
                child: Icon(
                  Icons.error_outline,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Report"),
          content: Text("Do you want to report some inappropriate content?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                // Add your report logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Reported successfully!')),
                );
              },
              child: Text(
                "Report",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
