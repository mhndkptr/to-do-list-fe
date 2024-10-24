import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list_fe/app/controllers/auth_controller.dart';
import 'package:to_do_list_fe/app/controllers/todo_controller.dart';
import 'package:to_do_list_fe/app/models/todo_model.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AuthController authController = Get.put(AuthController());
  final TodoController todoController = Get.put(TodoController());
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    todoController.fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        backgroundColor: Colors.black54,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => _showAddTodoDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        if (todoController.todos.isEmpty) {
          return Center(child: Text('No To-Dos found'));
        } else {
          return ListView.builder(
            itemCount: todoController.todos.length,
            itemBuilder: (context, index) {
              final todo = todoController.todos[index];
              return ListTile(
                title: Text(todo.todo),
                subtitle: Text(todo.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(todo.isCompleted
                          ? Icons.check_box
                          : Icons.check_box_outline_blank),
                      onPressed: () {
                        todoController.updateTodo(
                          todo.id,
                          todo.todo,
                          todo.description,
                          !todo.isCompleted,
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showEditTodoDialog(context, todo),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        todoController.deleteTodo(todo.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }
      }),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            Get.offNamed('/profile');
          }
        },
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final TextEditingController todoFieldController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    bool isCompleted = false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Todo'),
          content: StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: todoFieldController,
                  decoration: InputDecoration(labelText: 'Todo'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                CheckboxListTile(
                  title: Text('Completed'),
                  value: isCompleted,
                  onChanged: (value) {
                    setState(() {
                      isCompleted = value!;
                    });
                  },
                ),
              ],
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                todoController.createTodo(
                  todoFieldController.text,
                  descriptionController.text,
                  isCompleted,
                );
                Get.back();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTodoDialog(BuildContext context, Todo todo) {
    final TextEditingController todoFieldController =
        TextEditingController(text: todo.todo);
    final TextEditingController descriptionController =
        TextEditingController(text: todo.description);
    bool isCompleted = todo.isCompleted;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Todo'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: todoFieldController,
                    decoration: InputDecoration(labelText: 'Todo'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  CheckboxListTile(
                    title: Text('Completed'),
                    value: isCompleted,
                    onChanged: (value) {
                      setState(() {
                        isCompleted = value!;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                todoController.updateTodo(
                  todo.id,
                  todoFieldController.text,
                  descriptionController.text,
                  isCompleted,
                );
                Get.back();
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
