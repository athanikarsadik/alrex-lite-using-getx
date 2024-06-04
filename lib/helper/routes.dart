import 'package:arlex_getx/presentation/auth_screens.dart/login_screen.dart';
import 'package:arlex_getx/presentation/auth_screens.dart/sign_up_screen.dart';
import 'package:arlex_getx/presentation/home_screens.dart/indexed_stack.dart';
import 'package:get/get.dart';

import '../presentation/splash_screen/splash_screen.dart';

class RouteHelper {
  static const String splashScreen = "/splash-screen";
  static const String loginScreen = "/login-screen";
  static const String signUpScreen = "/signup-screen";
  static const String homeScreen = "/home-screen";

  static String getSplashScreen() => splashScreen;
  static String getLoginScreen() => loginScreen;
  static String getSignUpScreen() => signUpScreen;
  static String getHomeScreen() => homeScreen;

  static List<GetPage> routes = [
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
    GetPage(
      name: loginScreen,
      page: () => LoginScreen(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: signUpScreen,
      page: () => SignUpScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
