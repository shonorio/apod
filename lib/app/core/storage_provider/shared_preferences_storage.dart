import 'package:shared_preferences/shared_preferences.dart';
import 'storage_provider.dart';

class SharedPreferencesStorage implements StorageProvider {
  final SharedPreferences _storage;

  SharedPreferencesStorage(this._storage);

  @override
  Future<bool> create(String id, String value) async {
    return await _storage.setString(id, value);
  }

  @override
  Future<List<String>> fetch({String? id}) async {
    if (id != null) {
      final value = _storage.getString(id);
      return value != null ? [value] : [];
    }

    final allKeys = _storage.getKeys();
    return allKeys.map((key) => _storage.getString(key)!).toList();
  }

  @override
  Future<bool> delete(String id) async {
    return await _storage.remove(id);
  }
}
