
import 'package:flutter/material.dart';
import 'package:medibookings/common/app_colors.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:intl/intl.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';
import 'package:medibookings/service/hospital/doctor.service.dart';
import 'package:provider/provider.dart';


class AppointcardWidget extends StatelessWidget {
  Appointment appointment;
  
   AppointcardWidget({required this.appointment,super.key});

  @override
  Widget build(BuildContext context) {
     final theme = Theme.of(context);
     const bottomBarColor = Colors.white;
     final doctorService = Provider.of<DoctorService>(context);
    return StreamBuilder<Doctor>(
      stream: doctorService.getDoctorByIdStream(appointment.doctorid),
      builder: (context, snapshotDoctor) {
       if (snapshotDoctor.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshotDoctor.hasError) {
              return Center(child: Text('Error: ${snapshotDoctor.error}'));
            } else {
        return Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Card(
                
                shape:cardShape,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(cardRadius),
                  ),
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Row(
                          children: [
                            Icon(Icons.local_hospital, color: primaryColor),
                            const SizedBox(width: 8),
                            Text( appointment.doctorid.toString()),
                          ],
                        ),
                      ),
        
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Row(
                          children: [
                            Icon(Icons.personal_injury_rounded, color: primaryColor),
                            const SizedBox(width: 8),
                            Text(snapshotDoctor.data!.firstName.toString()),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(cardRadius),
                            bottomRight: Radius.circular(cardRadius),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: FittedBox(child: Text(customDateFormat(dateTime: appointment.appointmentDate!), style: const TextStyle(color: bottomBarColor)))),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteName.appointmentRoute,
                                      arguments: appointment
                                      
                                    );
                                  },
                                  icon: const Icon(Icons.info_outline, color: bottomBarColor),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                   
                                  },
                                  icon: const Icon(Icons.swap_horiz, color: bottomBarColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
      }}
    );
     
  }
}



