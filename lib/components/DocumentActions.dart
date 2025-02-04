import 'package:flutter/material.dart';

class DocumentActions extends StatelessWidget {
  final VoidCallback onAddToList;

  DocumentActions({required this.onAddToList});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ActionIcon(icon: Icons.download, label: 'Download (0.3MB)'),
        //ActionIcon(icon: Icons.save, label: 'Save'),
        IconButton(
          icon: Icon(Icons.playlist_add),
          onPressed: onAddToList,
        ),
      ],
    );
  }
}

class ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  ActionIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.black),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
