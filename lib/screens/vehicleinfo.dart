import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_cap/screens/mainpage.dart';
import 'package:smart_cap/widgets/TaxiButton.dart';

import '../brand_colors.dart';
import '../globalvariabels.dart';

// ignore: must_be_immutable
class VehicleInfoPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  VehicleInfoPage({Key key}) : super(key: key);

  void showSnackBar(String title) {
    final snackbar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
    );
    // ignore: deprecated_member_use
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  static const String id = 'vehicleinfo';

  var carModelController = TextEditingController();
  var carColorController = TextEditingController();
  var vehicleNumberController = TextEditingController();

  void updateProfile(context) {
    String id = currentFirebaseUser.uid;
    DatabaseReference driverRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/$id/vehicle_details');

    Map map = {
      'car_color': carColorController.text,
      'car_model': carModelController.text,
      'vehicle_number': vehicleNumberController.text,
    };

    driverRef.set(map);

    Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              Image.asset(
                'images/logo.png',
                height: 100,
                width: 100,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Enter vehicle details',
                      style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 22),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: carModelController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: 'Car model',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: carColorController,
                      decoration: const InputDecoration(
                          labelText: 'Car color',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: vehicleNumberController,
                      maxLength: 11,
                      decoration: const InputDecoration(
                          counterText: '',
                          labelText: 'Vehicle number',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(height: 40.0),
                    TaxiButton(
                      color: BrandColors.colorGreen,
                      title: 'PROCEED',
                      onPressed: () {
                        if (carModelController.text.length < 3) {
                          showSnackBar('Please provide a valid car model');
                          return;
                        }

                        if (carColorController.text.length < 3) {
                          showSnackBar('Please provide a valid car color');
                          return;
                        }

                        if (vehicleNumberController.text.length < 3) {
                          showSnackBar('Please provide a valid vehicle number');
                          return;
                        }

                        updateProfile(context);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
