import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'auth_controller.dart';

class UserController extends GetxController {
  final AuthController authController = Get.put(AuthController());
  var userData = {}.obs;

  Future<void> getDataUser() async {
    final token = await authController.getToken();
    final id = await authController.getUserId();
    if (token == null) {
      authController.logout();
      return;
    }

    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/users/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      userData.value = jsonDecode(response.body)['data']['user'];
    } else if (response.statusCode == 403) {
      Get.snackbar('Error', 'Token expired');
      authController.logout();
    } else {
      userData.value = {};
      Get.snackbar('Error', 'Something Went Wrong!');
    }
  }

  Future<void> updateDataUser(String name, String email) async {
    final token = await authController.getToken();
    final id = await authController.getUserId();
    if (token == null) {
      authController.logout();
      return;
    }

    final response = await http.put(
      Uri.parse('http://10.0.2.2:4000/users/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
      }),
    );

    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      userData['name'] = name;
      userData['email'] = email;
    } else if (response.statusCode == 403) {
      Get.snackbar('Error', 'Token expired');
      authController.logout();
    } else {
      Get.snackbar('Error', 'Failed to update user data');
      throw Exception('Failed to update user data');
    }
  }

  Future<void> deleteAccount() async {
    final token = await authController.getToken();
    final id = await authController.getUserId();
    if (token == null) {
      authController.logout();
      return;
    }

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:4000/users/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      userData.value = {};
      Get.offNamed('/login');
    } else if (response.statusCode == 403) {
      Get.snackbar('Error', 'Token expired');
      authController.logout();
    } else {
      Get.snackbar('Error', 'Failed to delete account');
      throw Exception('Failed to delete account');
    }
  }
}
