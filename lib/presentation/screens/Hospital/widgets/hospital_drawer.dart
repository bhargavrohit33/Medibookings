import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/service/auth_service.dart';
import 'package:medibookings/service/hospital/hospital_service.dart';
import 'package:provider/provider.dart';

class HospitalDrawer extends StatelessWidget {
  const HospitalDrawer({super.key});

  @override
  Widget build(BuildContext context) {
  
    final authProvider = Provider.of<AuthService>(context );
    final hospitalProvider = Provider.of<HospitalService>(context );
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName:  Text(hospitalProvider.hospitalModel!.name),
            accountEmail:  Text(hospitalProvider.hospitalModel!.email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(nurseDemoImageURL),
            ),
          ),
         box("Doctor",(){
          Navigator.pushNamed(context, RouteName.hospital_doctorList_Screen);
         }),
          box("Profile",(){
            Navigator.pushNamed(context, RouteName.hospital_profile_update);
          }),
          box("Privacy & Policy",(){
         }),
         box("Contact us",(){
         }),
         

          box("Log out",()async{
            
            await authProvider.logout();
             hospitalProvider.dispose();}),
        ],
      ),
    );
  }
Widget box(String title,VoidCallback onPressed){
  return ListTile(title: Text(title),onTap: onPressed,tileColor: Colors.transparent,);
}

}