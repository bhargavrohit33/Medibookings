import 'package:flutter/material.dart';
import 'package:medibookings/model/hospital/EDAppointment/emergency_appointmentModel.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';


class EmergencyDepartmentScreen extends StatefulWidget {
  @override
  _EmergencyDepartmentScreenState createState() => _EmergencyDepartmentScreenState();
}

class _EmergencyDepartmentScreenState extends State<EmergencyDepartmentScreen> {
  final EmergencyDepartmentRepository _emergencyDepartmentRepository = EmergencyDepartmentRepository(); // Initialize EmergencyDepartmentRepository

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: FutureBuilder<List<EmergencyDepartmentAppointment>>(
        future: _emergencyDepartmentRepository.getAppointments(), // Fetch appointment data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return commonLoading();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<EmergencyDepartmentAppointment> appointments = snapshot.data!;
            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                EmergencyDepartmentAppointment appointment = appointments[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                      appointment.patientName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text('Time: ${appointment.appointmentTime.toString()}'),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'Priority: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(appointment.priority),
                          ],
                        ),
                      ],
                    ),
                    trailing: DropdownButton<String>(
                      value: appointment.priority,
                      onChanged: (newValue) {
                        setState(() {
                          appointment.priority = newValue!;
                          _emergencyDepartmentRepository.updateAppointment(appointment); // Update appointment priority
                        });
                      },
                      items: ['Normal', 'Urgent', 'Emergency'].map((priority) {
                        return DropdownMenuItem<String>(
                          value: priority,
                          child: Text(priority),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class EmergencyDepartmentRepository {
  static List<EmergencyDepartmentAppointment> _appointments = [
    EmergencyDepartmentAppointment(id: 1, patientName: 'John Doe', appointmentTime: DateTime.now(), priority: 'Normal'),
    EmergencyDepartmentAppointment(id: 2, patientName: 'Jane Smith', appointmentTime: DateTime.now(), priority: 'Urgent'),
    EmergencyDepartmentAppointment(id: 3, patientName: 'Alice Johnson', appointmentTime: DateTime.now(), priority: 'Normal'),
  ];

  Future<List<EmergencyDepartmentAppointment>> getAppointments() async {
    await Future.delayed(Duration(seconds: 1));
    return _appointments;
  }

  Future<void> updateAppointment(EmergencyDepartmentAppointment updatedAppointment) async {
    int index = _appointments.indexWhere((appointment) => appointment.id == updatedAppointment.id);
    if (index != -1) {
      _appointments[index] = updatedAppointment;
    }
  }
}

