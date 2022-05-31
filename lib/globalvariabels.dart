import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_cap/brand_colors.dart';
import 'package:smart_cap/datamodels/driver.dart';
import 'package:smart_cap/screens/UnRegistration.dart';
import 'package:smart_cap/screens/mainpage.dart';

User? currentFirebaseUser;

const CameraPosition googlePlex = CameraPosition(
  target: LatLng(31.954066, 35.931066),
  zoom: 14.4746,
);
String mapKey = 'AIzaSyALY906rdwqFYGffSyDo-j3OOAPdGUoscA';

StreamSubscription<Position>? homeTabPositionStream;

StreamSubscription<Position>? ridePositionStream;

String? driverCarStyle;

Position? currentPosition;

DatabaseReference? rideRef;

Driver? currentDriverInfo;

bool isAvailable = false;

String availabilityTitle = 'Go Online';

Color availabilityColor = BrandColors.colorAccent1;

DatabaseReference driversIsAvailableRef = FirebaseDatabase.instance
    .ref()
    .child('drivers/${currentFirebaseUser!.uid}/driversIsAvailable');

void getCurrentDriverInfo(context) async {
  // ignore: await_only_futures
  currentFirebaseUser = FirebaseAuth.instance.currentUser!;
  DatabaseReference driverRef = FirebaseDatabase.instance
      .ref()
      .child('drivers/${currentFirebaseUser!.uid}');
  driverRef.once().then((snapshot) {
    if (snapshot.snapshot.value != null) {
      //currentDriverInfo = Driver.fromSnapshot(snapshot);
      if (currentDriverInfo!.approveDriver == 'false') {
        Navigator.pushNamedAndRemoveUntil(
            context, UnRegistration.id, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, MainPage.id, (route) => false);
      }
    }
  });
}

// ignore: unused_local_variable
DatabaseReference tripRequestRef = FirebaseDatabase.instance
    .ref()
    .child('drivers/${currentFirebaseUser!.uid}/newtrip');

// ignore: non_constant_identifier_names
void GoOnline() {
  Geofire.initialize(currentDriverInfo!.taxiType!);
  Geofire.setLocation(currentFirebaseUser!.uid, currentPosition!.latitude,
      currentPosition!.longitude);

  tripRequestRef.set('waiting');

  tripRequestRef.onValue.listen((event) {});
}

// ignore: non_constant_identifier_names
void GoOffline() {
  Geofire.removeLocation(currentFirebaseUser!.uid);
  if (tripRequestRef.path.isNotEmpty) {
    tripRequestRef.onDisconnect();
  }
  tripRequestRef.remove();
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
void showSnackBar(String title) {
  final snackbar = SnackBar(
    content: Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 15),
    ),
  );
  // ignore: deprecated_member_use
  scaffoldKey.currentState!.showSnackBar(snackbar);
}
