import 'package:arlex_getx/presentation/home_screens.dart/indexed_stack.dart';
import 'package:get/get.dart';

import '../presentation/splash_screen/splash_screen.dart';

class RouteHelper{
  static const String splashScreen = "/splash-screen";
  static const String homeScreen = "/home-screen";

  static String getSplashScreen() => splashScreen;
  static String getHomeScreen() => homeScreen;

  static List<GetPage> routes  = [
    GetPage(
      name: splashScreen,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: homeScreen,
      page: () => const IndexedStackScreen(),
      transition: Transition.circularReveal,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}