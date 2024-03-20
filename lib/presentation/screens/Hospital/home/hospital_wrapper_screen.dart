import 'package:flutter/material.dart';
import 'package:medibookings/presentation/screens/Hospital/appointment/appointment_list_screen.dart';
import 'package:medibookings/presentation/screens/Hospital/department/emergency_department_screen.dart';
import 'package:medibookings/presentation/screens/Hospital/home/hospital_home_screen.dart';
import 'package:medibookings/presentation/screens/Hospital/widgets/hospital_drawer.dart';
import 'package:medibookings/presentation/widget/custom_appBar_without_backbutton.dart';
import 'package:medibookings/service/hospital/hometab_service.dart';

import 'package:provider/provider.dart';

class HospitalWrapperScreen extends StatefulWidget {
  const HospitalWrapperScreen({super.key});

  @override
  _HospitalWrapperScreenState createState() => _HospitalWrapperScreenState();
}

class _HospitalWrapperScreenState extends State<HospitalWrapperScreen> {
  

 

  var titles = ['Home',"Emergency",'Appointment'];
  var list = [
    const hospitalHomeScreen(),
    const EmergencyDepartmentScreen(),
    const AppointmentListScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final homeTabe = Provider.of<HomeTabService>(context);
    return Scaffold(
      appBar: CustomAppBarWithoutBackButton(
      title: titles[homeTabe.bottomTab],
      ),
      drawer: const HospitalDrawer(),
      body: list[homeTabe.bottomTab],
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
        currentIndex: homeTabe.bottomTab,
        
        onTap: (v)async{
        await  homeTabe.updateTab(v);
        },
      ),
      
    );
  }
}

