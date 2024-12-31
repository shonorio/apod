import 'package:apod/app/features/favorites/ui/favorites_page_state.dart';
import 'package:flutter/foundation.dart';

class FavoritesPageController extends ValueNotifier<FavoritesPageState> {
  FavoritesPageController() : super(const FavoritesNoItems());
}
