import 'package:flutter/material.dart';
import 'package:medibookings/models/appointment.dart';

class AppointmentListPage extends StatelessWidget {
  const AppointmentListPage({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Appointment> appointments = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
      ),
      body: appointments.isEmpty
          ? const Center(
        child: Text('No appointments found.'),
      )
          : ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return ListTile(
            title: Text('Appointment Date: ${appointment.dateTime}'),
            subtitle: Text('Time Slot: ${appointment.timeSlot}'),
            trailing: Text('Status: ${appointment.status}'),
          );
        },
      ),
    );
  }
}
