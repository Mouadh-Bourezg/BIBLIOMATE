import 'package:flutter/material.dart';

class DocumentTags extends StatelessWidget {
  const DocumentTags({super.key});

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

  const DocumentTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Colors.grey,
      label: Text(label,
      style: const TextStyle(
        color: Colors.white
      ),),
    );
  }
}
