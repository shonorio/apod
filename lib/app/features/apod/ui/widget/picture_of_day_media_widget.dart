import 'package:apod/app/core/extentions/build_context.dart';
import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';
import 'package:flutter/material.dart';

class PictureOfDayMediaWidget extends StatelessWidget {
  const PictureOfDayMediaWidget({super.key, required this.pictureOfDayEntity});

  final PictureOfDayEntity pictureOfDayEntity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: AspectRatio(
                aspectRatio: 1.8,
                child: Image.network(
                  pictureOfDayEntity.url,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          if (pictureOfDayEntity.copyright != null)
            Text(
              'Copyright ${pictureOfDayEntity.copyright!.trim()}',
              style: context.textTheme.labelSmall,
            ),
        ],
      ),
    );
  }
}
