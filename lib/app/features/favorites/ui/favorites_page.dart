import 'package:apod/app/features/favorites/ui/favorites_page_controller.dart';
import 'package:apod/app/features/favorites/ui/favorites_page_state.dart';
import 'package:apod/app/features/favorites/ui/widgets/favorites_empty_state.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key, required this.controller});

  final FavoritesPageController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: ValueListenableBuilder<FavoritesPageState>(
        valueListenable: controller,
        builder: (context, state, child) {
          return switch (state) {
            FavoritesNoItems() => const FavoritesEmptyState(),
          };
        },
      ),
    );
  }
}


// DONE: Show empty state
// TODO: Add a list of favorite APODs
// TODO: Add a action to remove a favorite
// TODO: Add a action to navigate to the APOD page
