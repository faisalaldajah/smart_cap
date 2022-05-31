import 'package:get/get.dart';
import 'package:smart_cap/screens/DeliveryRegistration/controllers/delivery_registration_controller.dart';

class RegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegistrationController>(
      () => RegistrationController(),
    );
  }
}
