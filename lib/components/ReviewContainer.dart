import 'package:flutter/material.dart';

class ReviewContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RatingsAndReviewsHeader(),
          ReviewHeader(),
          SizedBox(height: 8),
          ReviewContent(),
          SizedBox(height: 8),
          ReviewActions(),
        ],
      ),
    );
  }
}

class RatingsAndReviewsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Ratings & Reviews', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('See All', style: TextStyle(color: Colors.blue)),
      ],
    );
  }
}

class ReviewHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage('https://example.com/reviewer.jpg'), // Replace with actual URL
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('anes_chahira_5', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('23h', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        Row(
          children: List.generate(5, (index) => Icon(Icons.star, color: Colors.orange, size: 16)),
        ),
      ],
    );
  }
}

class ReviewContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Problem with understanding\nThe Topic',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          'A paragraph is a short collection of well-organized sentences which revolve around a single theme and is coherent...',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

class ReviewActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () {},
          icon: Icon(Icons.thumb_up, color: Colors.grey, size: 16),
          label: Text('Like', style: TextStyle(fontSize: 12)),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: Icon(Icons.comment, color: Colors.grey, size: 16),
          label: Text('Comment', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}
