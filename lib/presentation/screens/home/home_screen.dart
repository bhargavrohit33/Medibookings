import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/Models/appointment.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Appointment> upcomingAppointments = [
    Appointment(dateTime: DateTime(2024, 2, 26, 10, 0), timeSlot: '10:00 AM', status: 'Upcoming'),
    Appointment(dateTime: DateTime(2024, 2, 27, 11, 0), timeSlot: '11:00 AM', status: 'Upcoming'),
  ];

  List<Appointment> currentAppointments = [];

  @override
  void initState() {
    super.initState();
    currentAppointments = upcomingAppointments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      drawer: Drawer(
        child: Column(
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
            ),ListTile(
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Upcoming Appointments',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.lightBlue),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: currentAppointments.length,
              itemBuilder: (context, index) {
                final appointment = currentAppointments[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Appointment at ${appointment.dateTime}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Time Slot: ${appointment.timeSlot}'),
                        Text('Status: ${appointment.status}'),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(width: 4),
                            Text('Add to Calendar'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
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
            case 2: // profile
              Navigator.pushNamed(context, RouteName.profileRoute);
              break;
          }
        },
      ),
    );
  }
}
