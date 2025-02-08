import 'package:flutter/material.dart';

class ReviewContainer extends StatelessWidget {
  const ReviewContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RatingsAndReviewsHeader(),
          ReviewHeader(),
          const SizedBox(height: 8),
          ReviewContent(),
          const SizedBox(height: 8),
          ReviewActions(),
        ],
      ),
    );
  }
}

class RatingsAndReviewsHeader extends StatelessWidget {
  const RatingsAndReviewsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Ratings & Reviews', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('See All', style: TextStyle(color: Colors.blue)),
      ],
    );
  }
}

class ReviewHeader extends StatelessWidget {
  const ReviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          backgroundImage: NetworkImage('https://example.com/reviewer.jpg'), // Replace with actual URL
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('anes_chahira_5', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('23h', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        Row(
          children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.orange, size: 16)),
        ),
      ],
    );
  }
}

class ReviewContent extends StatelessWidget {
  const ReviewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
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
  const ReviewActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.thumb_up, color: Colors.grey, size: 16),
          label: const Text('Like', style: TextStyle(fontSize: 12)),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.comment, color: Colors.grey, size: 16),
          label: const Text('Comment', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}
