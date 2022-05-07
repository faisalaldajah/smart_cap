
import 'package:flutter/material.dart';
import 'package:smart_cap/globalvariabels.dart';
import 'package:smart_cap/widgets/ProgressDialog.dart';

// ignore: use_key_in_widget_constructors
class StartPage extends StatefulWidget {
  static const String id = 'startPage';

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    getCurrentDriverInfo(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ProgressDialog(
          status: 'Loading',
        ),
      ),
    );
  }
}
