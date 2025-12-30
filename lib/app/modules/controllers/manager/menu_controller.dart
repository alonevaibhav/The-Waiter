
import 'package:get/get.dart';
import '../../../core/storage/model/manager/menu_item_model.dart';
import '../../../core/storage/storage_service.dart';


class ManagerMenuController extends GetxController {
  final StorageService _storage = StorageService();

  final menuItems = <MenuItem>[].obs;
  final filteredItems = <MenuItem>[].obs;
  final categories = <String>[].obs;
  final selectedCategory = 'All'.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMenuItems();
    loadCategories();
  }

  void loadMenuItems() {
    isLoading.value = true;
    try {
      menuItems.value = _storage.readAll<MenuItem>(
        StorageService.menuKey,
        MenuItem.fromJson,
      );
      filterItems();
    } finally {
      isLoading.value = false;
    }
  }

  void loadCategories() {
    final allCategories = menuItems.map((item) => item.category).toSet().toList();
    categories.value = ['All', ...allCategories];
  }

  void filterItems() {
    var items = menuItems.where((item) {
      final matchesCategory = selectedCategory.value == 'All' ||
          item.category == selectedCategory.value;
      final matchesSearch = item.name.toLowerCase()
          .contains(searchQuery.value.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    filteredItems.value = items;
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
    filterItems();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    filterItems();
  }

  Future<void> addMenuItem(MenuItem item) async {
    await _storage.create(StorageService.menuKey, item, (item) => item.toJson());
    loadMenuItems();
    loadCategories();
    Get.snackbar('Success', 'Menu item added successfully');
  }

  Future<void> updateMenuItem(MenuItem item) async {
    await _storage.update(
      StorageService.menuKey,
      item.id,
      item, (item) => item.toJson(),
    );
    loadMenuItems();
    Get.snackbar('Success', 'Menu item updated successfully');
  }

  Future<void> deleteMenuItem(String id) async {
    await _storage.delete(StorageService.menuKey, id);
    loadMenuItems();
    loadCategories();
    Get.snackbar('Success', 'Menu item deleted successfully');
  }

  Future<void> toggleAvailability(String id) async {
    final item = menuItems.firstWhere((item) => item.id == id);
    final updatedItem = item.copyWith(isAvailable: !item.isAvailable);
    await updateMenuItem(updatedItem);
  }

  Future<void> toggleSpecialOffer(String id) async {
    final item = menuItems.firstWhere((item) => item.id == id);
    final updatedItem = item.copyWith(isSpecialOffer: !item.isSpecialOffer);
    await updateMenuItem(updatedItem);
  }

  int get totalItems => menuItems.length;
  int get availableItems => menuItems.where((item) => item.isAvailable).length;
  int get specialOffers => menuItems.where((item) => item.isSpecialOffer).length;
}
