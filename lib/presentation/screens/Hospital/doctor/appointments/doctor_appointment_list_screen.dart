import 'package:flutter/material.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';
import 'package:medibookings/presentation/screens/Hospital/appointment/appointment_card.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/custom_appbar.dart';
import 'package:medibookings/service/hospital/hospital_appointment_service.dart';
import 'package:provider/provider.dart';

class DoctorAppointmentListScreen extends StatefulWidget {
  Doctor doctor;
   DoctorAppointmentListScreen({super.key,required this.doctor});

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
     final appointmentProvider = Provider.of<HospitalAppointmentService>(context);
    
    
    return  Scaffold(
      appBar: CustomAppBar(title: "Appointments"),
      body: StreamBuilder<List<Appointment>>(
        stream: appointmentProvider.getAppointmentsForDoctor(widget.doctor.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: commonLoading());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } 
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No appointment found.'));
          }
          else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              
              return AppointcardWidget(appointment: snapshot.data![index]);
            },
          );
        }}
      ),
    );
  }
  }
