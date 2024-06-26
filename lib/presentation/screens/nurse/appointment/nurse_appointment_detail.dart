import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/patient/patient_model.dart';
import 'package:medibookings/model/nurse/appointment.dart';
import 'package:medibookings/model/nurse/nurse/nurse_model.dart';
import 'package:medibookings/presentation/screens/Nurse/appointment/appointment_screen.dart';
import 'package:medibookings/presentation/screens/Nurse/reference/appointments_slots_card_reference.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/custom_appbar.dart';

import 'package:medibookings/service/nurse/nurse_appointmet_service.dart';
import 'package:medibookings/service/nurse/nurse_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NurseAppointmentDetail extends StatefulWidget {
  NurseAppointment nurseAppointment;
  PatientModel patientModel;
  NurseAppointmentDetail(
      {super.key, required this.nurseAppointment, required this.patientModel});

  @override
  State<NurseAppointmentDetail> createState() => _NurseAppointmentDetailState();
}

class _NurseAppointmentDetailState extends State<NurseAppointmentDetail> {
  bool isLoading = false;
  @override
  Future<String> getAddressFromLatLng(
      {required double latitude, required double longitude}) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks.first;
      String address =
          '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
      return address;
    } catch (e) {
      print('Error getting address: $e');
      return 'Unknown';
    }
  }

  Widget build(BuildContext context) {
    final appointmentService = Provider.of<NurseAppointmentService>(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Booking Details',
      ),
      body: isLoading
          ? commonLoading()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appointmentCard(context),
                  patientCard(context),
                  SizedBox(height: 8),
                  if (widget.nurseAppointment.appointmentStatus ==
                      AppointmentStatus.Pending)
                    basicButton(
                        onPressed: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            widget.nurseAppointment.appointmentStatus =
                                AppointmentStatus.Rejected;
                           await appointmentService.updateAppointmentBooking(widget.nurseAppointment);
                          } catch (e) {
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        text: "Decline booking")
                ],
              ),
            ),
    );
  }

  Widget cardRow({
    required IconData icon,
    required String value,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.primaryColor),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget appointmentCard(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appointment = widget.nurseAppointment;
    final nurseAppointmentService =
        Provider.of<NurseAppointmentService>(context);
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Booking Details',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                tag(widget.nurseAppointment.appointmentStatus)
              ],
            ),
            Divider(),
            cardRow(
              icon: Icons.calendar_today,
              value: '${customDateFormat(
                dateTime: appointment.serviceDateTime,
              )}',
              context: context,
            ),
            cardRow(
              icon: Icons.access_time,
              value:
                  '${appointment.durationOfService.inHours}h ${appointment.durationOfService.inMinutes.remainder(60)}m',
              context: context,
            ),
            cardRow(
              icon: Icons.health_and_safety,
              value: '${appointment.requestedService}',
              context: context,
            ),
            FutureBuilder(
                future: nurseAppointmentService.getAddressFromLatLng(
                    latitude: appointment.addressGeopoint!.latitude,
                    longitude: appointment.addressGeopoint!.longitude),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        cardRow(
                          icon: Icons.location_on,
                          value: snapshot.data.toString(),
                          context: context,
                        ),
                        Container(
                            width: size.width,
                            child: ElevatedButton(
                                onPressed: () {
                                  _openMaps(appointment.addressGeopoint!);
                                },
                                child: Text('Open in google map')))
                      ],
                    );
                  } else {
                    return Container();
                  }
                }))
          ],
        ),
      ),
    );
  }

  Widget patientCard(BuildContext context) {
    final nurse = widget.patientModel;
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 2.0,
        margin: EdgeInsets.all(8.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Patient Details',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Divider(),
              cardRow(
                icon: Icons.person,
                value: '${nurse.firstName} ${nurse.lastName}',
                context: context,
              ),
              cardRow(
                icon: Icons.phone,
                value: '${nurse.phoneNumber}',
                context: context,
              ),
              // Add more nurse details here
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openMaps(GeoPoint address) async {
    double latitude = address.latitude;
    double longitude = address.longitude;
    final urlString =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    //var uri = Uri.parse("google.navigation:q=$latitude,$longitude&mode=d");
    var uri = Uri.parse(urlString);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
