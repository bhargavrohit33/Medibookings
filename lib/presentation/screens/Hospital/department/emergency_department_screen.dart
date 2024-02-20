import 'package:flutter/material.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';


class EmergencyDepartmentScreen extends StatefulWidget {
  @override
  _EmergencyDepartmentScreenState createState() => _EmergencyDepartmentScreenState();
}

class _EmergencyDepartmentScreenState extends State<EmergencyDepartmentScreen> {
  final AppointmentRepository _appointmentRepository = AppointmentRepository(); // Initialize AppointmentRepository

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: FutureBuilder<List<Appointment>>(
        future: _appointmentRepository.getAppointments(), // Fetch appointment data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return commonLoading();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Appointment> appointments = snapshot.data!;
            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                Appointment appointment = appointments[index];
                return ListTile(
                  title: Text(appointment.patientName),
                  subtitle: Text('Appointment Time: ${appointment.appointmentTime}'),
                  trailing: DropdownButton<String>(
                    value: appointment.priority,
                    onChanged: (newValue) {
                      setState(() {
                        appointment.priority = newValue!;
                        _appointmentRepository.updateAppointment(appointment); // Update appointment priority
                      });
                    },
                    items: ['Normal', 'Urgent', 'Emergency'].map((priority) {
                      return DropdownMenuItem<String>(
                        value: priority,
                        child: Text(priority),
                      );
                    }).toList(),
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
class AppointmentRepository {

  static List<Appointment> _appointments = [
    Appointment(id: 1, patientName: 'John Doe', appointmentTime: DateTime.now(), priority: 'Normal'),
    Appointment(id: 2, patientName: 'Jane Smith', appointmentTime: DateTime.now(), priority: 'Urgent'),
    Appointment(id: 3, patientName: 'Alice Johnson', appointmentTime: DateTime.now(), priority: 'Normal'),
   
  ];


  Future<List<Appointment>> getAppointments() async {

    await Future.delayed(Duration(seconds: 1));
    return _appointments;
  }


  Future<void> updateAppointment(Appointment updatedAppointment) async {
   
    int index = _appointments.indexWhere((appointment) => appointment.id == updatedAppointment.id);
    if (index != -1) {
      
      _appointments[index] = updatedAppointment;
    }
  }
}


class Appointment {
  final int id;
  final String patientName;
  final DateTime appointmentTime;
  String priority;

  Appointment({
    required this.id,
    required this.patientName,
    required this.appointmentTime,
    this.priority = 'Normal', // Default priority is 'Normal'
  });

  // Create a copy of the appointment with updated priority
  Appointment copyWith({
    String? patientName,
    DateTime? appointmentTime,
    String? priority,
  }) {
    return Appointment(
      id: this.id,
      patientName: patientName ?? this.patientName,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      priority: priority ?? this.priority,
    );
  }
}
