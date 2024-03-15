import 'package:flutter/material.dart';
import 'package:medibookings/common/app_colors.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/shimera_widget.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/EDAppointment/emergency_appointment.dart';

import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';
import 'package:medibookings/model/hospital/patient/patient_model.dart';
import 'package:medibookings/presentation/screens/Hospital/home/widget/home_doctor_card.dart';
import 'package:medibookings/presentation/screens/common/textFormField.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/service/hospital/doctor.service.dart';
import 'package:medibookings/service/hospital/hospital_appointment_service.dart';
import 'package:medibookings/service/hospital/hospital_service.dart';
import 'package:medibookings/service/hospital/patient_service_hospital.dart';
import 'package:provider/provider.dart';

class hospitalHomeScreen extends StatefulWidget {
  const hospitalHomeScreen({super.key});

  @override
  State<hospitalHomeScreen> createState() => _hospitalHomeScreenState();
}

class _hospitalHomeScreenState extends State<hospitalHomeScreen> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double padding = 8.0;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            textFormField(
                textEditingController: textEditingController,
                decoration: defaultInputDecoration(hintText: "Search Doctor"),
                onChanged: (c) => setState(() {})),
            const SizedBox(
              height: 10,
            ),
            textEditingController.text.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(padding),
                    child:  HomeBasicContent(),
                  )
                : const SearchResult()
          ],
        ),
      ),
    );
  }
}

class HomeBasicContent extends StatelessWidget {
  // Dummy data for appointments (you can replace this with actual data)
  // final List<Appointment> normalAppointments = [
  //   Appointment(
  //     id: "1",
  //     patientId: "",
  //     hospitalId: "",
  //     timeSlotDuration: 30,
  //     doctorid:"",
  //     appointmentDate: DateTime.now().add(const Duration(days: 1)),
  //     isBooked: false
  //   ),
  //   Appointment(
  //     id: "1",
  //     patientId: "",
  //     hospitalId: "",
  //     timeSlotDuration: 30,
  //     doctorid:"",
  //     appointmentDate: DateTime.now().add(const Duration(days: 1)),
  //     isBooked: false
  //   ),
  // ];

  

   HomeBasicContent({super.key});

  @override
  Widget build(BuildContext context) {
    final normalAppointment = Provider.of<HospitalAppointmentService>(context);
    final hospitalService = Provider.of<HospitalService>(context);
    return StreamBuilder<List<Appointment>>(
      stream: normalAppointment.getAppointmentsNearCurrentTime(hospitalService.hospitalModel!.id),
      builder: (context, normalAppointments) {

         if (normalAppointments.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (normalAppointments.hasError) {
              return Center(child: Text('Error: ${normalAppointments.error}'));
            } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleBar("Doctors:",(){
              Navigator.pushNamed(context, RouteName.hospital_doctorList_Screen);
            }),
            const SizedBox(height: 8),
            doctorList(context),const SizedBox(height: 8),
              const SizedBox(height: 8),
            titleBar("Upcoming Emergency Department Appointments:",(){}),
            const SizedBox(height: 8),
            buildEmergencyAppointmentCarousel([],context),
             const SizedBox(height: 8),
            titleBar("Upcoming Appointments:",(){}),
            const SizedBox(height: 8),
            buildAppointmentCarousel(normalAppointments.data!,context),
            const SizedBox(height: 8),
            
            
          ],
        );
            }}
    );
  }

  Widget titleBar(String title, VoidCallback onTap) {
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, ),
          ),
        ),
        InkWell(
          onTap: onTap,
          child: const Text("View all"),
        ),

      ],
    );
  }

  Widget buildAppointmentCarousel(List<Appointment> appointments, BuildContext context) {
  final size = MediaQuery.of(context).size;
  final theme = Theme.of(context);
  const color = Colors.white;
  final patientService = Provider.of<PatientServiceHospital>(context);
  return CarouselSlider.builder(
    itemCount: appointments.length,
    options: CarouselOptions(
      aspectRatio: 2.4,
      viewportFraction: 1,
      enlargeCenterPage: true,
      enableInfiniteScroll: false,
    ),
    itemBuilder: (BuildContext context, int index, int realIndex) {
      final appointment = appointments[index];
      return FutureBuilder<PatientModel?>(
        future: patientService.getPatientById(appointment.patientId!),
        builder: (context, patientsnapshot) {
          if (patientsnapshot.hasData){
          return Container(
            width: size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(cardRadius),
              color: primaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.event_note, color: color, size: 30),
                      Expanded(
                        child: Text(
                          ' ${patientsnapshot.data!.firstName} ${patientsnapshot.data!.lastName}',
                          style: const TextStyle(color: color),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: color, size: 30),
                      Expanded(
                        child: Text(
                          'Date: ${DateFormat('MMMM dd, yyyy').format(appointment.appointmentDate!)}',
                          style: const TextStyle(color: color),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(cardRadius),
                      color: theme.scaffoldBackgroundColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: Row(
                        children: [
                          const Icon(Icons.timer, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '${appointment.timeSlotDuration} minutes',
                            
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }else{
          return ShimmerWidget();
        }
        }
      );
    },
  );
}
Widget doctorList(BuildContext context){
  final _doctorService = Provider.of<DoctorService>(context);
  return SizedBox(
      height: 180, 
      child: StreamBuilder<List<Doctor>>(
        stream: _doctorService.getDoctorsByHospitalIdStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return commonLoading();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: '));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No doctors found.'));
          }else{
          return  ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              
              
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: HomeDoctorCard(doctor: snapshot.data![index]),
              );
          }
              
            ,
          );
        }
}),
    );
    
}

  Widget buildEmergencyAppointmentCarousel(
      List<EmergencyAppointmentModel> appointments,BuildContext context) {
        final patientService = Provider.of<PatientServiceHospital>(context);
        final size = MediaQuery.of(context).size;
        final theme = Theme.of(context);
        const color = Colors.white;
    return CarouselSlider.builder(
      itemCount: appointments.length,
      options: CarouselOptions(
        aspectRatio:2.5,
        viewportFraction: 1,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
      ),
      itemBuilder: (BuildContext context, int index, int realIndex) {
        final appointment = appointments[index];
        return FutureBuilder<PatientModel?>(
          future: patientService.getPatientById(appointment.patientId),
          builder: (context, snapshot) {
            if(snapshot.hasData){
            return Container(
              width: size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(cardRadius),
                  color: primaryColor),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.personal_injury,color: color,size: 30),
                      Expanded(
                        child: Text(snapshot.data!.firstName.toString() +" " + snapshot.data!.lastName.toString(),
                                        style: const TextStyle(color: color),
                                        ),
                      ),
                    
                    ],),
                     const SizedBox(height: 5,),
                     Row(children: [
                      const Icon(Icons.lock_clock,color: color,size: 30),
                      Expanded(
                        child: Text(
                        ' ${DateFormat('hh:mm a').format(appointment.appointmentDate)}',style: const TextStyle(color: color),),
                      ),
                    
                    ],),
                    
                  const SizedBox(height: 5,),
                  Container(
                    width: size.width,
                    decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(cardRadius),
                  color: theme.scaffoldBackgroundColor),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:8,vertical: 2),
                      child: Row(
                        children: [
                           const Icon(Icons.lock_clock,size: 20),
                          const SizedBox(width: 8),
                          Text('Priority: ${appointment.type}'),
                        ],
                      ),
                    ),
                  ),
                  ]
                ),
              ),
            );
          } else{
            return ShimmerWidget();
          }
          }
        );
      },
    );
  }
}

class SearchResult extends StatefulWidget {
  const SearchResult({super.key});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Search result"),
    );
  }
}


