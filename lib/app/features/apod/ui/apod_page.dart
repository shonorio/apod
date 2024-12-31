import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';
import 'package:apod/app/features/apod/ui/widget/picture_of_day_explanation_widget.dart';
import 'package:apod/app/features/apod/ui/widget/picture_of_day_media_widget.dart';
import 'package:apod/app/features/apod/ui/widget/picture_of_day_title_widget.dart';
import 'package:flutter/material.dart';

class ApodPage extends StatelessWidget {
  const ApodPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PictureOfDayEntity pictureOfDayEntity = PictureOfDayEntity.fromJson({
      'copyright': '\nKristina Makeeva\n',
      'date': '2024-12-29',
      'explanation':
          "What are these bubbles frozen into Lake Baikal? Methane.  Lake Baikal, a UNESCO World Heritage Site in Russia, is the world's largest (by volume), oldest, and deepest lake, containing over 20% of the world's fresh water. The lake is also a vast storehouse of methane, a greenhouse gas that, if released, could potentially increase the amount of infrared light absorbed by Earth's atmosphere, and so increase the average temperature of the entire planet. Fortunately, the amount of methane currently bubbling out is not climatologically important. It is not clear what would happen, though, were temperatures to significantly increase in the region, or if the water level in Lake Baikal were to drop.  Pictured, bubbles of rising methane froze during winter into the exceptionally clear ice covering the lake.   Jigsaw Challenge: Astronomy Puzzle of the Day",
      'hdurl':
          'https://apod.nasa.gov/apod/image/2412/BaikalBubbles_Makeeva_1000.jpg',
      'media_type': 'image',
      'service_version': 'v1',
      'title': 'Andromeda Galaxy: A Neighboring Spiral',
      'url': 'https://apod.nasa.gov/apod/image/2412/M27_Stobie_960.jpg',
      // 'url':
      // 'https://apod.nasa.gov/apod/image/2412/BaikalBubbles_Makeeva_960.jpg'
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture of the Day'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final firstApodPublishedDate = DateTime(1995, 6, 16);

              final selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: firstApodPublishedDate,
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
                print(selectedDate);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PictureOfDayMediaWidget(pictureOfDayEntity: pictureOfDayEntity),
            PictureOfDayTitleWidget(pictureOfDayEntity: pictureOfDayEntity),
            PictureOfDayExplanationWidget(
                pictureOfDayEntity: pictureOfDayEntity),
          ],
        ),
      ),
    );
  }
}
