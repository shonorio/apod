import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  ThemeData get theme => Theme.of(this);
}

extension NavigatorExtension on BuildContext {
  /// Returns the closest [NavigatorState] instance that encloses the given context.
  ///
  /// This provides convenient access to navigation operations from the current build context.
  /// Equivalent to calling `Navigator.of(context)`.
  NavigatorState get navigator => Navigator.of(this);

  /// Pushes a named route onto the navigator stack.
  ///
  /// The [routeName] parameter must be a valid route name that has been registered with
  /// the application's route configuration. The optional [arguments] parameter can be used
  /// to pass data to the new route.
  ///
  /// Returns a [Future] that completes with the result value when the pushed route is popped
  /// off the navigator stack.
  ///
  /// The route name will be sanitized by removing any double forward slashes before navigation.
  /// For example, "//home" becomes "/home".
  ///
  /// Example:
  /// ```dart
  /// context.pushNamed('/details', arguments: {'id': 123});
  /// ```

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) =>
      navigator.pushNamed<T>(
        _sanitizeRouteName(routeName),
        arguments: arguments,
      );

  String _sanitizeRouteName(String routeName) =>
      routeName.replaceAll('//', '/');
}
