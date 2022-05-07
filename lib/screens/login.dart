import 'dart:developer';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_cap/screens/StartPage.dart';
import 'package:smart_cap/screens/registration.dart';
import 'package:smart_cap/widgets/CustomizedTextField.dart';
import 'package:smart_cap/widgets/GradientButton.dart';
import 'package:smart_cap/widgets/ProgressDialog.dart';

class LoginPage extends StatefulWidget {
  static const String id = '/login';

  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void login() async {
    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Logging you in',
      ),
    );

    final User user = (await _auth
            .signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
            .catchError((ex) {
      //check error and display message
      Navigator.pop(context);
      PlatformException thisEx = ex;
      showSnackBar(thisEx.message);
    }))
        .user;

    if (user != null) {
      // verify login
      DatabaseReference userRef =
          FirebaseDatabase.instance.reference().child('drivers/${user.uid}');
      userRef.once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, StartPage.id, (route) => false);
        }
      });
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
                const SizedBox(height: 50),
                SvgPicture.asset(
                  'images/karaz_logo.svg',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Karaz Drivers',
                  style: TextStyle(fontSize: 35),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      CustomizedTextField(
                        controller: emailController,
                        hint: 'Email address',
                        textInputType: TextInputType.emailAddress,
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      CustomizedTextField(
                        controller: passwordController,
                        hint: 'Password',
                        textInputType: TextInputType.emailAddress,
                        obscureText: true,
                      ),
                      const SizedBox(height: 60),
                      GradientButton(
                        title: 'LOGIN',
                        onPressed: () async {
                          //check network availability
                          log('massege');
                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            showSnackBar('No internet connectivity');
                            return;
                          }

                          if (!emailController.text.contains('@')) {
                            showSnackBar('Please enter a valid email address');
                            return;
                          }

                          if (passwordController.text.length < 8) {
                            showSnackBar('Please enter a valid password');
                            return;
                          }

                          login();
                        },
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, RegistrationPage.id, (route) => false);
                          },
                          child: const Text(
                            'Don\'t have an account, sign up here',
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
}
