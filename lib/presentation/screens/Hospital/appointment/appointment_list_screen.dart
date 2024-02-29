import 'package:flutter/material.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';
import 'package:medibookings/presentation/screens/Hospital/appointment/appointment_card.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/service/hospital/doctor.service.dart';
import 'package:medibookings/service/hospital/hospital_appointment_service.dart';
import 'package:medibookings/service/hospital/hospital_service.dart';
import 'package:provider/provider.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  
  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen>  {
   
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    final hospitalProvider = Provider.of<HospitalService>(context);
    final hospitalAppointmentService = Provider.of<HospitalAppointmentService>(context);    
    return Scaffold(
      
      body: Column(
        children: [
          
          Expanded(
            child: StreamBuilder<List<Appointment>>(
              stream: hospitalAppointmentService.getAppointmentsByHospitalId(hospitalProvider.hospitalModel!.id),
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
                
                return AppointmentListView(
                  appointments:snapshot.data!,
                );
              }
                  }
            ),
          ),
        ],
      ),
        
    );
  }

 
}
class AppointmentListView extends StatelessWidget {
  final List<Appointment> appointments;

  const AppointmentListView({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
   
    final doctorService = Provider.of<DoctorService>(context); 
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
       
         
        return AppointcardWidget(appointment: appointment,);
      },
    );
  }
}