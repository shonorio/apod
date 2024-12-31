import 'package:apod/app/core/extentions/build_context.dart';
import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PictureOfDayTitleWidget extends StatelessWidget {
  const PictureOfDayTitleWidget({
    super.key,
    required this.pictureOfDayEntity,
  });

  final PictureOfDayEntity pictureOfDayEntity;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMMEEEEd().format(pictureOfDayEntity.date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            pictureOfDayEntity.title,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
        ],
      ),
    );
  }
}
