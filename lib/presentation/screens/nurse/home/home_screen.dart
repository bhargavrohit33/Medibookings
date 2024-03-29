import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/shimera_widget.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/main.dart';
import 'package:medibookings/model/hospital/patient/patient_model.dart';

import 'package:medibookings/model/nurse/appointment.dart';
import 'package:medibookings/model/route_model.dart';
import 'package:medibookings/presentation/screens/Hospital/widgets/%20no_appointment_found.dart';
import 'package:medibookings/presentation/screens/Nurse/profile/profile_screen.dart';
import 'package:medibookings/presentation/screens/nurse/appointment/appointment_screen.dart';
import 'package:medibookings/presentation/screens/nurse/widget/nurse_drawer.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/somethin_went_wrong.dart';
import 'package:medibookings/service/auth_service.dart';

import 'package:medibookings/service/hospital/patient_service_hospital.dart';
import 'package:medibookings/service/nurse/nurse_appointmet_service.dart';
import 'package:provider/provider.dart';

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

  

  List<NurseAppointment> currentAppointments = [];

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
    await userService.updateNurseFCM(token!);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const NurseDrawer(),
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
    final nurseAppointmentService =
        Provider.of<NurseAppointmentService>(context);
    final patinetService = Provider.of<PatientServiceHospital>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Upcoming Appointments',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: StreamBuilder<List<NurseAppointment>>(
              stream: nurseAppointmentService
                  .pendingNurseAppointmentsTodayOrGreaterThanToday,
              builder: (context, appointmentSnapshot) {
                if (appointmentSnapshot.hasData) {
                  if (appointmentSnapshot.data!.isEmpty) {
                    return NoAppointmentsFound();
                  }
                  return ListView.builder(
                    itemCount: appointmentSnapshot.data!.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<PatientModel?>(
                          future: patinetService.getPatientById(
                              appointmentSnapshot.data![index].patientID),
                          builder: (context, patientSnapshot) {
                            if (patientSnapshot.hasData) {
                              return InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        RouteName.nurseAppointmentDetail,
                                        arguments:
                                            NurseAppointmentRouteAruguments(
                                                nurseAppointment:
                                                    appointmentSnapshot
                                                        .data![index],
                                                patientModel:
                                                    patientSnapshot.data!));
                                  },
                                  child: NurseAppointmentCardForHomeScreen(
                                      appointment:
                                          appointmentSnapshot.data![index],
                                      patientModel: patientSnapshot.data!));
                            } else {
                              return ShimmerWidget();
                            }
                          });
                    },
                  );
                } else if (appointmentSnapshot.hasError) {
                  return SomethingWentWrongWidget(superContext: context);
                } else {
                  return commonLoading();
                }
              }),
        ),
      ],
    );
  }
}

class NurseAppointmentCardForHomeScreen extends StatelessWidget {
  NurseAppointment appointment;
  PatientModel patientModel;
  NurseAppointmentCardForHomeScreen(
      {required this.appointment, required this.patientModel, super.key});

  @override
  Widget build(BuildContext context) {
    final nurseAppointmentService =
        Provider.of<NurseAppointmentService>(context);
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
              '${capitalizeFirstLetter(patientModel.firstName)} ${capitalizeFirstLetter(patientModel.lastName)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            cardRow(
              icon: Icons.access_time,
              value:
                  '${appointment.durationOfService.inHours}h ${appointment.durationOfService.inMinutes.remainder(60)}m',
              context: context,
            ),
            FutureBuilder(
                future: nurseAppointmentService.getAddressFromLatLng(
                    latitude: appointment.addressGeopoint!.latitude,
                    longitude: appointment.addressGeopoint!.longitude),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return cardRow(
                      icon: Icons.location_on,
                      value: snapshot.data.toString(),
                      context: context,
                    );
                  } else {
                    return Container();
                  }
                })),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          appointment.appointmentStatus = AppointmentStatus.Rejected;
                          await nurseAppointmentService.updateAppointmentBooking(appointment);
                        },
                        child: Text('Decline',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red))),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                           appointment.appointmentStatus = AppointmentStatus.Approved;
                          await nurseAppointmentService.updateAppointmentBooking(appointment);
                        },
                        child: Text(
                          'Accept',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green))),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget cardRow({
    required IconData icon,
    required String value,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.primaryColor),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
