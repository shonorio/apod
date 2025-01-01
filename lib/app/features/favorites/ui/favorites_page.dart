import 'package:apod/app/features/favorites/ui/favorites_page_controller.dart';
import 'package:apod/app/features/favorites/ui/favorites_page_state.dart';
import 'package:apod/app/features/favorites/ui/widgets/favorites_empty_state.dart';
import 'package:apod/app/features/favorites/ui/widgets/favorites_list_items.dart';
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
        valueListenable: controller..fetchFavorites(),
        builder: (context, state, child) {
          return switch (state) {
            FavoritesNoItems() => const FavoritesEmptyState(),
            FavoritesLoadSuccess(favorites: final it) => FavoritesListItems(
                pictures: it,
                onTap: (favorite) => (_) {},
                onDismissed: controller.removeFavorite,
              ),
          };
        },
      ),
    );
  }
}

// DONE: Show empty state
// DONE: Show a list of favorite APODs
// DONE: Add a action to remove a favorite
// TODO: Add a action to navigate to the APOD page
