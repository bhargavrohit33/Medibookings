import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/service/auth_service.dart';
import 'package:provider/provider.dart';

class AccountNotVerifiedScreen extends StatelessWidget {
  const AccountNotVerifiedScreen({super.key});
  @override
  Widget build(BuildContext context) {
     final _authProvider = Provider.of<AuthService>(context );
    return  Scaffold(
     
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          const  Icon(
              Icons.warning,
              size: 100,
              color: Colors.orange,
            ),
          const  SizedBox(height: 20),
           const Text(
              'Your account is not verified yet.',
              style: TextStyle(fontSize: 18),
            ),
           const SizedBox(height: 10),
            basicButton(onPressed: ()async{
              await _authProvider.logout();
            }, text: 'Log out')
           
           
          ],
        ),
      ),
    );
  }
}
