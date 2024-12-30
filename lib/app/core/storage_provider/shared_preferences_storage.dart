import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'storage_provider.dart';

class SharedPreferencesStorage implements StorageProvider {
  final SharedPreferences _storage;

  SharedPreferencesStorage(this._storage);

  @override
  Future<bool> create(String id, Map<String, dynamic> value) async {
    return await _storage.setString(id, jsonEncode(value));
  }

  @override
  Future<List<Map<String, dynamic>>> fetch({String? id}) async {
    if (id != null) {
      return _storage.getString(id) != null
          ? [jsonDecode(_storage.getString(id)!) as Map<String, dynamic>]
          : [];
    }

    return _storage
        .getKeys()
        .map(_storage.getString)
        .whereType<String>()
        .map(jsonDecode)
        .cast<Map<String, dynamic>>()
        .toList();
  }

  @override
  Future<bool> delete(String id) async {
    return await _storage.remove(id);
  }
}
