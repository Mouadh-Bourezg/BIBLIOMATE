import 'package:flutter/material.dart';
import '../listContent.dart';

class ListCard extends StatelessWidget {
  final String title;
  final int id;
  ListCard({required this.title, required this.id});

  void _navigateToListDetails(int listId,BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentListPage(listId: listId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Ensures tap is detected
      child: InkWell(
        onTap: () => _navigateToListDetails(id, context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
