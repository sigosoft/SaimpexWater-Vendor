import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saimpexwater_vendorapp/controllers/home_controller.dart';
import 'package:saimpexwater_vendorapp/views/home/home_view.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final selectedLanguage = 'English'.obs;
  final isNavigating = false.obs;

  final languages = const ['English', 'Hindi', 'Tamil', 'Telugu'];

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void changeLanguage(String language) {
    selectedLanguage.value = language;
  }

  Future<void> login() async {
    if (isNavigating.value) return;
    isNavigating.value = true;

    FocusManager.instance.primaryFocus?.unfocus();
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (isClosed) return;

    // permanent: true prevents GetX SmartManagement from deleting HomeController
    // when the /login route is removed (that was crashing TextFields).
    if (Get.isRegistered<HomeController>()) {
      Get.delete<HomeController>(force: true);
    }
    Get.put<HomeController>(HomeController(), permanent: true);

    Get.offAll(
      () => const HomeView(),
      predicate: (_) => false,
      duration: Duration.zero,
    );
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
