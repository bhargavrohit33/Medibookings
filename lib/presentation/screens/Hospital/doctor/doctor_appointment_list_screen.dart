import 'package:flutter/material.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/presentation/screens/Hospital/appointment/appointment_card.dart';
import 'package:medibookings/presentation/widget/custom_appbar.dart';

class DoctorAppointmentListScreen extends StatefulWidget {
  const DoctorAppointmentListScreen({super.key});

  @override
  State<DoctorAppointmentListScreen> createState() => _DoctorAppointmentListScreenState();
}

class _DoctorAppointmentListScreenState extends State<DoctorAppointmentListScreen> {
  List<Appointment>  appointments =[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appointments = generateDummyAppointments();
  }
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(title: "Appointments"),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return AppointcardWidget(appointment: appointment);
        },
      ),
    );
  }
  }
