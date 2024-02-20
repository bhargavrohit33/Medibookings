import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';
import 'package:medibookings/presentation/widget/button.dart';






class DoctorListScreen extends StatefulWidget {
  

  DoctorListScreen();

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {

 final List<Doctor> doctors = [
  Doctor(id: 1, firstName: 'Dr. Smith', lastName: '', specialty: 'Cardiology'),
  Doctor(id: 2, firstName: 'Dr. Johnson', lastName: '', specialty: 'Pediatrics'),
  Doctor(id: 3, firstName: 'Dr. Williams', lastName: '', specialty: 'Orthopedics'),
  
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor List'),
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return DoctorWidget(doctors[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushReplacementNamed(context, RouteName.hospital_createDoctorProfile);
      },child: Icon(Icons.add)),
    );
  }
}
class DoctorWidget extends StatelessWidget {
  final Doctor doctor;

  DoctorWidget(this.doctor);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(cardRadius)),
        padding: EdgeInsets.all(16), // Added padding for better spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.network(
                    nurseDemoImageURL,
                    width: 50,
                    height: 50,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(width: 10), // Added space between image and text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.firstName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      doctor.specialty,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10), // Added space between doctor info and buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteName.hospital_editDoctorProfile);
                    },
                    child: FittedBox(child: Text('Edit')),
                  ),
                ),
                SizedBox(width: 10), // Added space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle appointments button press
                    },
                    child: FittedBox(child: Text('Appointments')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
