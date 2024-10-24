import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list_fe/app/controllers/auth_controller.dart';
import 'package:to_do_list_fe/app/controllers/user_controller.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final UserController userController = Get.put(UserController());
  final AuthController authController = Get.put(AuthController());
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    userController.getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        backgroundColor: Colors.black54,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              authController.logout();
            },
          ),
        ],
      ),
      body: Obx(() {
        final userData = userController.userData;

        if (userData.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        final String name = userData['name'] ?? 'No Name';
        final String email = userData['email'] ?? 'No Email';

        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black12,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.black45,
                  ),
                ),
                SizedBox(height: 16),
                Column(
                  children: [
                    Text('$name', style: TextStyle(fontSize: 20)),
                    SizedBox(height: 8),
                    Text('$email', style: TextStyle(fontSize: 20)),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _showEditUserDialog(context, name, email),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    userController.deleteAccount().then((_) {
                      Get.offNamed('/login');
                    }).catchError((error) {
                      Get.snackbar('Error', 'Failed to delete account: $error');
                    });
                  },
                  child: Text(
                    'Delete Account',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                ),
              ],
            ),
          ),
        );
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
          if (index == 0) {
            Get.offNamed('/home');
          }
        },
      ),
    );
  }

  void _showEditUserDialog(
      BuildContext context, String currentName, String currentEmail) {
    final TextEditingController nameController =
        TextEditingController(text: currentName);
    final TextEditingController emailController =
        TextEditingController(text: currentEmail);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                userController
                    .updateDataUser(nameController.text, emailController.text)
                    .then((_) {
                  Get.back();
                  Get.snackbar('Success', 'Profile updated successfully');
                }).catchError((error) {
                  Get.snackbar('Error', 'Failed to update profile: $error');
                });
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
