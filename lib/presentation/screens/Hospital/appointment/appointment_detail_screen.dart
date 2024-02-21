import 'package:flutter/material.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/presentation/screens/Hospital/appointment/appointment_card.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/custom_appbar.dart';

class AppointmentDetailScreeen extends StatelessWidget {
  final Appointment appointment;

  AppointmentDetailScreeen(this.appointment);

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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Divider(),
                  Text(
                    'Doctor: ${appointment.doctor}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start Time: ${appointment.appointmentDate}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
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
        padding: EdgeInsets.all(8),
        child: basicButton(onPressed: (){},text: "Cancel appointment",height: 50)),
    );
  }
}
