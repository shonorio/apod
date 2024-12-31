import 'package:flutter/material.dart';

class FavoritesEmptyState extends StatelessWidget {
  const FavoritesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_border,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Your favorite astronomy pictures will appear here',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
