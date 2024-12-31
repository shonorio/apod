import 'package:apod/app/core/extensions/build_context.dart';
import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';
import 'package:flutter/material.dart';

class PictureOfDayExplanationWidget extends StatelessWidget {
  const PictureOfDayExplanationWidget({
    super.key,
    required this.pictureOfDayEntity,
  });

  final PictureOfDayEntity pictureOfDayEntity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        pictureOfDayEntity.explanation,
        style: context.textTheme.bodyMedium,
      ),
    );
  }
}
