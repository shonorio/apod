// TODO: show picture of day of selected date

import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';
import 'package:apod/app/features/apod/domain/errors/apod_server_exception.dart';
import 'package:apod/app/features/apod/domain/repository/picture_of_day_repository.dart';
import 'package:apod/app/features/apod/ui/apod_page_state.dart';
import 'package:apod/app/features/favorites/domain/repository/favorites_repository.dart';
import 'package:flutter/foundation.dart';

class ApodPageController extends ValueNotifier<ApodPageState> {
  ApodPageController(this._repository, this._favoritesRepository)
      : super(const ApodPageLoading());

  final PictureOfDayRepository _repository;
  final FavoritesRepository _favoritesRepository;
  DateTime? _selectedDate;

  Future<void> fetchPictureOfDay(PictureOfDayEntity? pictureOfDay) async {
    if (pictureOfDay != null) {
      value = ApodPageLoadSuccess(pictureOfDay: pictureOfDay);
      return;
    }

    final result = await _repository.call(_selectedDate);
    value = result.fold(
      onSuccess: (it) => ApodPageLoadSuccess(pictureOfDay: it),
      onFailure: (it) => _parseErrorState(it),
    );
  }

  Future<void> addToFavorites(PictureOfDayEntity pictureOfDay) async {
    await _favoritesRepository.addFavorite(pictureOfDay);
  }

  ApodPageState _parseErrorState(ApodServerException exception) {
    return switch (exception) {
      NetworkException() => ApodPageNoInternetConnection(),
      RateLimitException() => const ApodPageRateLimitError(),
      InvalidRequestException() => const ApodPageError(),
      ServerSideException() => const ApodPageError(),
    };
  }
}
