import 'package:apod/app/core/result/result.dart';
import 'package:apod/app/core/storage_provider/storage_provider.dart';
import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';

final class FavoritesRepository {
  final StorageProvider _storage;

  FavoritesRepository(this._storage);

  AsyncResult<bool, Exception> addFavorite(
      PictureOfDayEntity pictureOfDay) async {
    try {
      final id = pictureOfDay.date.toId();
      return Success(await _storage.create(id, pictureOfDay.toJson()));
    } catch (e) {
      return Failure(Exception('Failed to generate favorite ID'));
    }
  }

  AsyncResult<bool, Exception> removeFavorite(
      PictureOfDayEntity pictureOfDay) async {
    try {
      final id = pictureOfDay.date.toId();
      return Success(await _storage.delete(id));
    } catch (e) {
      return Failure(Exception('Failed to remove favorite'));
    }
  }

  AsyncResult<List<PictureOfDayEntity>, Exception> getFavorites() async {
    try {
      final favorites = await _storage.fetch();
      return Success(
          favorites.map((e) => PictureOfDayEntity.fromJson(e)).toList());
    } catch (e) {
      return Failure(Exception('Failed to get favorites'));
    }
  }
}

extension _DateExtension on DateTime {
  String toId() => millisecondsSinceEpoch.toString();
}
