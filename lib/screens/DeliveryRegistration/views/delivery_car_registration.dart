import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_cap/Services/translation_service.dart';
import 'package:smart_cap/screens/DeliveryRegistration/controllers/delivery_registration_controller.dart';
import 'package:smart_cap/widgets/CustomizedTextField.dart';
import 'package:smart_cap/widgets/myButton_widget.dart';

class DeliveryCarRegistration extends GetView<RegistrationController> {
  final GlobalKey<FormState> carForm = GlobalKey<FormState>();

  DeliveryCarRegistration({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Form(
        key: carForm,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Car Details'.tr,
              style: Get.textTheme.headline6!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ).paddingOnly(top: 10),
            CustomizedTextField(
              formatter: [
                LengthLimitingTextInputFormatter(100),
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Zا-ي ]'))
              ],
              textFieldController: controller.fullNameController.value,
              hint: 'fullname',
              textInputType: TextInputType.text,
              obscureText: false,
              validator: (value) => controller.authManager.commonTools
                  .nameValidate(controller.emailController.value),
            ),
            const SizedBox(height: 10),
            CustomizedTextField(
              formatter: [
                LengthLimitingTextInputFormatter(100),
                FilteringTextInputFormatter.allow(
                    RegExp('[a-zA-Z0-9@#&\$*-_%]'))
              ],
              textFieldController: controller.emailController.value,
              hint: 'email address',
              textInputType: TextInputType.emailAddress,
              obscureText: false,
              validator: (value) => controller.authManager.commonTools
                  .emailValidate(value, controller.emailController.value),
            ),
            const SizedBox(height: 10),
            CustomizedTextField(
              formatter: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.allow(RegExp('[0-9]'))
              ],
              textFieldController: controller.phoneController.value,
              hint: 'Phone Number',
              textInputType: TextInputType.phone,
              obscureText: false,
              validator: (value) => controller.authManager.commonTools
                  .phoneNumberValidate(controller.phoneController.value),
            ),
            const SizedBox(height: 10),
            CustomizedTextField(
              formatter: [
                LengthLimitingTextInputFormatter(15),
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Zا-ي]'))
              ],
              textFieldController: controller.carType.value,
              hint: 'carType',
              textInputType: TextInputType.text,
              obscureText: false,
              validator: (value) => controller.authManager.commonTools
                  .nameValidate(controller.phoneController.value),
            ),
            const SizedBox(height: 10),
            CustomizedTextField(
              formatter: [
                LengthLimitingTextInputFormatter(15),
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Zا-ي]'))
              ],
              textFieldController: controller.carModel.value,
              hint: 'carModel',
              textInputType: TextInputType.text,
              obscureText: false,
              validator: (value) => controller.authManager.commonTools
                  .nameValidate(controller.phoneController.value),
            ),
            const SizedBox(height: 10),
            CustomizedTextField(
              formatter: [
                LengthLimitingTextInputFormatter(15),
                FilteringTextInputFormatter.allow(RegExp('[0-9]'))
              ],
              textFieldController: controller.carFactory.value,
              hint: 'manufacturingyear',
              textInputType: TextInputType.phone,
              obscureText: false,
              validator: (value) => controller.authManager.commonTools
                  .phoneNumberValidate(controller.phoneController.value),
            ),
            const SizedBox(height: 10),
            CustomizedTextField(
              formatter: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.allow(RegExp('[0-9-]'))
              ],
              textFieldController: controller.plateNumber.value,
              hint: 'Vehicle plate numbers',
              textInputType: TextInputType.phone,
              obscureText: false,
              validator: (value) => controller.authManager.commonTools
                  .phoneNumberValidate(controller.phoneController.value),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: TranslationService().isLocaleArabic()
                  ? Alignment.bottomLeft
                  : Alignment.bottomRight,
              child: MyButtonWidget(
                  color: Get.theme.focusColor,
                  text: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next'.tr,
                        style: Get.textTheme.headline5!
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  width: Get.width * 0.4,
                  onPressed: () async {
                    controller.pageStep.value = 2;
                    // if (carForm.currentState!.validate()) {
                    //   controller.pageStep.value = 2;
                    // }
                  }),
            ).paddingOnly(top: 32),
          ],
        ),
      ),
    );
  }
}
