import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/presentation/widget/images_widgets.dart';
import 'package:medibookings/service/auth_service.dart';
import 'package:medibookings/service/nurse/nurse_service.dart';
import 'package:provider/provider.dart';

class NurseDrawer extends StatelessWidget {
  const NurseDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context);
    final _nurseService = Provider.of<NurseService>(context);
    return Drawer(
        child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
             UserAccountsDrawerHeader(
              accountName: Text(capitalizeFirstLetter(_nurseService.nurseModel!.firstName).toString() +" " + capitalizeFirstLetter(_nurseService.nurseModel!.lastName)),
              accountEmail: ClipOval(child: Text(_nurseService.firebaseAuth.currentUser!.email.toString())),
              currentAccountPicture: ClipOval(child: ImageWithPlaceholder(height: 100,width: 100,imageUrl: _nurseService.nurseModel!.profileUrl!,))
            ),
            ListTile(
              title: const Text('Set charge', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pushNamed(context, RouteName.setChargeRoute);
              },
            ),
            ListTile(
              title: const Text('Set Availability', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pushNamed(context, RouteName.setAvailabilityRoute);
              },
            ),
            ListTile(
              title: const Text('Upload Documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pushNamed(context, RouteName.uploadDocumentPageRoute,arguments: true);
              },
            ),
            // ListTile(
            //   title: const Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            //   onTap: () {
            //    Navigator.pushNamed(context, RouteName.nurseSettingPage);
            //   },
            // ),
            ListTile(
              title: const Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pushNamed(context, RouteName.aboutRoute);
              },
            ),
            ListTile(
              title: const Text('Logout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onTap: () async {
              await _authService.logout();
              },
            ),
          ],
        ),
      );
  }
}