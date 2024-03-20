import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';
import 'package:medibookings/model/hospital/patient/patient_model.dart';
import 'package:medibookings/model/route_model.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/custom_appbar.dart';
import 'package:medibookings/presentation/widget/snack_bar.dart';
import 'package:medibookings/service/hospital/doctor.service.dart';
import 'package:medibookings/service/hospital/hospital_appointment_service.dart';
import 'package:medibookings/service/hospital/patient_service_hospital.dart';
import 'package:medibookings/service/service_utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AppointmentDetailScreeen extends StatefulWidget {
  final Appointment appointment;
  final PatientModel patientModel;
  final Doctor doctor;

  const AppointmentDetailScreeen(
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
    final patientService = Provider.of<PatientServiceHospital>(context);
    final doctorService = Provider.of<DoctorService>(context);
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
                    if(widget.appointment.referralAppointmentId != null && widget.appointment.referralAppointmentId!.isNotEmpty )
                    basicButton(
                        onPressed: () async {
                          try{
                            
                            Appointment referralAppointment =
                              await appointmentService.getAppointmentById(
                                  widget.appointment.referralAppointmentId!);
                          PatientModel? patientModel = await patientService
                              .getPatientById(referralAppointment.patientId!);
                          Doctor? doctorModel = await doctorService
                              .getDoctorById(referralAppointment.doctorid);
                          Navigator.pushNamed(
                              context, RouteName.appointmentRoute,
                              arguments: AppointmentDetailModel(
                                  appointment: referralAppointment,
                                  patientModel: patientModel!,
                                  doctor: doctorModel!));
                          }
                          catch(e){

                          }
                        },
                        text: "Referral"),
                    doctorCard(context: context),
                    if (widget.appointment.familyMember!.isNotEmpty &&
                        widget.appointment.familyMember != null)
                      familyCard(context: context),
                    appointmentCard(context: context),
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
                "Doctor",
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
                  icon: const Icon(Icons.personal_injury_rounded),
                  value:
                      "${widget.patientModel.firstName} ${widget.patientModel.lastName}"),
              cardRow(
                  context: context,
                  icon: const Icon(Icons.calendar_month),
                  value: showDate(
                    time: widget.appointment.appointmentDate,
                  )),
              cardRow(
                  context: context,
                  icon: const Icon(Icons.schedule),
                  value: showTime(
                      time: widget.appointment.appointmentDate,
                      context: context)),
              cardRow(
                  context: context,
                  icon: const Icon(Icons.timer),
                  value: widget.appointment.timeSlotDuration.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget familyCard({required BuildContext context}) {
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
                "Family member",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Divider(),
              cardRow(
                  context: context,
                  icon: const Icon(Icons.personal_injury_rounded),
                  value: "${capitalizeFirstLetter(widget.appointment.familyMember![
                          ServiceUtils
                              .appointmentModel_familyMember_firstName])} ${capitalizeFirstLetter(widget.appointment.familyMember![
                          ServiceUtils
                              .appointmentModel_familyMember_lastName])}"),
              cardRow(
                  context: context,
                  icon: const Icon(Icons.phone),
                  value: widget
                      .appointment
                      .familyMember![ServiceUtils
                          .appointmentModel_familyMember_phone_number]
                      .toString()),
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
      padding: const EdgeInsets.all(8),
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

  Widget shimmerAppointmentCard({required BuildContext context}) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Card(
      elevation: cardElevation,
      shape: cardShape,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
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
                shimmerCardRow(
                    context: context,
                    icon: const Icon(Icons.personal_injury_rounded)),
                shimmerCardRow(
                    context: context, icon: const Icon(Icons.calendar_month)),
                shimmerCardRow(context: context, icon: const Icon(Icons.schedule)),
                shimmerCardRow(context: context, icon: const Icon(Icons.timer)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget shimmerCardRow({required BuildContext context, required Icon icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
