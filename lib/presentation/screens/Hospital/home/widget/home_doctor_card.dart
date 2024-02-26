import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';

class HomeDoctorCard extends StatelessWidget {
  final Doctor doctor;

  const HomeDoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, RouteName.hospital_doctorAppointmentListRoute);
      },
      child: Card(
        elevation: 1,
        shape: cardShape,
        child: Container(
          width: 120, 
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cardRadius)
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage:  NetworkImage(nurseDemoImageURL,)
                , 
              ),
              Expanded(
                child: Text(
                  '${doctor.firstName} ${doctor.lastName}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                doctor.specialty,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}