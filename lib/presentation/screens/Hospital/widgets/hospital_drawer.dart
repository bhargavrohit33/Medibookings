import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/service/auth_service.dart';
import 'package:provider/provider.dart';

class HospitalDrawer extends StatelessWidget {
  const HospitalDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthService>(context );
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text('John Doe'),
            accountEmail: const Text('johndoe@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(nurseDemoImageURL),
            ),
          ),
         box("Doctor",(){
          Navigator.pushNamed(context, RouteName.hospital_doctorList_Screen);
         }),
          box("Profile",(){}),
          box("Setting",(){}),
          box("Log out",(){provider.logout();}),
        ],
      ),
    );
  }
Widget box(String title,VoidCallback onPressed){
  return ListTile(title: Text(title),onTap: onPressed,tileColor: Colors.transparent,);
}

}