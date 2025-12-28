import 'package:flutter/material.dart';
import '../../core/Utils/snakbar_util.dart';
import '../../core/storage/model/todo.dart';
import '../controllers/menu_controller.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController textController = TextEditingController();
  late final TodoController controller;

  @override
  void initState() {
    super.initState();
    controller = TodoController();
    controller.init();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 800;
    final isTablet = screenWidth > 600 && screenWidth <= 800;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
        elevation: 0,
        toolbarHeight: isWideScreen ? 70 : 56,
        title: Row(
          children: [
            Icon(Icons.check_circle_outline, size: isWideScreen ? 32 : 24),
            SizedBox(width: 12),
            Text(
              'My Todos',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isWideScreen ? 24 : 20,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: false,
        actions: [
          // Show stats in app bar for wide screens
          if (isWideScreen)
            ValueListenableBuilder<List<Todo>>(
              valueListenable: controller.todos,
              builder: (context, todos, child) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _buildHeaderStat('Total', controller.totalCount.toString(), Colors.blue),
                      SizedBox(width: 32),
                      _buildHeaderStat('Completed', controller.completedCount.toString(), Colors.green),
                      SizedBox(width: 32),
                      _buildHeaderStat('Pending', controller.pendingCount.toString(), Colors.orange),
                      SizedBox(width: 20),
                    ],
                  ),
                );
              },
            ),

          IconButton(
            icon: Icon(Icons.delete_sweep),
            iconSize: isWideScreen ? 26 : 24,
            onPressed: () => _confirmDeleteAll(context),
            tooltip: 'Delete All Todos',
          ),
          SizedBox(width: isWideScreen ? 16 : 8),
        ],
      ),

      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isWideScreen ? 1200 : double.infinity,
          ),
          child: Column(
            children: [
              // Stats Card for mobile/tablet
              if (!isWideScreen)
                ValueListenableBuilder<List<Todo>>(
                  valueListenable: controller.todos,
                  builder: (context, todos, child) {
                    return _buildStatsCard(controller);
                  },
                ),

              // Inline Add Todo for Web
              if (isWideScreen)
                Container(
                  margin: EdgeInsets.fromLTRB(24, 20, 24, 16),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textController,
                          decoration: InputDecoration(
                            hintText: 'What needs to be done today?',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blue, width: 2),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            prefixIcon: Icon(Icons.edit_outlined, color: Colors.grey.shade400),
                          ),
                          style: TextStyle(fontSize: 16),
                          onSubmitted: (value) => _addTodoFromWeb(),
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: _addTodoFromWeb,
                        icon: Icon(Icons.add, size: 20),
                        label: Text(
                          'Add Todo',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Todo List
              Expanded(
                child: ValueListenableBuilder<List<Todo>>(
                  valueListenable: controller.todos,
                  builder: (context, todos, child) {
                    if (todos.isEmpty) {
                      return _buildEmptyState(isWideScreen);
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWideScreen ? 24 : 16,
                        vertical: 8,
                      ),
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        return _buildTodoCard(context, todo, isWideScreen);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // FAB only for mobile/tablet
      floatingActionButton: isWideScreen
          ? null
          : FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        elevation: 4,
      ),
    );
  }

  // Header stat for app bar
  Widget _buildHeaderStat(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Stats Card for mobile
  Widget _buildStatsCard(TodoController controller) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total', controller.totalCount.toString(), Colors.blue),
          _buildStatItem('Completed', controller.completedCount.toString(), Colors.green),
          _buildStatItem('Pending', controller.pendingCount.toString(), Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Empty state
  Widget _buildEmptyState(bool isWideScreen) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: isWideScreen ? 120 : 100,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 24),
          Text(
            'No todos yet!',
            style: TextStyle(
              fontSize: isWideScreen ? 24 : 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 12),
          Text(
            isWideScreen
                ? 'Add one using the input field above'
                : 'Tap the + button to add your first todo',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // Todo Card
  Widget _buildTodoCard(BuildContext context, Todo todo, bool isWideScreen) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: isWideScreen ? 20 : 12,
          vertical: isWideScreen ? 8 : 4,
        ),
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => controller.toggleComplete(context, todo.id),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          activeColor: Colors.green,
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted ? Colors.grey : Colors.black87,
            fontSize: isWideScreen ? 16 : 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, size: isWideScreen ? 22 : 20),
              color: Colors.blue,
              onPressed: () => _showEditDialog(context, todo.id, todo.title),
              tooltip: 'Edit',
            ),
            if (isWideScreen) SizedBox(width: 4),
            IconButton(
              icon: Icon(Icons.delete_outline, size: isWideScreen ? 22 : 20),
              color: Colors.red,
              onPressed: () => controller.deleteTodo(context, todo.id),
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }

  // Add todo from web input
  void _addTodoFromWeb() {
    if (textController.text.trim().isNotEmpty) {
      controller.addTodo(context, textController.text.trim());
      textController.clear();
    } else {
      SnackBarUtil.showError(context, 'Please enter a todo title');
    }
  }

  // Add Dialog for mobile
  void _showAddDialog(BuildContext context) {
    textController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Add New Todo'),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: 'Enter todo title',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (textController.text.trim().isNotEmpty) {
                  controller.addTodo(context, textController.text.trim());
                  Navigator.pop(context);
                } else {
                  SnackBarUtil.showError(context, 'Please enter a title');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Edit Dialog
  void _showEditDialog(BuildContext context, String id, String currentTitle) {
    textController.text = currentTitle;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Edit Todo'),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: 'Enter new title',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (textController.text.trim().isNotEmpty) {
                  controller.updateTodo(context, id, title: textController.text.trim());
                  Navigator.pop(context);
                } else {
                  SnackBarUtil.showError(context, 'Please enter a title');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Confirm Delete All
  void _confirmDeleteAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 12),
              Text('Delete All?'),
            ],
          ),
          content: Text('Are you sure you want to delete all todos? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.deleteAll(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Delete All'),
            ),
          ],
        );
      },
    );
  }
}