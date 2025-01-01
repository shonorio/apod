import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';

sealed class FavoritesPageState {
  const FavoritesPageState();
}

final class FavoritesNoItems extends FavoritesPageState {
  const FavoritesNoItems();
}

final class FavoritesLoadSuccess extends FavoritesPageState {
  const FavoritesLoadSuccess({required this.favorites});

  final List<PictureOfDayEntity> favorites;
}
