// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:arlex_getx/utils/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:arlex_getx/services/auth_service.dart';

class AuthController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confPassController = TextEditingController();

  RxBool loading = false.obs;

  final AuthService authService;
  AuthController({
    required this.authService,
  });

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confPassController.dispose();
  }

  Future<bool> loginUser() async {
    loading.value = true;
    try {
      String email = emailController.text.trim();
      String password = passController.text.trim();
      if (!email.isEmail) {
        CustomSnackbar.showError("Invalid Email!", "Enter proper email-id!");
        return false;
      } else if (password.length < 6) {
        CustomSnackbar.showError(
            "Weak Password!", "Password length should be greater than 6!");
        return false;
      } else {
        final user =
            await authService.signInWithEmailAndPassword(email, password);
        if (user != null) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      CustomSnackbar.showError("Authentication Failed", e.toString());
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<bool> signUpUser() async {
    loading.value = true;
    try {
      String name = nameController.text.trim();
      String email = emailController.text.trim();
      String password = passController.text.trim();
      String confPassword = confPassController.text.trim();
      if (!email.isEmail) {
        CustomSnackbar.showError("Invalid Email!", "Enter proper email-id!");
        return false;
      } else if (password.length < 6) {
        CustomSnackbar.showError(
            "Weak Password!", "Password length should be greater than 6!");
        return false;
      } else if (password != confPassword) {
        CustomSnackbar.showError(
            "Password Mismatch!", "Enter correct password!");
        return false;
      } else if (name.isEmpty) {
        CustomSnackbar.showError("Name required", "Enter your name!");
        return false;
      } else {
        final user = await authService.signUp(email, password);
        if (user != null) {
          await authService.saveUserDetails(name: name, uid: user.uid);
          CustomSnackbar.showSuccess(
              'Success', 'User registered successfully.');
          return true;
        } else {
          CustomSnackbar.showError('Error', 'Failed to register user.');
          return false;
        }
      }
    } catch (e) {
      CustomSnackbar.showError("Authentication Failed", e.toString());
      return false;
    } finally {
      loading.value = false;
    }
  }

  bool checkLoginStatus() {
    return authService.checkLoginStatus();
  }
}
