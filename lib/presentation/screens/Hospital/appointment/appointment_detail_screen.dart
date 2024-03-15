import 'package:flutter/material.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';
import 'package:medibookings/model/hospital/patient/patient_model.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/custom_appbar.dart';
import 'package:medibookings/presentation/widget/snack_bar.dart';
import 'package:medibookings/service/hospital/doctor.service.dart';
import 'package:medibookings/service/hospital/hospital_appointment_service.dart';
import 'package:provider/provider.dart';

class AppointmentDetailScreeen extends StatefulWidget {
  final Appointment appointment;
  final PatientModel patientModel;
  final Doctor doctor;

  AppointmentDetailScreeen(
      {super.key,
      required this.appointment,
      required this.patientModel,
      required this.doctor});

  @override
  State<AppointmentDetailScreeen> createState() =>
      _AppointmentDetailScreeenState();
}

class _AppointmentDetailScreeenState extends State<AppointmentDetailScreeen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final appointmentService = Provider.of<HospitalAppointmentService>(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Appointment Details',
      ),
      body: isLoading
          ? commonLoading()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    doctorCard(context: context),
                    appointmentCard(context: context)
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8),
          child: basicButton(
              onPressed: () async {
                try {
                  setState(() {
                    isLoading = true;
                  });

                  if (widget.appointment.appointmentDate
                      .isBefore(DateTime.now())) {
                    custom_snackBar(
                        context, "This appointment has already expired.");
                  } else {
                    await appointmentService
                        .cancelAppointment(widget.appointment);
                    Navigator.pop(context);
                  }
                } catch (e) {
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              text: "Cancel appointment",
              height: 50)),
    );
  }

  Widget doctorCard({required BuildContext context}) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Card(
      elevation: cardElevation,
      shape: cardShape,
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
              const Text(
                "Appointment",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Divider(),
              cardRow(
                  icon: const Icon(Icons.medical_services_outlined),
                  value: '${widget.doctor.firstName} ${widget.doctor.lastName}',
                  context: context),
              cardRow(
                  icon: const Icon(Icons.star),
                  value: capitalizeFirstLetter(widget.doctor.specialization),
                  context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget appointmentCard({required BuildContext context}) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Card(
      elevation: cardElevation,
      shape: cardShape,
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
              const Text(
                "Appointment",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Divider(),
              cardRow(
                  context: context,
                  icon: Icon(Icons.personal_injury_rounded),
                  value:
                      "${widget.patientModel.firstName} ${widget.patientModel.lastName}"),
              cardRow(
                  context: context,
                  icon: Icon(Icons.calendar_month),
                  value: showDate(
                    time: widget.appointment.appointmentDate,
                  )),
              cardRow(
                  context: context,
                  icon: Icon(Icons.schedule),
                  value: showTime(
                      time: widget.appointment.appointmentDate,
                      context: context)),
              cardRow(
                  context: context,
                  icon: Icon(Icons.timer),
                  value: widget.appointment.timeSlotDuration.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardRow(
      {required Widget icon,
      required String value,
      required BuildContext context}) {
    double constDistance = 10;
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          SizedBox(
            width: constDistance,
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
