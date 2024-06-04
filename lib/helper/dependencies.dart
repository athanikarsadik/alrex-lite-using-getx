import 'package:arlex_getx/controller/auth_controller.dart';
import 'package:arlex_getx/controller/home_screen_controller.dart';
import 'package:arlex_getx/services/api_service.dart';
import 'package:arlex_getx/services/auth_service.dart';
import 'package:arlex_getx/services/home_screen_service.dart';
import 'package:get/get.dart';

Future<void> init() async {
  Get.put<ApiService>(ApiService(), permanent: true);
  Get.put(HomeScreenController(homeScreenService: HomeScreenService()));
  Get.lazyPut(() => AuthService());
  Get.put<AuthController>(AuthController(authService: Get.find<AuthService>()));
}
