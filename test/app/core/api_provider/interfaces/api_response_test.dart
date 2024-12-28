import 'package:apod/app/core/api_provider/interfaces/api_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(ApiResponse, () {
    test('with null body return empty Json from toJson()', () {
      // arrange
      final sut = ApiResponse(statusCode: 200);
      // act
      final result = sut.toJson();
      // assert
      expect(result.isEmpty, true);
      expect(result, {});
    });

    test('wit body return Json data from toJson()', () {
      // arrange
      final sut = ApiResponse(statusCode: 200, body: '{"key": "value"}');
      // act
      final result = sut.toJson();
      // assert
      expect(result, {'key': 'value'});
    });
  });
}
