import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_cap/brand_colors.dart';
import 'package:smart_cap/globalvariabels.dart';
import 'package:smart_cap/widgets/Dialogs.dart';
import 'package:smart_cap/widgets/GradientButton.dart';

class AmountDetail extends StatefulWidget {
  const AmountDetail({Key key, this.amount}) : super(key: key);
  final String amount;

  @override
  _AmountDetailState createState() => _AmountDetailState();
}

class _AmountDetailState extends State<AmountDetail> {
  var transNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.colorBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 90,
              width: double.infinity,
            ),
            const Text(
              'قم بتعبئة رقم الحوالة حتى يتم تعبئة الرصيد',
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.all(40),
              child: TextField(
                controller: transNumberController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    labelText: 'رقم الحوالة',
                    labelStyle: TextStyle(
                      fontSize: 14.0,
                    ),
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0)),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'في حال لم يتم تعبئة الرصيد خلال 12 ساعة يحق لك المطالبة بالمبلغ الذي حولته على نفس الرقم',
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 80),
            GradientButton(
              title: 'تأكيد',
              onPressed: addAmount,
            )
          ],
        ),
      ),
    );
  }

  void addAmount() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const Dialogs(),
    );
    if (transNumberController.text.length < 5) {
      //showSnackBar('Please provide a valid number');
      return;
    } else {
      DatabaseReference amountRef = FirebaseDatabase.instance
          .reference()
          .child('drivers/${currentFirebaseUser.uid}/amount');
      Map userAmount = {
        'transNumber': transNumberController.text,
        'amount': widget.amount,
        'status': 'not approved'
      };

      amountRef.set(userAmount);
    }
  }
}
