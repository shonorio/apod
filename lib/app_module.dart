import 'package:apod/app/core/storage_provider/shared_preferences_storage.dart';
import 'package:apod/app/core/storage_provider/storage_provider.dart';
import 'package:apod/app/features/apod/ui/apod_page.dart';
import 'package:apod/app/features/favorites/domain/repository/favorites_repository.dart';
import 'package:apod/app/features/favorites/ui/favorites_page.dart';
import 'package:apod/app/features/favorites/ui/favorites_page_controller.dart';
import 'package:apod/app/features/home/ui/page/home_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i
      ..add<StorageProvider>(SharedPreferencesStorage.new)
      ..add<FavoritesRepository>(FavoritesRepository.new)
      ..add<FavoritesPageController>(FavoritesPageController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const HomePage(), children: [
      ChildRoute(
        '/apod',
        child: (context) => const ApodPage(),
        transition: TransitionType.noTransition,
      ),
      ChildRoute(
        '/favorites',
        child: (context) => FavoritesPage(
          controller: Modular.get<FavoritesPageController>(),
        ),
        transition: TransitionType.noTransition,
      ),
    ]);
  }
}
