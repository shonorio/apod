import 'package:apod/app/core/api_provider/api_configuration.dart';
import 'package:apod/app/core/api_provider/http_api_provider.dart';
import 'package:apod/app/core/api_provider/interfaces/api_provider.dart';
import 'package:apod/app/core/app_configuration/app_environment.dart';
import 'package:apod/app/core/storage_provider/shared_preferences_storage.dart';
import 'package:apod/app/core/storage_provider/storage_provider.dart';
import 'package:apod/app/features/apod/domain/repository/picture_of_day_repository.dart';
import 'package:apod/app/features/apod/ui/apod_page.dart';
import 'package:apod/app/features/apod/ui/apod_page_controller.dart';
import 'package:apod/app/features/favorites/domain/repository/favorites_repository.dart';
import 'package:apod/app/features/favorites/ui/favorites_page.dart';
import 'package:apod/app/features/favorites/ui/favorites_page_controller.dart';
import 'package:apod/app/features/home/ui/page/home_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i
      ..addInstance<ApiConfiguration>(
          ApiConfiguration(baseUri: AppEnvironment.nasaUri()))
      ..add<ApiProvider>(HttpApiProvider.new)
      ..add<StorageProvider>(SharedPreferencesStorage.new)
      ..add<PictureOfDayRepository>(PictureOfDayRepository.new)
      ..add<FavoritesRepository>(FavoritesRepository.new)
      ..add<FavoritesPageController>(FavoritesPageController.new)
      ..add<ApodPageController>(ApodPageController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const HomePage(), children: [
      ChildRoute(
        '/apod',
        child: (context) =>
            ApodPage(controller: Modular.get<ApodPageController>()),
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

    r.child(
      '/favorites/apod',
      child: (context) => ApodPage(
        controller: Modular.get<ApodPageController>(),
        pictureOfDay: r.args.data,
      ),
    );
  }
}
