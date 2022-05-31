import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_cap/brand_colors.dart';
import 'package:smart_cap/datamodels/tripdetails.dart';
import 'package:smart_cap/globalvariabels.dart';
import 'package:smart_cap/helpers/helpermethods.dart';
import 'package:smart_cap/screens/newtripspage.dart';
import 'package:smart_cap/widgets/BrandDivier.dart';
import 'package:smart_cap/widgets/ProgressDialog.dart';
import 'package:smart_cap/widgets/TaxiButton.dart';
class NotificationDialog extends StatelessWidget {
  final TripDetails tripDetails;

  const NotificationDialog({Key? key,required this.tripDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 30.0,
            ),
            Image.asset(
              'images/taxi.png',
              width: 100,
            ),
            const SizedBox(
              height: 16.0,
            ),
            const Text(
              'NEW TRIP REQUEST',
              style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 18),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        'images/pickicon.png',
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Expanded(
                          child: Text(
                        tripDetails.pickupAddress!,
                        style: const TextStyle(fontSize: 18),
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        'images/desticon.png',
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Expanded(
                          child: Text(
                        tripDetails.destinationAddress!,
                        style: const TextStyle(fontSize: 18),
                      ))
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const BrandDivider(),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TaxiButton(
                      title: 'DECLINE',
                      color: BrandColors.colorPrimary,
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TaxiButton(
                      title: 'ACCEPT',
                      color: BrandColors.colorGreen,
                      onPressed: () async {
                        checkAvailablity(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  void checkAvailablity(context) {
    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Accepting request',
      ),
    );

    DatabaseReference newRideRef = FirebaseDatabase.instance
        .ref()
        .child('drivers/${currentFirebaseUser!.uid}/newtrip');
    newRideRef.once().then((snapshot) {
      Navigator.pop(context);
      Navigator.pop(context);

      String thisRideID = '';
      if (snapshot.snapshot.value != null) {
        thisRideID = snapshot.snapshot.value.toString();
      } else {
        // Toast.show('Ride not found', context,
        //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }

      if (thisRideID == tripDetails.rideID) {
        newRideRef.set('accepted');
        HelperMethods.disableHomTabLocationUpdates();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewTripPage(
                tripDetails: tripDetails,
              ),
            ));
      } else if (thisRideID == 'cancelled') {
        // Toast.show('Ride has been cancelled', context,
        //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else if (thisRideID == 'timeout') {
        // Toast.show('Ride has timed out', context,
        //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        // Toast.show('Ride not found', context,
        //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }
}
