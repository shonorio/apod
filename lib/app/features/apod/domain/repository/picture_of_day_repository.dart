import 'package:apod/app/core/api_provider/errors/api_provider_exception.dart';
import 'package:apod/app/core/api_provider/interfaces/api_provider.dart';
import 'package:apod/app/core/result/result.dart';
import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';
import 'package:apod/app/features/apod/domain/errors/apod_server_exception.dart';
import 'package:apod/app/features/apod/domain/repository/picture_of_day_request_builder.dart';

class PictureOfDayRepository {
  PictureOfDayRepository({
    required ApiProvider apiProvider,
  }) : _apiProvider = apiProvider;

  final ApiProvider _apiProvider;

  AsyncResult<PictureOfDayEntity, ApodServerException> call(
      DateTime? selectedDate) async {
    try {
      final response = await _apiProvider.request(
        PictureOfDayRequestBuilder(date: selectedDate),
      );
      return Success(PictureOfDayEntity.fromJson(response.toJson()));
    } on ApiProviderRequestException catch (e) {
      final errorJson = e.apiResponse.toJson();
      return Failure(InvalidRequestException(
          message: errorJson['msg'] ?? 'Invalid request'));
    } on ApiProviderRateLimitException catch (_) {
      return Failure(RateLimitException());
    } on NetworkReachabilityException catch (_) {
      return Failure(NetworkException());
    } catch (e) {
      return Failure(ServerSideException());
    }
  }
}
