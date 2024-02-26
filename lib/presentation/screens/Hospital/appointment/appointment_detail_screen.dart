import 'package:flutter/material.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/custom_appbar.dart';

class AppointmentDetailScreeen extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailScreeen(this.appointment, {super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Appointment Details',
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
           shape:cardShape,
          child: Container(
decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(cardRadius),
                  
                ),
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
              
                children: [
                  Text(
                    '${appointment.patientId}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Divider(),
                  Text(
                    'Doctor: ${appointment.doctor}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start Time: ${appointment.appointmentDate}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Duration: 15',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8),
        child: basicButton(onPressed: (){},text: "Cancel appointment",height: 50)),
    );
  }
}
