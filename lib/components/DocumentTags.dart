import 'package:flutter/material.dart';

class DocumentTags extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        DocumentTag(label: 'Internet & web'),
        DocumentTag(label: 'Internet & web'),
        DocumentTag(label: 'Art'),
      ],
    );
  }
}

class DocumentTag extends StatelessWidget {
  final String label;

  DocumentTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Colors.grey,
      label: Text(label,
      style: TextStyle(
        color: Colors.white
      ),),
    );
  }
}
