import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/presentation/widget/button.dart';

class AccountNotVerifiedScreen extends StatelessWidget {
  const AccountNotVerifiedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
     
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning,
              size: 100,
              color: Colors.orange,
            ),
            SizedBox(height: 20),
            Text(
              'Your account is not verified yet.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
           
          ],
        ),
      ),
    );
  }
}
