import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FavoritesListItems extends StatefulWidget {
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
  State<FavoritesListItems> createState() => _FavoritesListItemsState();
}

class _FavoritesListItemsState extends State<FavoritesListItems> {
  late List<PictureOfDayEntity> _pictures;

  @override
  void initState() {
    super.initState();
    _pictures = List.from(widget.pictures);
  }

  @override
  void didUpdateWidget(FavoritesListItems oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pictures != widget.pictures) {
      _pictures = List.from(widget.pictures);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _pictures.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final favorite = _pictures[index];
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
          onDismissed: (_) {
            setState(() {
              _pictures.removeAt(index);
            });
            widget.onDismissed(favorite);
          },
          child: ListTile(
            leading: CachedNetworkImage(
              imageUrl: url,
              width: 56,
              height: 56,
              fit: BoxFit.fill,
            ),
            title: Text(favorite.title),
            subtitle: Text(favorite.date.toLocal().toString()),
            onTap: () => widget.onTap(favorite),
          ),
        );
      },
    );
  }
}
