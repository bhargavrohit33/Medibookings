import 'package:flutter/material.dart';
import 'package:medibookings/presentation/screens/Hospital/appointment/appointment_list_screen.dart';
import 'package:medibookings/presentation/screens/Hospital/department/emergency_department_screen.dart';
import 'package:medibookings/presentation/screens/Hospital/home/hospital_home_screen.dart';
import 'package:medibookings/presentation/screens/Hospital/widgets/hospital_drawer.dart';
import 'package:medibookings/presentation/widget/custom_appBar_without_backbutton.dart';

class HospitalWrapperScreen extends StatefulWidget {
  const HospitalWrapperScreen({super.key});

  @override
  _HospitalWrapperScreenState createState() => _HospitalWrapperScreenState();
}

class _HospitalWrapperScreenState extends State<HospitalWrapperScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  var titles = ['Home',"Emergency",'Appointment'];
  var list = [
    const hospitalHomeScreen(),
    const EmergencyDepartmentScreen(),
    const AppointmentListScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithoutBackButton(
      title: titles[_selectedIndex],
      ),
      drawer: const HospitalDrawer(),
      body: list[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Department',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointment',
          ),
        ],
        currentIndex: _selectedIndex,
        
        onTap: _onItemTapped,
      ),
      
    );
  }
}

