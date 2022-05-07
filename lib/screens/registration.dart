import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_cap/brand_colors.dart';
import 'package:smart_cap/screens/StartPage.dart';
import 'package:smart_cap/widgets/GradientButton.dart';
import 'package:smart_cap/widgets/ProgressDialog.dart';
import '../globalvariabels.dart';
import 'login.dart';

class RegistrationPage extends StatefulWidget {
  static const String id = 'register';

  const RegistrationPage({Key key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<File> images = <File>[];
  List<Asset> images1 = <Asset>[];
  int noOfImagescanAdd = 5;
  String error = 'No Error Dectected';
  var fullNameController = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var socialAgentNumberController = TextEditingController();

  var carType = TextEditingController();

  var carNumberController = TextEditingController();

  var carColorController = TextEditingController();

  bool economy = false;
  bool taxi = false;
  void registerUser() async {
    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          ProgressDialog(status: 'جاري تسجيل الحساب'),
    );

    final User user = (await _auth
            .createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
            .catchError((ex) {
      Navigator.pop(context);
      showSnackBar('تحقق من الاسم او الرقم السري');
    }))
        .user;

    Navigator.pop(context);
    // check if user registration is successful
    if (user != null) {
      DatabaseReference newDriverRef =
          FirebaseDatabase.instance.reference().child('drivers/${user.uid}');
      DatabaseReference checkDriverRef = FirebaseDatabase.instance
          .reference()
          .child('approveDriver/${user.uid}');

      //Prepare data to be saved on users table
      Map userMap = {
        'fullname': fullNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'socialAgentNumber': socialAgentNumberController.text,
        'carType': carType.text,
        'driversIsAvailable': false,
        'carNumber': carNumberController.text,
        'carColor': carColorController.text,
        'approveDriver': 'false',
        'taxiType': driverCarStyle,
        'amount': {
          'amount': '0',
          'status': 'wait',
          'currentAmount': '0',
          'transNumber': '0'
        }
      };
      Map checkDriverMap = {
        'isApproveDriver': 'false',
      };
      checkDriverRef.set(checkDriverMap);
      newDriverRef.set(userMap);

      currentFirebaseUser = user;

      //Take the user to the mainPage
      Navigator.pushNamedAndRemoveUntil(
          context, StartPage.id, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                const Image(
                  alignment: Alignment.center,
                  height: 280.0,
                  width: 280.0,
                  image: AssetImage('images/task.png'),
                ),
                const Text('Choose as Taxi or Economy'),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 90,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: (economy)
                                  ? BrandColors.colorAccent
                                  : Colors.white,
                              // ignore: prefer_const_literals_to_create_immutables
                              boxShadow: [
                                const BoxShadow(
                                  blurRadius: 2,
                                  spreadRadius: 0.3,
                                  color: BrandColors.colorDimText,
                                ),
                              ],
                            ),
                            child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    driverCarStyle = 'economyAvailable';
                                    economy = true;
                                    taxi = false;
                                  });
                                },
                                child: Center(
                                  child: Image.asset('images/taxi.png'),
                                )),
                          ),
                          const SizedBox(height: 7),
                          const Text('Economy'),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          Container(
                            width: 90,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: (taxi)
                                  ? BrandColors.colorAccent
                                  : Colors.white,
                              // ignore: prefer_const_literals_to_create_immutables
                              boxShadow: [
                                const BoxShadow(
                                  blurRadius: 2,
                                  spreadRadius: 0.3,
                                  color: BrandColors.colorDimText,
                                ),
                              ],
                            ),
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  driverCarStyle = 'driversAvailable';
                                  economy = false;
                                  taxi = true;
                                });
                              },
                              child: Center(
                                child: Image.asset('images/taxi1.png'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text('Taxi'),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      // Fullname
                      TextField(
                        controller: fullNameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'الاسم كامل',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // Email Address
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelText: 'الايميل',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      // Phone
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            labelText: 'رقم الهاتق',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      // Password
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'رقم السري',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      TextField(
                        controller: carType,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'نوع السيارة',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: socialAgentNumberController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'رقم الوطني',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: carNumberController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'رقم السيارة',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: carColorController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'لون السيارة',
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: const <Widget>[
                          Icon(
                            Icons.image_sharp,
                            color: BrandColors.colorAccent,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'اضف صورة لرخصة السيارة',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: images.isNotEmpty,
                        child: Container(
                            height: MediaQuery.of(context).size.width * 0.43,
                            width: MediaQuery.of(context).size.width * 0.86,
                            margin: const EdgeInsets.only(bottom: 30.0),
                            child: Center(
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.38,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: images.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Stack(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  child: Image.file(
                                                    images[index],
                                                  ),
                                                ),
                                              ),
                                              Positioned.fill(
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.38,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      15.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned.fill(
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        images.removeAt(index);
                                                      });
                                                      noOfImagescanAdd += 1;
                                                    },
                                                    child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      margin:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: const CircleAvatar(
                                                        backgroundColor:
                                                            Colors.grey,
                                                        radius: 40,
                                                        child:
                                                            Icon(Icons.delete),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Visibility(
                                    visible: noOfImagescanAdd >= 0,
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 5.0),
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.38,
                                      width: noOfImagescanAdd == 5
                                          ? MediaQuery.of(context).size.width *
                                              0.76
                                          : MediaQuery.of(context).size.width *
                                              0.38,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            238, 238, 238, 1),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                        border: Border.all(
                                          width: 0.9,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                              child: Align(
                                            alignment: Alignment.center,
                                            child: images.isEmpty
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                          onPressed: () {},
                                                          icon: const Icon(
                                                              Icons.add)),
                                                      const Text('Add images'),
                                                    ],
                                                  )
                                                : Center(
                                                    child: IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                            Icons.add)),
                                                  ),
                                          )),
                                          Positioned.fill(
                                            child: GestureDetector(
                                              onTap: () async {
                                                FocusScopeNode currentFocus =
                                                    FocusScope.of(context);
                                                if (!currentFocus
                                                    .hasPrimaryFocus) {
                                                  currentFocus.unfocus();
                                                }
                                                await loadImagesAssets();
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),

                      Visibility(
                        visible: images.isNotEmpty,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 60,
                              decoration: BoxDecoration(
                                color: BrandColors.colorAccent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Material(
                                color: BrandColors.colorAccent,
                                borderRadius: BorderRadius.circular(30),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(30),
                                  onTap: loadImagesAssets,
                                  child: const Center(
                                    child: Text(
                                      'Select',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 40,
                      ),
                      GradientButton(
                        title: 'تسجيل',
                        onPressed: () async {
                          //check network availability
                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            showSnackBar('No internet connectivity');
                            return;
                          }
                          if (fullNameController.text.length < 3) {
                            showSnackBar('Please provide a valid fullname');
                            return;
                          }
                          if (phoneController.text.length < 10) {
                            showSnackBar('Please provide a valid phone number');
                            return;
                          }
                          if (!emailController.text.contains('@')) {
                            showSnackBar(
                                'Please provide a valid email address');
                            return;
                          }
                          if (passwordController.text.length < 8) {
                            showSnackBar(
                                'password must be at least 8 characters');
                            return;
                          }
                          if (driverCarStyle == null) {
                            showSnackBar('please choose Taxi or economy');
                            return;
                          }
                          registerUser();
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, LoginPage.id, (route) => false);
                          },
                          child: const Text(
                            'you have an account, Login here',
                            style: TextStyle(color: Colors.black),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadImagesAssets() async {
    try {
      await MultiImagePicker.pickImages(
        maxImages: noOfImagescanAdd,
        enableCamera: true,
        selectedAssets: images1,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: 'chat',
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: '#339A58',
          statusBarColor: '#339A58',
          allViewTitle: 'All Photos',
          useDetailsView: false,
          selectCircleStrokeColor: '#339A58',
        ),
      ).then((value) {
        // ignore: avoid_function_literals_in_foreach_calls
        value.forEach((assetFile) async {
          var bytes = await assetFile.getByteData();
          String dir = (await getApplicationDocumentsDirectory()).path;
          await writeToFile(bytes, '$dir/${assetFile.name}.jpg');
          File tempFile = File('$dir/${assetFile.name}.jpg');
          setState(() {
            images.add(tempFile);
          });

          noOfImagescanAdd -= 1;
        });
      });
    } on Exception catch (e) {
      error = e.toString();
    }
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}
