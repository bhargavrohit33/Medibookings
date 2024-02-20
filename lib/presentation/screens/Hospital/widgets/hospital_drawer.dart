import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';

class HospitalDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('John Doe'),
            accountEmail: Text('johndoe@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(nurseDemoImageURL),
            ),
          ),
         box("Doctor",(){
          Navigator.pushNamed(context, RouteName.hospital_doctorList_Screen);
         }),
          box("Profile",(){}),
          box("Setting",(){}),
        ],
      ),
    );
  }
Widget box(String title,VoidCallback onPressed){
  return ListTile(title: Text(title),onTap: onPressed,tileColor: Colors.transparent,);
}

}