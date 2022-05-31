import 'package:get/get.dart';
import 'package:smart_cap/Services/AuthenticationService/Core/manager.dart';
import 'package:smart_cap/screens/LogIn/login_controller.dart';

class LogInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogInController>(() => LogInController());
    Get.lazyPut<AuthenticationManager>(() => AuthenticationManager());
  }
}
