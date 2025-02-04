import 'package:flutter/material.dart';

class DocumentDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Rating', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: List.generate(5,
                  (index) => Icon(Icons.star, color: Colors.orange, size: 16)),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text('Length: 39 pages'),
        Text('Released: 21/06/2022'),
      ],
    );
  }
}
