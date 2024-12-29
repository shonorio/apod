import 'package:apod/app/core/api_provider/interfaces/api_request.dart';
import 'package:apod/app/core/api_provider/interfaces/api_request_builder.dart';
import 'package:apod/app/core/app_configuration/app_environment.dart';

final class PictureOfDayRequestBuilder implements ApiRequestBuilder {
  PictureOfDayRequestBuilder({
    this.date,
    this.startDate,
    this.endDate,
    this.count,
  });

  final DateTime? date;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? count;

  @override
  buildRequest(Uri baseUri) {
    final String apiKey = AppEnvironment.nasaApiToken();

    final queryParams = {
      'api_key': apiKey,
      'thumbs': 'true',
    };

    if (date != null && date!.isBefore(DateTime.now())) {
      queryParams['date'] = date!.toYYYYMMDD();
    }

    if (count != null) {
      queryParams.remove('date');
      final validCount = count! < 1 ? 1 : (count! > 100 ? 100 : count!);
      queryParams['count'] = validCount.toString();
    }

    if (startDate != null && endDate != null) {
      final now = DateTime.now();
      if (startDate!.isBefore(now) &&
          endDate!.isBefore(now) &&
          endDate!.isAfter(startDate!)) {
        queryParams.remove('date');
        queryParams.remove('count');
        queryParams['start_date'] = startDate!.toYYYYMMDD();
        queryParams['end_date'] = endDate!.toYYYYMMDD();
      }
    }

    return ApiRequest(
      baseUrl: baseUri
          .appendingPath('/planetary/apod')
          .addingQueryParameters(queryParams),
    );
  }
}

extension _DateTimeParser on DateTime {
  String toYYYYMMDD() => toIso8601String().split('T')[0];
}
