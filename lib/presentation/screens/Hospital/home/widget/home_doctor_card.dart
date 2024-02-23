import 'package:flutter/material.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';

class HomeDoctorCard extends StatelessWidget {
  final Doctor doctor;

  const HomeDoctorCard({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: cardShape,
      child: Container(
        width: 120, 
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cardRadius)
        ),
        padding: EdgeInsets.all(16),
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              doctor.specialty,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}