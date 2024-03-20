import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/Models/appointment.dart';
import 'package:medibookings/presentation/screens/nurse/appointment/appointment_screen.dart';
import 'package:medibookings/presentation/screens/nurse/widget/nurse_drawer.dart';
import 'package:medibookings/presentation/screens/profile/profile_screen.dart';

class NurseHomePage extends StatefulWidget {
  const NurseHomePage({super.key});

  @override
  _NurseHomePageState createState() => _NurseHomePageState();
}

class _NurseHomePageState extends State<NurseHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const UpcomingAppointmentsScreen(),
    const AppointmentBookingPage(),
    const ProfileScreen(),
  ];

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
        title: const Text(
          'Home',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: NurseDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class UpcomingAppointmentsScreen extends StatelessWidget {
  const UpcomingAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
            itemCount: 2, // Adjust the count according to your actual list of appointments
            itemBuilder: (context, index) {
              final appointment = Appointment(dateTime: DateTime.now(), timeSlot: '9:00 AM', status: 'Upcoming'); // Replace this with your actual appointment data
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
    );
  }
}
