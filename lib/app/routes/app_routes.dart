import 'package:get/get.dart';
import 'package:to_do_list_fe/app/views/home_view.dart';
import 'package:to_do_list_fe/app/views/profile_view.dart';
import 'package:to_do_list_fe/app/views/login_view.dart';
import 'package:to_do_list_fe/app/views/register_view.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/login', page: () => LoginView()),
    GetPage(name: '/register', page: () => RegisterView()),
    GetPage(name: '/home', page: () => HomeView()),
    GetPage(name: '/profile', page: () => ProfileView()),
  ];
}
