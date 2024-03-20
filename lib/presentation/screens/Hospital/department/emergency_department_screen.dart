import 'package:flutter/material.dart';
import 'package:medibookings/common/shimera_widget.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/EDAppointment/emergency_appointment.dart';
import 'package:medibookings/model/hospital/patient/patient_model.dart';
import 'package:medibookings/presentation/screens/Hospital/widgets/date_selection_bar.dart';
import 'package:medibookings/presentation/widget/button.dart';

import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/somethin_went_wrong.dart';
import 'package:medibookings/service/hospital/emergency_service.dart';
import 'package:medibookings/service/hospital/patient_service_hospital.dart';
import 'package:provider/provider.dart';

class EmergencyDepartmentScreen extends StatefulWidget {
  const EmergencyDepartmentScreen({super.key});

  @override
  _EmergencyDepartmentScreenState createState() =>
      _EmergencyDepartmentScreenState();
}

class _EmergencyDepartmentScreenState extends State<EmergencyDepartmentScreen> {
  DateTime selectedDate = DateTime.now();
  bool isCancelled = false;
  DateTime now = DateTime.now();
  DateTime? time ;
  @override
  void initState() {
    // TODO: implement initState
    time = DateTime(now.year,now.month,now.day,0,0,0,);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final emergencyService = Provider.of<EmergencyAppointmentService>(context);
    final hospitalService = Provider.of<PatientServiceHospital>(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: DateSelectionCard(
                      selectedDate: selectedDate, onSelectDate: _selectDate)),
              Column(
                children: [
                 
                  Switch(
                    
                      value: isCancelled,
                      onChanged: (c) {
                        setState(() {
                          isCancelled = c;
                        });
                      }), Text("All"),
                ],
              )
            ],
          ),
          Expanded(
            child: StreamBuilder<List<EmergencyAppointmentModel>>(
              stream: emergencyService
                  .fetchOrderedHospitalEmergencyAppointmentsStream(
                      dateTime: selectedDate,
                      allAppoinment: isCancelled), // Fetch appointment data
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return commonLoading();
                } else if (snapshot.hasError) {
                  return SomethingWentWrongWidget(superContext: context);
                } else {
                  List<EmergencyAppointmentModel> appointments = snapshot.data!;
                  return ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      EmergencyAppointmentModel appointment =
                          appointments[index];
                      return FutureBuilder<PatientModel?>(
                          future: hospitalService
                              .getPatientById(appointment.patientId),
                          builder: (context, patinetSnapShot) {
                            if (patinetSnapShot.hasData) {
                              return Card(
                                shape: cardShape,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(cardRadius),
                        ),
                        padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${patinetSnapShot.data!.firstName} ${patinetSnapShot.data!.lastName}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Time: ${customDateFormat(dateTime: appointment.appointmentDate, format: 'hh:mm a').toString()}',
                                            ),
                                          ),
                                          Flexible(
                                            child: DropdownButton<EmergencyType>(
                                              value: appointment.type,
                                              onChanged: (newValue) async {
                                                appointment.type = newValue!;
                                                await emergencyService
                                                    .updateAppointmentType(
                                                        appointment); // Update appointment priority
                                              },
                                              items: [
                                                EmergencyType.normal,
                                                EmergencyType.urgent,
                                                EmergencyType.emergency
                                              ].map((priority) {
                                                return DropdownMenuItem<
                                                    EmergencyType>(
                                                  value: priority,
                                                  child: Text(capitalizeFirstLetter(
                                                      convertEmergencyTypeToString(
                                                          priority))),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    
                                    Row(
                                      children: [
                                        Expanded(child: basicButton(onPressed: (){
                                          showModalBottomSheet(context: context, builder: (context){
                                            return NoteWidgetForAppointment(notes: appointment.notes);
                                          });
                                        }, text: 'Note')),
                                        if(snapshot.data![index].appointmentDate.isAfter(time!))
                                        Expanded(
                                          child: basicButton(onPressed: ()async{
                                            bool val = !snapshot.data![index].isCancelled;
                                            await emergencyService.updateAPpointmentStatus(isCancelled: val,model: snapshot.data![index]);
                                          }, text: snapshot.data![index].isCancelled? "Not Completed":' Completed'),
                                        ),
                                      ],
                                    )
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return ShimmerWidget();
                            }
                          });
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // You can set initial date here
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}


class NoteWidgetForAppointment extends StatelessWidget {
  String notes;

   NoteWidgetForAppointment({required this.notes,super.key});

  @override
  Widget build(BuildContext context) {
    final size  = MediaQuery.of(context).size;
    return  SingleChildScrollView(
      child: Container(
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Note by patient",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              Divider(),
          
              Text(notes.toString())
            ],
          ),
        ),
      ),
    );
  }
}