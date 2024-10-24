import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:to_do_list_fe/app/models/todo_model.dart';
import 'package:to_do_list_fe/app/controllers/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoController extends GetxController {
  var todos = <Todo>[].obs;
  final AuthController authController = Get.find<AuthController>();

  Future<void> fetchTodos() async {
    final token = await authController.getToken();
    if (token == null) {
      _logout();
      return;
    }

    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/todos'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var todosData = jsonResponse['data']['todos'] as List;
      todos.value = todosData.map((todo) => Todo.fromJson(todo)).toList();
    } else if (response.statusCode == 403) {
      _logout();
      Get.snackbar('Error', 'Token expired');
      return;
    } else if (response.statusCode == 404) {
    } else {
      Get.snackbar('Error', 'Failed to load todos');
    }
  }

  Future<void> getTodoById(String id) async {
    final token = await authController.getToken();
    if (token == null) {
      _logout();
      return;
    }

    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/todos/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
    } else {
      Get.snackbar('Error', 'Failed to load todo');
    }
  }

  Future<void> createTodo(
      String todo, String description, bool isCompleted) async {
    final token = await authController.getToken();
    if (token == null) {
      _logout();
      return;
    }

    final response = await http.post(Uri.parse('http://10.0.2.2:4000/todos'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'todo': todo,
          'description': description,
          'isCompleted': isCompleted
        }));

    if (response.statusCode == 201) {
      fetchTodos();
    } else {
      Get.snackbar('Error', 'Failed to create todo');
    }
  }

  Future<void> updateTodo(
      int id, String todo, String description, bool isCompleted) async {
    final token = await authController.getToken();
    if (token == null) {
      _logout();
      return;
    }

    final response = await http.put(
      Uri.parse('http://10.0.2.2:4000/todos/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'todo': todo,
        'description': description,
        'isCompleted': isCompleted
      }),
    );

    if (response.statusCode == 200) {
      fetchTodos();
    } else {
      Get.snackbar('Error', 'Failed to update todo');
    }
  }

  Future<void> deleteTodo(int id) async {
    final token = await authController.getToken();
    if (token == null) {
      _logout();
      return;
    }

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:4000/todos/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      fetchTodos();
    } else {
      Get.snackbar('Error', 'Failed to delete todo');
    }
  }

  void _logout() {
    authController.logout();
    Get.offNamed('/login');
  }
}
