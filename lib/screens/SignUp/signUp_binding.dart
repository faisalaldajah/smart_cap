// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:smart_cap/screens/SignUp/SignUp_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(() => SignUpController());
  }
}
