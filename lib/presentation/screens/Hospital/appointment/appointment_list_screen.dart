import 'package:flutter/material.dart';
import 'package:medibookings/common/app_colors.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:intl/intl.dart';
import 'package:medibookings/presentation/screens/Hospital/appointment/appointment_card.dart';

class AppointmentListScreen extends StatefulWidget {
  
  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> with SingleTickerProviderStateMixin {
   TabController? tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController  = TabController(length: 3, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        
        body: Column(
          children: [
            Container(
              height: 50,
              child:TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Different Doctor'),
            ],
          ),
            ),
            Expanded(
              child: TabBarView(
                  children: [
                    AppointmentListView(
                      appointments: generateDummyAppointments(),
                    ),
                    AppointmentListView(
                      appointments: generateDummyAppointments(), 
                    ),
                  ],
                ),
            ),
          ],
        ),
          
      ),
    );
  }

 
}
class AppointmentListView extends StatelessWidget {
  final List<Appointment> appointments;

  AppointmentListView({required this.appointments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return AppointcardWidget(appointment: appointment);
      },
    );
  }
}