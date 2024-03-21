
import 'package:arlex_getx/controller/home_screen_controller.dart';
import 'package:arlex_getx/services/home_screen_service.dart';
import 'package:get/get.dart';

void init(){
  Get.put(HomeScreenController(homeScreenService: HomeScreenService()));
}