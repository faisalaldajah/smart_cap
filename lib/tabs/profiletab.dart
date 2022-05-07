import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_cap/brand_colors.dart';
import 'package:smart_cap/globalvariabels.dart';
import 'package:smart_cap/screens/AddAmount.dart';
import 'package:smart_cap/screens/login.dart';
import 'package:smart_cap/widgets/GradientButton.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 250,
              decoration: const BoxDecoration(color: BrandColors.colorAccent1),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '5.00JD',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'الرصيد الحالي',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 100,
                  color: BrandColors.colorAccent1,
                ),
                const SizedBox(height: 10),
                Text(
                  currentDriverInfo.fullName,
                  style: const TextStyle(fontSize: 30, color: Colors.black),
                ),
                const SizedBox(height: 20),
                Text(
                  currentDriverInfo.carType,
                  style: const TextStyle(fontSize: 23, color: Colors.black),
                ),
                const SizedBox(height: 20),
                Text(
                  currentDriverInfo.carColor,
                  style: const TextStyle(fontSize: 23, color: Colors.black),
                ),
                const SizedBox(height: 50),
                GradientButton(
                  title: 'إضافة رصيد',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddAmount(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
                TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginPage.id, (route) => false);
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
