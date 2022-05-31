import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_cap/Services/translation_service.dart';
import 'package:smart_cap/screens/DeliveryRegistration/controllers/delivery_registration_controller.dart';
import 'package:smart_cap/screens/DeliveryRegistration/widgets/documents/car_front_image.dart';
import 'package:smart_cap/screens/DeliveryRegistration/widgets/documents/car_license_copy.dart';
import 'package:smart_cap/screens/DeliveryRegistration/widgets/documents/car_rear_image.dart';
import 'package:smart_cap/screens/DeliveryRegistration/widgets/documents/driving_license_copy.dart';
import 'package:smart_cap/widgets/myButton_widget.dart';

import '../widgets/documents/personal_image_doc.dart';

class DeliveryDocumentsRegistration extends GetView<RegistrationController> {
  final GlobalKey<FormState> documentsForm = GlobalKey<FormState>();

  DeliveryDocumentsRegistration({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Form(
      key: documentsForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Documents'.tr,
              style: Get.textTheme.headline6!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
          Text('Personal image'.tr + '*',
              style: Get.textTheme.headline6!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )).paddingOnly(top: 25),
          PersonalImageDoc(),
          Text(
            '(Must have a white background &without any filter)'.tr,
            style: Get.textTheme.headline6!.copyWith(
              height: 1.5,
              color: Get.theme.focusColor,
            ),
          ).paddingOnly(top: 12),
          Text('acopyofthedrivinglicense'.tr + '*',
                  style: Get.textTheme.headline6!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold))
              .paddingOnly(top: 25),
          DrivingLicenseCopy(),
          Text('clearfrontimageforthevehicle'.tr + '*',
                  style: Get.textTheme.headline6!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold))
              .paddingOnly(top: 25),
          CarFrontImage(),
          Text('clearrearimageforthevehicle'.tr + '*',
                  style: Get.textTheme.headline6!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold))
              .paddingOnly(top: 25),
          CarRearImage(),
          Text('acopyofthecarlicense'.tr + '*',
                  style: Get.textTheme.headline6!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold))
              .paddingOnly(top: 25),
          CarLicenseCopy(),
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
                  FirebaseStorage storage = FirebaseStorage.instance;
                  DatabaseReference addCarRef = FirebaseDatabase.instance
                      .ref()
                      .child('driversDetails')
                      .push();
                  String url = await storage
                      .ref()
                      .child(
                          'driversDetails/${Uri.file(controller.personalImageFile.value.path).pathSegments.last}.jpg')
                      .getDownloadURL()
                      .catchError((e) {
                    log(e.toString());
                  });
                  print(url);
                  addCarRef.set(url);
                }),
          ).paddingOnly(top: 32),
        ],
      ),
    );
  }
}
