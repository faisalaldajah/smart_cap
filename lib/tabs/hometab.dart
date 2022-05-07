import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_cap/brand_colors.dart';
import 'package:smart_cap/helpers/helpermethods.dart';
import 'package:smart_cap/helpers/pushnotificationservice.dart';
import 'package:smart_cap/widgets/AvailabilityButton.dart';
import 'package:smart_cap/widgets/ConfirmSheet.dart';
import 'package:smart_cap/widgets/PermissionLocation.dart';
import '../globalvariabels.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GoogleMapController mapController;
  final Completer<GoogleMapController> _controller = Completer();

  var geoLocator = Geolocator();
  var locationOptions = const LocationOptions(
      accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 4);

  void getCurrentPosition() async {
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(pos));
  }

  void notificationData() {
    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize(context);
    pushNotificationService.getToken();

    HelperMethods.getHistoryInfo(context);
  }

  @override
  void initState() {
    super.initState();
    notificationData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          padding: const EdgeInsets.only(top: 135),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: googlePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            mapController = controller;
            getCurrentPosition();
          },
        ),
        Container(
          height: 135,
          width: double.infinity,
          color: BrandColors.colorPrimary,
        ),
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AvailabilityButton(
                title: availabilityTitle,
                color: availabilityColor,
                onPressed: () async {
                  if (await Permission
                      .locationWhenInUse.serviceStatus.isEnabled) {
                    showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (BuildContext context) => ConfirmSheet(
                        title: (!isAvailable) ? 'Go Online' : 'Go Offline',
                        subtitle: (!isAvailable)
                            ? 'You are about to become available to receive trip requests'
                            : 'you will stop receiving new trip requests',
                        onPressed: () {
                          if (!isAvailable && tripRequestRef != null) {
                            GoOnline();
                            getLocationUpdates();
                            setState(() {
                              availabilityColor = Colors.red;
                              availabilityTitle = 'Go Offline';
                              isAvailable = true;
                            });
                            driversIsAvailableRef.set(isAvailable);
                            Navigator.pop(context);
                          } else {
                            GoOffline();
                            Navigator.pop(context);
                            setState(() {
                              availabilityColor = BrandColors.colorAccent1;
                              availabilityTitle = 'Go Online';
                              isAvailable = false;
                            });
                            driversIsAvailableRef.set(isAvailable);
                          }
                        },
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) =>
                          const PermissionLocation(),
                    );
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  void getLocationUpdates() {
    homeTabPositionStream = geoLocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      currentPosition = position;

      if (isAvailable) {
        Geofire.setLocation(
            currentFirebaseUser.uid, position.latitude, position.longitude);
      }

      LatLng pos = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(pos));
    });
  }
}
