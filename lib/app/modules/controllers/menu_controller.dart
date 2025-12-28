// // lib/controllers/todo_controller.dart
//
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
//
// import '../../core/storage/model/todo.dart';
//
// class TodoController extends GetxController {
//   // GetStorage instance
//   final storage = GetStorage();
//
//   // Storage key
//   final String storageKey = 'todos';
//
//   // Observable list - automatically updates UI
//   var todos = <Todo>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadTodos(); // Load data when controller starts
//   }
//
//   // ==================== CREATE ====================
//   void addTodo(String title) {
//     // 1. Create new todo
//     final newTodo = Todo(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       title: title,
//     );
//
//     // 2. Add to list
//     todos.add(newTodo);
//
//     // 3. Save to storage
//     _saveToStorage();
//
//     // 4. Show success message
//     Get.snackbar('Success', 'Todo added!');
//   }
//
//   // ==================== READ ====================
//   void loadTodos() {
//     // 1. Read from storage
//     List<dynamic>? data = storage.read(storageKey);
//
//     // 2. Check if data exists
//     if (data == null || data.isEmpty) {
//       todos.value = [];
//       return;
//     }
//
//     // 3. Convert JSON to Todo objects
//     todos.value = data
//         .map((json) => Todo.fromJson(json as Map<String, dynamic>))
//         .toList();
//   }
//
//   // ==================== UPDATE ====================
//   void updateTodo(String id, {String? title, bool? isCompleted}) {
//     // 1. Find todo by id
//     int index = todos.indexWhere((todo) => todo.id == id);
//
//     if (index != -1) {
//       // 2. Update the todo
//       todos[index] = todos[index].copyWith(
//         title: title,
//         isCompleted: isCompleted,
//       );
//
//       // 3. Save to storage
//       _saveToStorage();
//
//       // 4. Show success message
//       Get.snackbar('Success', 'Todo updated!');
//     }
//   }
//
//   // Toggle completed status
//   void toggleComplete(String id) {
//     int index = todos.indexWhere((todo) => todo.id == id);
//     if (index != -1) {
//       updateTodo(id, isCompleted: !todos[index].isCompleted);
//     }
//   }
//
//   // ==================== DELETE ====================
//   void deleteTodo(String id) {
//     // 1. Remove from list
//     todos.removeWhere((todo) => todo.id == id);
//
//     // 2. Save to storage
//     _saveToStorage();
//
//     // 3. Show success message
//     Get.snackbar('Success', 'Todo deleted!');
//   }
//
//   // Delete all
//   void deleteAll() {
//     todos.clear();
//     _saveToStorage();
//     Get.snackbar('Success', 'All todos deleted!');
//   }
//
//   // ==================== HELPER METHOD ====================
//   void _saveToStorage() {
//     // Convert all todos to JSON and save
//     List<Map<String, dynamic>> jsonList =
//     todos.map((todo) => todo.toJson()).toList();
//
//     storage.write(storageKey, jsonList);
//   }
//
//   // ==================== GETTERS ====================
//   int get totalCount => todos.length;
//
//   int get completedCount =>
//       todos.where((todo) => todo.isCompleted).length;
//
//   int get pendingCount =>
//       todos.where((todo) => !todo.isCompleted).length;
// }

import 'package:flutter/material.dart';
import '../../core/Utils/snakbar_util.dart';
import '../../core/storage/model/todo.dart';
import '../../core/storage/storage_service.dart';

class TodoController {
  // Storage key
  static const String storageKey = 'todos';

  // Observable list - use ValueNotifier for reactivity
  final ValueNotifier<List<Todo>> todos = ValueNotifier([]);

  // Storage service instance
  final StorageService _storageService = StorageService();

  // Initialize controller
  void init() {
    loadTodos();
  }

  // ==================== CREATE ====================
  void addTodo(BuildContext context, String title) {
    // 1. Create new todo
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    );

    // 2. Add to list
    todos.value = [...todos.value, newTodo];

    // 3. Save to storage using StorageService
    _storageService.create<Todo>(
      storageKey,
      newTodo,
          (todo) => todo.toJson(),
    );

    // 4. Show success message
    SnackBarUtil.showSuccess(context, 'Todo added!');
  }

  // ==================== READ ====================
  void loadTodos() {
    // 1. Read from storage using StorageService
    todos.value = _storageService.readAll<Todo>(
      storageKey,
          (json) => Todo.fromJson(json),
    );
  }

  // ==================== UPDATE ====================
  void updateTodo(BuildContext context, String id, {String? title, bool? isCompleted}) {
    // 1. Find todo by id
    int index = todos.value.indexWhere((todo) => todo.id == id);

    if (index != -1) {
      // 2. Update the todo
      todos.value = todos.value.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(
            title: title,
            isCompleted: isCompleted,
          );
        }
        return todo;
      }).toList();

      // 3. Save to storage using StorageService
      _storageService.update<Todo>(
        storageKey,
        id,
        todos.value.firstWhere((todo) => todo.id == id),
            (todo) => todo.toJson(),
      );

      // 4. Show success message
      SnackBarUtil.showSuccess(context, 'Todo updated!');
    }
  }

  // Toggle completed status
  void toggleComplete(BuildContext context, String id) {
    int index = todos.value.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      updateTodo(context, id, isCompleted: !todos.value[index].isCompleted);
    }
  }

  // ==================== DELETE ====================
  void deleteTodo(BuildContext context, String id) {
    // 1. Remove from list
    todos.value = todos.value.where((todo) => todo.id != id).toList();

    // 2. Save to storage using StorageService
    _storageService.delete(storageKey, id);

    // 3. Show success message
    SnackBarUtil.showSuccess(context, 'Todo deleted!');
  }

  // Delete all
  void deleteAll(BuildContext context) {
    todos.value = [];
    _storageService.deleteAll(storageKey);
    SnackBarUtil.showSuccess(context, 'All todos deleted!');
  }

  // ==================== GETTERS ====================
  int get totalCount => todos.value.length;

  int get completedCount =>
      todos.value.where((todo) => todo.isCompleted).length;

  int get pendingCount =>
      todos.value.where((todo) => !todo.isCompleted).length;
}
