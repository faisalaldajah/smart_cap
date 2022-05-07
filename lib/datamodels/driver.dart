import 'package:firebase_database/firebase_database.dart';

class Driver {
  String fullName;
  String email;
  String phone;
  String id;
  String carType;
  String carColor;
  String carNumber;
  String amount;
  String status;
  String currentAmount;
  // ignore: prefer_typing_uninitialized_variables
  var driversIsAvailable;
  // ignore: prefer_typing_uninitialized_variables
  var approveDriver;
  String taxiType;

  Driver({
    this.fullName,
    this.email,
    this.phone,
    this.id,
    this.carType,
    this.carColor,
    this.carNumber,
    this.status,
    this.amount,
    this.currentAmount,
    this.driversIsAvailable,
    this.approveDriver,
    this.taxiType,
  });

  Driver.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    phone = snapshot.value['phone'];
    email = snapshot.value['email'];
    fullName = snapshot.value['fullname'];
    carType = snapshot.value['carType'];
    carColor = snapshot.value['carColor'];
    carNumber = snapshot.value['carNumber'];
    amount = snapshot.value['amount']['amount'];
    status = snapshot.value['amount']['status'];
    currentAmount = snapshot.value['amount']['currentAmount'];
    driversIsAvailable = snapshot.value['driversIsAvailable'];
    approveDriver = snapshot.value['approveDriver'];
    taxiType = snapshot.value['taxiType'];
  }
}
