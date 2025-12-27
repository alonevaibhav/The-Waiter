// lib/services/storage_service.dart

import 'package:get_storage/get_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final storage = GetStorage();

  // Storage keys
  static const String menuKey = 'menu_items';


  // Initialize storage (call in main.dart)
  Future<void> init() async {
    await GetStorage.init();
  }

  // Generic CRUD operations with Model support

  // CREATE - Add item to list
  Future<void> create<T>(String key, T item, Map<String, dynamic> Function(T) toJson) async {
    List<dynamic> items = storage.read(key) ?? [];
    items.add(toJson(item));
    await storage.write(key, items);
  }

  // READ - Get all items
  List<T> readAll<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    List<dynamic>? data = storage.read(key);
    if (data == null || data.isEmpty) return [];

    return data.map((item) => fromJson(item as Map<String, dynamic>)).toList();
  }

  // READ - Get single item by id
  T? readById<T>(String key, String id, T Function(Map<String, dynamic>) fromJson) {
    List<dynamic>? data = storage.read(key);
    if (data == null) return null;

    try {
      var item = data.firstWhere((item) => item['id'] == id);
      return fromJson(item as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // UPDATE - Update item by id
  Future<void> update<T>(
      String key,
      String id,
      T updatedItem,
      Map<String, dynamic> Function(T) toJson
      ) async {
    List<dynamic> items = storage.read(key) ?? [];
    int index = items.indexWhere((item) => item['id'] == id);

    if (index != -1) {
      items[index] = toJson(updatedItem);
      await storage.write(key, items);
    }
  }

  // DELETE - Delete item by id
  Future<void> delete(String key, String id) async {
    List<dynamic> items = storage.read(key) ?? [];
    items.removeWhere((item) => item['id'] == id);
    await storage.write(key, items);
  }

  // DELETE ALL - Clear all items
  Future<void> deleteAll(String key) async {
    await storage.remove(key);
  }

  // Check if key exists
  bool exists(String key) {
    return storage.hasData(key);
  }

  // Get count
  int count(String key) {
    List<dynamic>? data = storage.read(key);
    return data?.length ?? 0;
  }
}