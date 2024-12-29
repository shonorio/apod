import 'package:collection/collection.dart';

sealed class Result<S extends Object, E extends Exception> {
  const Result();

  S getOrElse(S Function(E error) onError);
  S getValueOr(S defaultValue);
}

class Success<S extends Object, E extends Exception> extends Result<S, E> {
  const Success(this.data);

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
}

class Failure<S extends Object, E extends Exception> extends Result<S, E> {
  const Failure(this.error);

  final E error;

  @override
  S getOrElse(S Function(E error) onError) => onError(error);

  @override
  S getValueOr(S defaultValue) => defaultValue;

  @override
  int get hashCode => error.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Failure<S, E>) return false;
    return error == other.error;
  }
}

typedef AsyncResult<S extends Object> = Future<Result<S, Exception>>;

extension AsyncResultExtension<S extends Object> on AsyncResult<S> {
  Future<S> getValueOr(S defaultValue) =>
      then((result) => result.getOrElse((_) => defaultValue));

  Future<S> getOrElse(S Function(Exception error) onError) =>
      then((result) => result.getOrElse(onError));
}
