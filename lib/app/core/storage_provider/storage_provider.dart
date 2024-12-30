abstract class StorageProvider {
  /// Stores an item with the given [id] and [value]
  /// Returns [true] if the operation was successful
  Future<bool> create(String id, Map<String, dynamic> value);

  /// Retrieves all stored items
  /// If [id] is provided, retrieves only the item with the given [id]
  Future<List<Map<String, dynamic>>> fetch({String? id});

  /// Removes an item with the given [id]
  /// Returns [true] if the operation was successful
  Future<bool> delete(String id);
}
