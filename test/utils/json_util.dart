import 'dart:convert';
import 'dart:io';

abstract class JsonUtil {
  static Map<String, dynamic> getJson({required String from}) {
    final fileContent = getContentFile(from: from);
    return jsonDecode(fileContent) as Map<String, dynamic>;
  }

  static List<Map<String, dynamic>> getJsonList({required String from}) {
    final fileContent = getContentFile(from: from);
    return (jsonDecode(fileContent) as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  static String getContentFile({required String? from}) =>
      File('test/data/json/$from').readAsStringSync();
}
