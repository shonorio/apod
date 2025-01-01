import 'package:collection/collection.dart';

/// Represents the result of an operation that can succeed or fail.
///
/// [Result] is a sealed class with two possible states:
/// - [Success]: Indicates the operation succeeded and holds the resulting data.
/// - [Failure]: Indicates the operation failed and holds the encountered error.
///
/// Generics:
/// - [S]: The type of the successful result.
/// - [E]: The type of the error, which must extend [Exception].
sealed class Result<S extends Object, E extends Exception> {
  const Result();

  /// Returns the value if the operation succeeded, or computes a fallback value using [onError] if it failed.
  S getOrElse(S Function(E error) onError);

  /// Returns the value if the operation succeeded, or a default [defaultValue] if it failed.
  S getValueOr(S defaultValue);

  /// Returns the value of [Failure] or null.
  E? getError();

  /// Transforms the result using [onSuccess] if successful, or [onFailure] if failed.
  ///
  /// This method allows you to handle both success and failure cases in a single call.
  /// Returns the transformed value of type [T].
  T fold<T>({
    required T Function(S data) onSuccess,
    required T Function(E error) onFailure,
  });
}

/// Represents a successful result of an operation.
///
/// Holds the resulting data of type [S].
class Success<S extends Object, E extends Exception> extends Result<S, E> {
  /// Creates a [Success] instance with the given [data].
  const Success(this.data);

  /// The data of the successful result.
  final S data;

  @override
  S getOrElse(S Function(E error) onError) => data;

  @override
  S getValueOr(S defaultValue) => data;

  @override
  int get hashCode {
    if (data is List) {
      return const ListEquality<Object?>().hash(data as List<Object?>);
    } else if (data is Iterable) {
      return const IterableEquality<Object?>().hash(data as Iterable<Object?>);
    } else if (data is Map) {
      return const MapEquality<Object?, Object?>()
          .hash(data as Map<Object?, Object?>);
    }
    return data.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Success<S, E>) return false;

    if (data is List && other.data is List) {
      return const ListEquality<Object?>()
          .equals(data as List<Object?>, other.data as List<Object?>);
    } else if (data is Iterable && other.data is Iterable) {
      return const IterableEquality<Object?>()
          .equals(data as Iterable<Object?>, other.data as Iterable<Object?>);
    } else if (data is Map && other.data is Map) {
      return const MapEquality<Object?, Object?>().equals(
          data as Map<Object?, Object?>, other.data as Map<Object?, Object?>);
    }

    return data == other.data;
  }

  @override
  E? getError() => null;
  @override
  T fold<T>({
    required T Function(S data) onSuccess,
    required T Function(E error) onFailure,
  }) {
    return onSuccess(data);
  }
}

/// Represents a failed result of an operation.
///
/// Holds the error of type [E] that caused the operation to fail.
class Failure<S extends Object, E extends Exception> extends Result<S, E> {
  /// Creates a [Failure] instance with the given [error].
  const Failure(this._error);

  /// The error that caused the operation to fail.
  final E _error;

  @override
  S getOrElse(S Function(E error) onError) => onError(_error);

  @override
  S getValueOr(S defaultValue) => defaultValue;

  @override
  int get hashCode => _error.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Failure<S, E>) return false;
    return _error == other._error;
  }

  @override
  E? getError() => _error;
  @override
  T fold<T>(
      {required T Function(S data) onSuccess,
      required T Function(E error) onFailure}) {
    return onFailure(_error);
  }
}

/// A typedef for asynchronous operations returning a [Result].
///
/// Represents an operation that produces a [Result] asynchronously.
/// The success type is [S], and the error is always an [Exception].
typedef AsyncResult<S extends Object, E extends Exception>
    = Future<Result<S, E>>;

/// Extensions on [AsyncResult] for convenient chaining and error handling.
extension AsyncResultExtension<S extends Object, E extends Exception>
    on AsyncResult<S, E> {
  /// Returns the value if the operation succeeded, or a default [defaultValue] if it failed.
  Future<S> getValueOr(S defaultValue) =>
      then((result) => result.getOrElse((_) => defaultValue));

  /// Returns the value if the operation succeeded, or computes a fallback value using [onError] if it failed.
  Future<S> getOrElse(S Function(E) onError) =>
      then((result) => result.getOrElse(onError));

  /// Transforms the [AsyncResult] using [onSuccess] if it succeeded, or [onFailure] if it failed.
  Future<T> fold<T>({
    required T Function(S data) onSuccess,
    required T Function(E error) onFailure,
  }) =>
      then(
        (result) => result.fold(
          onSuccess: onSuccess,
          onFailure: onFailure,
        ),
      );
}
