import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:medibookings/main.dart';
import 'package:medibookings/presentation/screens/Hospital/appointment/appointment_list_screen.dart';
import 'package:medibookings/presentation/screens/Hospital/department/emergency_department_screen.dart';
import 'package:medibookings/presentation/screens/Hospital/home/hospital_home_screen.dart';
import 'package:medibookings/presentation/screens/Hospital/widgets/hospital_drawer.dart';
import 'package:medibookings/presentation/widget/custom_appBar_without_backbutton.dart';
import 'package:medibookings/service/auth_service.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    message(context);
  }
  Future<void> message(BuildContext context)async{
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String? token = await _firebaseMessaging.getToken();
    final userService = Provider.of<AuthService>(context,listen: false);
    await userService.updateHospitalFCM(token!);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  
  print('Received foreground message: ${message.notification?.body}');
});
FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

  print('Opened app from notification: ${message.notification?.body}');
});


  }

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

