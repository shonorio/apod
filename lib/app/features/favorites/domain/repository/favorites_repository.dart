import 'package:apod/app/core/result/result.dart';
import 'package:apod/app/core/storage_provider/storage_provider.dart';
import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';

class FavoritesRepository {
  final StorageProvider _storage;

  const FavoritesRepository(this._storage);

  AsyncResult<bool, Exception> addFavorite(
      PictureOfDayEntity pictureOfDay) async {
    try {
      final result = await _storage.create(
        pictureOfDay.date.toId(),
        pictureOfDay.toJson(),
      );
      return Success(result);
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

  AsyncResult<List<PictureOfDayEntity>, Exception> fetchFavorites() async {
    try {
      final favorites = await _storage.fetch();
      final result = favorites
          .map(_parsePictureOfDay)
          .whereType<PictureOfDayEntity>()
          .toList();
      return Success(result);
    } catch (e) {
      return Failure(Exception('Failed to get favorites'));
    }
  }

  PictureOfDayEntity? _parsePictureOfDay(Map<String, dynamic> json) {
    try {
      return PictureOfDayEntity.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}

extension _DateExtension on DateTime {
  String toId() => millisecondsSinceEpoch.toString();
}
