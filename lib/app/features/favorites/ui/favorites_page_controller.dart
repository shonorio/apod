import 'package:apod/app/core/result/result.dart';
import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';
import 'package:apod/app/features/favorites/domain/repository/favorites_repository.dart';
import 'package:apod/app/features/favorites/ui/favorites_page_state.dart';
import 'package:flutter/foundation.dart';

class FavoritesPageController extends ValueNotifier<FavoritesPageState> {
  FavoritesPageController(this._repository) : super(const FavoritesNoItems());

  final FavoritesRepository _repository;

  Future<void> fetchFavorites() async {
    final result = await _repository.fetchFavorites().fold(
          onSuccess: (it) => it.isEmpty
              ? const FavoritesNoItems()
              : FavoritesLoadSuccess(favorites: it),
          onFailure: (_) => const FavoritesNoItems(),
        );

    value = result;
  }

  Future<void> removeFavorite(PictureOfDayEntity favorite) async {
    await _repository.removeFavorite(favorite);
    await fetchFavorites();
  }
}
