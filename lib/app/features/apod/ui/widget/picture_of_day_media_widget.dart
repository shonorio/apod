import 'package:apod/app/core/extentions/build_context.dart';
import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

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
                child: GestureDetector(
                  onTap: () => _showFullScreenImage(context),
                  child: Image.network(
                    pictureOfDayEntity.url,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          if (pictureOfDayEntity.copyright != null)
            Text(
              'Copyright ${pictureOfDayEntity.copyright!.trim()}',
              style: context.textTheme.bodySmall,
            ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Stack(
          children: [
            PhotoView(
              imageProvider: NetworkImage(
                pictureOfDayEntity.hdUrl ?? pictureOfDayEntity.url,
              ),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
