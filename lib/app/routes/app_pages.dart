import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../auth/Login/bindings/login_binding.dart';
import '../auth/Login/views/login_view.dart';
import '../bottomBar/bottombar.dart';
import '../modules/addcontent/bindings/addcontent_binding.dart';
import '../modules/addcontent/views/addcontent_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/profil/bindings/profil_binding.dart';
import '../modules/profil/views/profil_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.ADDCONTENT,
      page: () => const AddcontentView(),
      binding: AddcontentBinding(),
    ),
  ];
}
