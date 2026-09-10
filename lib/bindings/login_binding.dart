import 'package:get/get.dart';
import 'package:saimpexwater_vendorapp/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
