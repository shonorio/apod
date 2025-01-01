import 'package:apod/app/core/extensions/build_context.dart';
import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';
import 'package:apod/app/features/apod/ui/apod_page_controller.dart';
import 'package:apod/app/features/apod/ui/apod_page_state.dart';
import 'package:apod/app/features/apod/ui/widget/error_state_widget.dart';
import 'package:apod/app/features/apod/ui/widget/loading_state_widget.dart';
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
    return ValueListenableBuilder(
      valueListenable: controller..fetchPictureOfDay(pictureOfDay),
      builder: (context, state, child) {
        return switch (state) {
          ApodPageLoading() => const LoadingStateWidget(),
          ApodPageLoadSuccess(pictureOfDay: final it) =>
            const SizedBox.shrink(),
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
