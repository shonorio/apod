import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';
import 'package:apod/app/features/apod/ui/apod_page_controller.dart';
import 'package:apod/app/features/apod/ui/apod_page_state.dart';
import 'package:apod/app/features/apod/ui/widget/adaptive_date_picker.dart';
import 'package:apod/app/features/apod/ui/widget/error_state_widget.dart';
import 'package:apod/app/features/apod/ui/widget/loading_state_widget.dart';
import 'package:apod/app/features/apod/ui/widget/picture_of_day_explanation_widget.dart';
import 'package:apod/app/features/apod/ui/widget/picture_of_day_media_widget.dart';
import 'package:apod/app/features/apod/ui/widget/picture_of_day_title_widget.dart';
import 'package:flutter/material.dart';

class ApodPage extends StatelessWidget {
  const ApodPage({
    super.key,
    this.pictureOfDay,
    required this.controller,
  });

  final PictureOfDayEntity? pictureOfDay;
  final ApodPageController controller;

  @override
  Widget build(BuildContext context) {
    bool isRootMode = pictureOfDay == null;

    return ValueListenableBuilder(
      valueListenable: controller..fetchPictureOfDay(pictureOfDay),
      builder: (context, state, child) {
        return switch (state) {
          ApodPageLoading() => const LoadingStateWidget(),
          ApodPageLoadSuccess(pictureOfDay: final it) => _ApodPageLoadSuccess(
              pictureOfDay: it,
              isRootMode: isRootMode,
              onAddToFavorites: () => controller.addToFavorites(it),
              onSelectDate: (date) => controller.selectDate(date),
            ),
          ApodPageError() => ErrorStateWidget(
              title: 'Error',
              subtitle: 'An error occurred. Please try again later.',
              onPressed: () => controller.fetchPictureOfDay(pictureOfDay),
            ),
          ApodPageNoInternetConnection() => ErrorStateWidget(
              title: 'Unable to connect to the internet',
              subtitle: 'Please check your connection and try again.',
              onPressed: () => controller.fetchPictureOfDay(pictureOfDay),
            ),
          ApodPageRateLimitError() => ErrorStateWidget(
              title: 'Rate limit exceeded',
              subtitle:
                  'You have made too many requests. Please wait a moment before trying again.',
              onPressed: () => controller.fetchPictureOfDay(pictureOfDay),
            ),
        };
      },
    );
  }
}

class _ApodPageLoadSuccess extends StatelessWidget {
  const _ApodPageLoadSuccess({
    required this.pictureOfDay,
    required this.isRootMode,
    required this.onAddToFavorites,
    required this.onSelectDate,
  });

  final PictureOfDayEntity pictureOfDay;
  final bool isRootMode;

  final void Function() onAddToFavorites;
  final void Function(DateTime) onSelectDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture of the Day'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: onAddToFavorites,
          ),
          if (isRootMode)
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final firstApodPublishedDate = DateTime(1995, 6, 16);
                final selectedDate = await AdaptiveDatePicker.show(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: firstApodPublishedDate,
                  lastDate: DateTime.now(),
                );

                if (selectedDate != null) {
                  onSelectDate(selectedDate);
                }
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PictureOfDayMediaWidget(pictureOfDayEntity: pictureOfDay),
            PictureOfDayTitleWidget(pictureOfDayEntity: pictureOfDay),
            PictureOfDayExplanationWidget(pictureOfDayEntity: pictureOfDay),
          ],
        ),
      ),
    );
  }
}
