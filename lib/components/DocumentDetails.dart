import 'package:flutter/material.dart';

class DocumentDetails extends StatelessWidget {
  const DocumentDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Rating', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: List.generate(5,
                  (index) => const Icon(Icons.star, color: Colors.orange, size: 16)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text('Length: 39 pages'),
        const Text('Released: 21/06/2022'),
      ],
    );
  }
}
