import 'package:flutter/material.dart';
import '../listContent.dart';

class ListCard extends StatelessWidget {
  final String title;
  final String id;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ListCard({
    Key? key,
    required this.title,
    required this.id,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  void _navigateToListDetails(String listId, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentListPage(
          listId: int.parse(listId), // Using the passed listId parameter
          listName: this.title, // Using the title from the class properties
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigateToListDetails(id, context),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                color: Colors.green,
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
