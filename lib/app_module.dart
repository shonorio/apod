import 'package:apod/app/features/apod/ui/apod_page.dart';
import 'package:apod/app/features/favorites/ui/favorites_page.dart';
import 'package:apod/app/features/home/ui/page/home_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {}

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
        child: (context) => const FavoritesPage(),
        transition: TransitionType.noTransition,
      ),
    ]);
  }
}