import 'package:flutter/material.dart';

class DocumentDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This discussion paper looks at the rise of startup accelerator programmes in supporting new technology ventures',
          style: TextStyle(fontSize: 14),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            'Show more',
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
