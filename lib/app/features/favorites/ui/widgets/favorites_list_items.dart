import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FavoritesListItems extends StatelessWidget {
  const FavoritesListItems({
    super.key,
    required this.pictures,
    required this.onTap,
    required this.onDismissed,
  });

  final Function(PictureOfDayEntity) onTap;
  final Function(PictureOfDayEntity) onDismissed;
  final List<PictureOfDayEntity> pictures;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: pictures.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final favorite = pictures[index];
        final url = favorite.thumbnailUrl ?? favorite.url;
        return Dismissible(
          key: ValueKey(favorite.date),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(
              Icons.delete_forever_outlined,
              color: Colors.white,
            ),
          ),
          onDismissed: (_) => onDismissed(favorite),
          child: ListTile(
            leading: CachedNetworkImage(
              imageUrl: url,
              width: 56,
              height: 56,
              fit: BoxFit.fill,
            ),
            title: Text(favorite.title),
            subtitle: Text(favorite.date.toLocal().toString()),
            onTap: () => onTap(favorite),
          ),
        );
      },
    );
  }
}
