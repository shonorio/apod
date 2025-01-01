import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';

sealed class ApodPageState {
  const ApodPageState();
}

class ApodPageLoading extends ApodPageState {
  const ApodPageLoading();
}

class ApodPageError extends ApodPageState {
  const ApodPageError();
}

class ApodPageLoadSuccess extends ApodPageState {
  final PictureOfDayEntity pictureOfDay;

  const ApodPageLoadSuccess({required this.pictureOfDay});
}

class ApodPageNoInternetConnection extends ApodPageState {
  const ApodPageNoInternetConnection();
}
