import 'package:flutter/material.dart';
import 'package:medibookings/common/app_colors.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/EDAppointment/emergency_appointmentModel.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';
import 'package:medibookings/presentation/screens/Hospital/home/widget/home_doctor_card.dart';
import 'package:medibookings/presentation/screens/common/textFormField.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

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
            SizedBox(
              height: 10,
            ),
            textEditingController.text.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(padding),
                    child: HomeBasicContent(),
                  )
                : SearchResult()
          ],
        ),
      ),
    );
  }
}

class HomeBasicContent extends StatelessWidget {
  // Dummy data for appointments (you can replace this with actual data)
  final List<Appointment> normalAppointments = [
    Appointment(
      id: 1,
      patientId: 1,
      hospitalId: 1,
      timeSlotDuration: 30,
      doctor: 1,
      appointmentDate: DateTime.now().add(Duration(days: 1)),
    ),
    Appointment(
      id: 1,
      patientId: 1,
      hospitalId: 1,
      timeSlotDuration: 30,
      doctor: 1,
      appointmentDate: DateTime.now().add(Duration(days: 1)),
    ),
    Appointment(
      id: 1,
      patientId: 1,
      hospitalId: 1,
      timeSlotDuration: 30,
      doctor: 1,
      appointmentDate: DateTime.now().add(Duration(days: 1)),
    ),
  ];

  final List<EmergencyDepartmentAppointment> emergencyAppointments = [
    EmergencyDepartmentAppointment(
      id: 1,
      patientName: 'John Doe',
      appointmentTime: DateTime.now().add(Duration(hours: 2)),
      priority: 'Urgent',
    ),
    EmergencyDepartmentAppointment(
      id: 1,
      patientName: 'John Doe',
      appointmentTime: DateTime.now().add(Duration(hours: 2)),
      priority: 'Urgent',
    ),
    EmergencyDepartmentAppointment(
      id: 1,
      patientName: 'John Doe',
      appointmentTime: DateTime.now().add(Duration(hours: 2)),
      priority: 'Urgent',
    ),
    EmergencyDepartmentAppointment(
      id: 1,
      patientName: 'John Doe',
      appointmentTime: DateTime.now().add(Duration(hours: 2)),
      priority: 'Urgent',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleBar("Doctors:",(){}),
        SizedBox(height: 8),
        doctorList(),SizedBox(height: 8),
          SizedBox(height: 8),
        titleBar("Upcoming Emergency Department Appointments:",(){}),
        SizedBox(height: 8),
        buildEmergencyAppointmentCarousel(emergencyAppointments,context),
         SizedBox(height: 8),
        titleBar("Upcoming Appointments:",(){}),
        SizedBox(height: 8),
        buildAppointmentCarousel(normalAppointments,context),
        SizedBox(height: 8),
        
        
      ],
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
  final color = Colors.white;

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
                  Icon(Icons.event_note, color: color, size: 30),
                  Expanded(
                    child: Text(
                      'Appointment ID: ${appointment.id}',
                      style: TextStyle(color: color),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: color, size: 30),
                  Expanded(
                    child: Text(
                      'Date: ${DateFormat('MMMM dd, yyyy').format(appointment.appointmentDate!)}',
                      style: TextStyle(color: color),
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
                      Icon(Icons.timer, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Time Slot Duration: ${appointment.timeSlotDuration} minutes',
                        
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
Widget doctorList(){
  final List<Doctor> doctors = [
    Doctor(
      id: 1,
      firstName: 'John',
      lastName: 'Doe',
      specialty: 'Cardiologist',
    ),
    Doctor(
      id: 2,
      firstName: 'Jane',
      lastName: 'Smith',
      specialty: 'Pediatrician',
    ),
    Doctor(
      id: 3,
      firstName: 'Michael',
      lastName: 'Johnson',
      specialty: 'Dermatologist',
    ),
    Doctor(
      id: 4,
      firstName: 'Sarah',
      lastName: 'Williams',
      specialty: 'Neurologist',
    ),
    Doctor(
      id: 5,
      firstName: 'Robert',
      lastName: 'Brown',
      specialty: 'Orthopedic Surgeon',
    ),
    Doctor(
      id: 6,
      firstName: 'Emily',
      lastName: 'Wilson',
      specialty: 'Ophthalmologist',
    ),
  ];
  return SizedBox(
      height: 180, 
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: HomeDoctorCard(doctor: doctor),
          );
        },
      ),
    );
    
}

  Widget buildEmergencyAppointmentCarousel(
      List<EmergencyDepartmentAppointment> appointments,BuildContext context) {
        final size = MediaQuery.of(context).size;
        final theme = Theme.of(context);
        final color = Colors.white;
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
                  Icon(Icons.personal_injury,color: color,size: 30),
                  Expanded(
                    child: Text('${appointment.patientName}',
                                    style: TextStyle(color: color),
                                    ),
                  ),
                
                ],),
                 const SizedBox(height: 5,),
                 Row(children: [
                  Icon(Icons.lock_clock,color: color,size: 30),
                  Expanded(
                    child: Text(
                    ' ${DateFormat('hh:mm a').format(appointment.appointmentTime)}',style: TextStyle(color: color),),
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
                       Icon(Icons.lock_clock,size: 20),
                      const SizedBox(width: 8),
                      Text('Priority: ${appointment.priority}'),
                    ],
                  ),
                ),
              ),
              ]
            ),
          ),
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


