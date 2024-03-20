import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';

class NurseDrawer extends StatelessWidget {
  const NurseDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('Nurse Name'),
              accountEmail: Text('Nurse@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/Nurse1.jpg'),
              ),
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
                Navigator.pushNamed(context, RouteName.uploadDocumentPageRoute);
              },
            ),
            ListTile(
              title: const Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onTap: () {
                // Navigate to settings screen or handle other actions
              },
            ),
            ListTile(
              title: const Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pushNamed(context, RouteName.aboutRoute);
              },
            ),
            ListTile(
              title: const Text('Logout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pushNamed(context, RouteName.welcomeRoute);
              },
            ),
          ],
        ),
      );
  }
}