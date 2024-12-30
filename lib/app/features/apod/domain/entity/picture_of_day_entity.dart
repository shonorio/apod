import 'package:apod/app/core/types/json.dart';
import 'package:apod/app/features/apod/domain/entity/media_type.dart';
import 'package:equatable/equatable.dart';

final class PictureOfDayEntity extends Equatable {
  const PictureOfDayEntity({
    required this.date,
    required this.explanation,
    required this.hdUrl,
    required this.mediaType,
    required this.serviceVersion,
    required this.title,
    required this.url,
    this.copyright,
    this.thumbnailUrl,
  });

  final DateTime date;
  final String explanation;
  final String hdUrl;
  final MediaType mediaType;
  final String serviceVersion;
  final String title;
  final String url;
  final String? copyright;
  final String? thumbnailUrl;

  factory PictureOfDayEntity.fromJson(Json json) {
    return PictureOfDayEntity(
      date: DateTime.parse(json['date'] as String),
      explanation: json['explanation'] as String,
      hdUrl: json['hdurl'] as String,
      mediaType: MediaType.fromString(json['media_type'] as String),
      serviceVersion: json['service_version'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      copyright: json['copyright'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        date,
        explanation,
        hdUrl,
        mediaType,
        serviceVersion,
        title,
        url,
        copyright,
        thumbnailUrl,
      ];

  @override
  bool? get stringify => true;

  Json toJson() {
    return {
      'date': date.toIso8601String(),
      'explanation': explanation,
      'hdurl': hdUrl,
      'media_type': mediaType.toString(),
      'service_version': serviceVersion,
      'title': title,
      'url': url,
      'copyright': copyright,
      'thumbnail_url': thumbnailUrl,
    };
  }
}
