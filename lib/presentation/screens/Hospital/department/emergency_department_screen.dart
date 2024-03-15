import 'package:flutter/material.dart';
import 'package:medibookings/common/shimera_widget.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/EDAppointment/emergency_appointment.dart';
import 'package:medibookings/model/hospital/patient/patient_model.dart';
import 'package:medibookings/presentation/screens/Hospital/widgets/date_selection_bar.dart';

import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/somethin_went_wrong.dart';
import 'package:medibookings/service/hospital/emergency_service.dart';
import 'package:medibookings/service/hospital/patient_service_hospital.dart';
import 'package:provider/provider.dart';


class EmergencyDepartmentScreen extends StatefulWidget {
  const EmergencyDepartmentScreen({super.key});

  @override
  _EmergencyDepartmentScreenState createState() => _EmergencyDepartmentScreenState();
}

class _EmergencyDepartmentScreenState extends State<EmergencyDepartmentScreen> {
 
DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final emergencyService = Provider.of<EmergencyAppointmentService>(context);
    final hospitalService = Provider.of<PatientServiceHospital>(context);
     final theme = Theme.of(context);
    return Scaffold(
      
      body: Column(
        children: [
          DateSelectionCard(selectedDate: selectedDate, onSelectDate: _selectDate),
          Expanded(
            child: StreamBuilder<List<EmergencyAppointmentModel>>(
              stream: emergencyService.fetchOrderedHospitalEmergencyAppointmentsStream(selectedDate), // Fetch appointment data
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
                      EmergencyAppointmentModel appointment = appointments[index];
                      return FutureBuilder<PatientModel?>(
                        future: hospitalService.getPatientById(appointment.patientId),
                        builder: (context, patinetSnapShot) {
                          if(patinetSnapShot.hasData){
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: ListTile(
                              title: Text(
                               '${ patinetSnapShot.data!.firstName} ${ patinetSnapShot.data!.lastName}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Text('Time: ${customDateFormat(dateTime: appointment.appointmentDate,format: 'hh:mm a').toString()}'),
                                  const SizedBox(height: 5),
                                 
                                ],
                              ),
                              trailing: DropdownButton<EmergencyType>(
                                value: appointment.type,
                                onChanged: (newValue)async {
                                  
                                    appointment.type = newValue!;
                                  await   emergencyService.updateAppointmentType(appointment); // Update appointment priority
                                
                                },
                                items: [EmergencyType.normal, EmergencyType.urgent, EmergencyType.emergency].map((priority) {
                                  return DropdownMenuItem<EmergencyType>(
                                    value: priority,
                                    child: Text(capitalizeFirstLetter(convertEmergencyTypeToString(priority))),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        }
                        else{
                          return ShimmerWidget();
                        }
                        }
                      );
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
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

}


