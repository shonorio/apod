import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'storage_provider.dart';

class SharedPreferencesStorage implements StorageProvider {
  Future<SharedPreferences> get _storageInstance async =>
      await SharedPreferences.getInstance();

  @override
  Future<bool> create(String id, Map<String, dynamic> value) async {
    final storage = await _storageInstance;
    return await storage.setString(id, jsonEncode(value));
  }

  @override
  Future<List<Map<String, dynamic>>> fetch({String? id}) async {
    final storage = await _storageInstance;
    if (id != null) {
      return storage.getString(id) != null
          ? [jsonDecode(storage.getString(id)!) as Map<String, dynamic>]
          : [];
    }

    return storage
        .getKeys()
        .map(storage.getString)
        .whereType<String>()
        .map(_parseJson)
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  @override
  Future<bool> delete(String id) async {
    final storage = await _storageInstance;
    return await storage.remove(id);
  }

  Map<String, dynamic>? _parseJson(String value) {
    try {
      return jsonDecode(value) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
}
