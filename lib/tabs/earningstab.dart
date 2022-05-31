import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_cap/screens/historypage.dart';
import 'package:smart_cap/widgets/BrandDivier.dart';

import '../brand_colors.dart';
import '../dataprovider.dart';

class EarningsTab extends StatelessWidget {
  const EarningsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: BrandColors.colorPrimary,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: [
                const Text(
                  'Total Earnings',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'JD ${Provider.of<AppData>(context).earnings}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontFamily: 'Brand-Bold',
                  ),
                )
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HistoryPage()));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            child: Row(
              children: [
                Image.asset(
                  'images/taxi.png',
                  width: 70,
                ),
                const SizedBox(
                  width: 16,
                ),
                const Text(
                  'Trips',
                  style: TextStyle(fontSize: 16),
                ),
                Expanded(
                    child: Text(
                  Provider.of<AppData>(context).tripCount.toString(),
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 18),
                )),
              ],
            ),
          ),
        ),
        const BrandDivider(),
      ],
    );
  }
}
