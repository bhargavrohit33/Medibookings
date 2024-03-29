import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/service/hospital/reference_service.dart';


import 'package:provider/provider.dart';

class AppointmentSlotCardInreference extends StatelessWidget {
  final Appointment appointment;

  const AppointmentSlotCardInreference({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showBookingBottomSheet(context, appointment);
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              FittedBox(
                child: Text(
                  formatTimeForAppintment(
                      time: appointment.appointmentDate, context: context),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              FittedBox(
                child: Row(
                  children: [
                    const Icon(Icons.timer),
                    Text(
                        '${appointment.timeSlotDuration} min'), // Appointment duration
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBookingBottomSheet(BuildContext context, Appointment appointment) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BookingBottomSheet(
          appointment: appointment,
        );
      },
    );
  }
}

class BookingBottomSheet extends StatefulWidget {
  final Appointment appointment;
  const BookingBottomSheet({super.key, required this.appointment});

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final refereceAppointmentService = Provider.of<ReferenceService>(context);
    return isLoading?commonLoading(): Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Who are you booking for?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          basicButton(
            width: size.width,
            height: 50,
            onPressed: () async {
              try{
                setState(() {
                  isLoading = true;
                });
                 await refereceAppointmentService.updateReferenceAppointment(newAppointment: widget.appointment);
              Navigator.pop(context);
              }
              catch(e){
                rethrow;
              }finally{
                setState(() {
                  isLoading = false;
                });
              }
              
            },
            text: 'Booking',
          ),
          const SizedBox(height: 8),
         
        ],
      ),
    );
  }
}

String formatTimeForAppintment(
    {required DateTime time, required BuildContext context}) {
  final bool is24HourFormat = MediaQuery.of(context).alwaysUse24HourFormat;

  if (is24HourFormat) {
    return DateFormat('HH:mm').format(time);
  } else {
    return DateFormat('hh:mm a').format(time);
  }
}
