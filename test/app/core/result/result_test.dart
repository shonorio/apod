// ignore_for_file: prefer_const_declarations, unrelated_type_equality_checks

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apod/app/core/result/result.dart';

void main() {
  group(Result, () {
    group(Success, () {
      group('equality', () {
        test(
          'should return true if both successes have the same String value',
          () {
            final value1 = 'success';
            final success1 = Success<String, Exception>(value1);
            final success2 = Success<String, Exception>(value1);

            expect(success1 == success2, isTrue);
          },
        );

        test(
          'should return false if both successes have different String values',
          () {
            final value1 = 'success1';
            final value2 = 'success2';
            final success1 = Success<String, Exception>(value1);
            final success2 = Success<String, Exception>(value2);

            expect(success1 == success2, isFalse);
          },
        );

        test(
          'should return false if both have the different types',
          () {
            final list1 = [1, 2, 3];
            final success1 = Success<List<int>, Exception>(list1);
            final success2 = const Success<String, Exception>('value');

            expect(success1 == success2, isFalse);
          },
        );

        test(
          'should return true if both successes have the same List value',
          () {
            final list1 = [1, 2, 3];
            final success1 = Success<List<int>, Exception>(list1);
            final success2 = Success<List<int>, Exception>(List.from(list1));

            expect(success1 == success2, isTrue);
          },
        );

        test(
          'should return true if both successes have the same Iterable value',
          () {
            final list1 = Iterable<int>.generate(3);
            final list2 = Iterable<int>.generate(3);
            final success1 = Success<Iterable<int>, Exception>(list1);
            final success2 = Success<Iterable<int>, Exception>(list2);

            expect(success1 == success2, isTrue);
          },
        );

        test(
          'should return true if both successes have different Iterable value',
          () {
            final list1 = Iterable<int>.generate(3);
            final list2 = Iterable<int>.generate(3, (x) => x++);
            final success1 = Success<Iterable<int>, Exception>(list1);
            final success2 = Success<Iterable<int>, Exception>(list2);

            expect(success1 == success2, isTrue);
          },
        );
        test(
          'should return false if both successes have different List values',
          () {
            final list1 = [1, 2, 3];
            final list2 = [4, 5, 6];
            final success1 = Success<List<int>, Exception>(list1);
            final success2 = Success<List<int>, Exception>(list2);

            expect(success1 == success2, isFalse);
          },
        );

        test(
          'should return true if both successes have the same Map value',
          () {
            final map1 = {'key1': 'value1', 'key2': 'value2'};
            final success1 = Success<Map<String, String>, Exception>(map1);
            final success2 =
                Success<Map<String, String>, Exception>(Map.from(map1));

            expect(success1 == success2, isTrue);
          },
        );

        test(
          'should return false if both successes have different Map values',
          () {
            final map1 = {'key1': 'value1', 'key2': 'value2'};
            final map2 = {'key3': 'value3', 'key4': 'value4'};
            final success1 = Success<Map<String, String>, Exception>(map1);
            final success2 = Success<Map<String, String>, Exception>(map2);

            expect(success1 == success2, isFalse);
          },
        );

        test(
          'should return false if the other object is not a Success',
          () {
            final value1 = 'success';
            final success = Success<String, Exception>(value1);
            final otherObject = Object();

            expect(success == otherObject, isFalse);
          },
        );

        test(
          'should return true for self-equality',
          () {
            final value1 = 'success';
            final success = Success<String, Exception>(value1);

            expect(success == success, isTrue);
          },
        );

        test('should return true for same Object', () {
          final obj1 = const SingleObject(intValue: 1, stringValue: 'value');
          final obj2 = const SingleObject(intValue: 1, stringValue: 'value');
          final success1 = Success<SingleObject, Exception>(obj1);
          final success2 = Success<SingleObject, Exception>(obj2);

          expect(success1 == success2, isTrue);
        });

        test('should return true for different Object', () {
          final obj1 = const SingleObject(intValue: 1, stringValue: 'value');
          final obj2 =
              const SingleObject(intValue: 1, stringValue: 'not_value');
          final success1 = Success<SingleObject, Exception>(obj1);
          final success2 = Success<SingleObject, Exception>(obj2);

          expect(success1 == success2, isFalse);
        });
      });

      group('properties and methods', () {
        test('getOrDefault should return the value when not null', () {
          final value1 = 'success';
          final success = Success<String, Exception>(value1);

          expect(success.getValueOr('default'), equals(value1));
        });
      });
    });
  });

  group(Failure, () {
    group('equality', () {
      test('return true if both failures have the same exception', () {
        final ex1 = Exception('error');
        final failure1 = Failure(ex1);
        final failure2 = Failure(ex1);

        expect(failure1 == failure2, isTrue);
      });

      test('return false if both failures have different exceptions', () {
        final ex1 = Exception('error1');
        final ex2 = Exception('error2');
        final failure1 = Failure(ex1);
        final failure2 = Failure(ex2);

        expect(failure1 == failure2, isFalse);
      });

      test('return false if the other object is not a Failure', () {
        final ex1 = Exception('error');
        final failure = Failure(ex1);
        final otherObject = Object();

        expect(failure == otherObject, isFalse);
      });

      test('return true for self-equality', () {
        final ex1 = Exception('error');
        final failure = Failure(ex1);

        expect(failure == failure, isTrue);
      });
    });

    group('properties and methods', () {
      test('getOrDefault should return "defaultValue', () {
        final failure = Failure(Exception('failure'));
        expect(failure.getValueOr('default'), equals('default'));
      });
    });
  });
}

@immutable
class SingleObject {
  const SingleObject({required this.intValue, required this.stringValue});

  final int intValue;
  final String stringValue;

  @override
  bool operator ==(Object o) =>
      o is SingleObject &&
      o.intValue == intValue &&
      o.stringValue == stringValue;

  @override
  int get hashCode => Object.hash(intValue, stringValue);
}
