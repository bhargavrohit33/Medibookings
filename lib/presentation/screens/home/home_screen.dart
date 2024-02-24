import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlue,
              ),
              child: Text(
                'Nurse Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // Navigate to settings screen or handle other actions
              },
            ),
            ListTile(
              title: const Text('About'),
              onTap: () {
                // Navigate to about screen or handle other actions
              },
            ),
            // Add more list tiles or widgets for profile information
          ],
        ),
      ),
      body: const Center(
        child: Text('Main Content'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.maps_home_work_sharp),
            label: 'Set Charge',
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0: // Home
              Navigator.pushNamed(context, RouteName.homePageRoute);
              break;
            case 1: // Appointments
              Navigator.pushNamed(context, RouteName.appointmentPageRoute);
              break;
            case 2: // Nearby Nurses
              Navigator.pushNamed(context, RouteName.setChargeRoute);
              break;
          }
        },
      ),
    );
  }
}
