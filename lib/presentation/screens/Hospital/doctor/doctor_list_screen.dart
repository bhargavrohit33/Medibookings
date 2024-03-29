import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';
import 'package:medibookings/model/route_model.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/custom_appbar.dart';
import 'package:medibookings/presentation/widget/profile_photo_card.dart';
import 'package:medibookings/service/hospital/doctor.service.dart';
import 'package:provider/provider.dart';






class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  @override
  Widget build(BuildContext context) {
    final doctorService = Provider.of<DoctorService>(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'Doctor List'),
      body: StreamBuilder<List<Doctor>>(
        stream: doctorService.getDoctorsByHospitalIdStream(hospitalId: doctorService.firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return commonLoading();
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error: '));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No doctors found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return DoctorWidget(snapshot.data![index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteName.hospital_createDoctorProfile);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DoctorWidget extends StatelessWidget {
  final Doctor doctor;

  DoctorWidget(this.doctor, {super.key});

  final GlobalKey iconKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(cardRadius)),
        padding: const EdgeInsets.all(16), // Added padding for better spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                profilePhoto(profilePhoto: doctor.profilePhoto),
                
                const SizedBox(width: 10), // Added space between image and text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${doctor.firstName} ${doctor.lastName}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        doctor.specialization,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  key: iconKey,
                  onPressed: () {
                    showPopUp(context,doctor);
                  },
                  icon: const Icon(Icons.more_vert),
                )
              ],
            ),
            const SizedBox(height: 10), // Added space between doctor info and buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteName.hospital_editDoctorProfile,arguments: doctor);
                    },
                    child: const FittedBox(child: Text('Edit')),
                  ),
                ),
                const SizedBox(width: 10), // Added space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                     Navigator.pushNamed(context, RouteName.hospital_doctorAppointmentListRoute,arguments: doctor);
                    },
                    child: const FittedBox(child: Text('Appointments')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  
  showPopUp(BuildContext context,Doctor doctor){
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                    final RenderBox button = iconKey.currentContext!.findRenderObject() as RenderBox;

                    final RenderBox overlayBox = overlay;
                    final RenderBox buttonBox = button;

                    final Offset position = buttonBox.localToGlobal(Offset.zero, ancestor: overlayBox);

                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        position.dx,
                        position.dy,
                        position.dx + button.size.width,
                        position.dy,
                      ),
                      items: [
                        PopupMenuItem(
                          onTap: (){
                            Navigator.pushNamed(context, RouteName.hospital_generate_appointment,arguments: doctor );
                          },
                          value: 1,
                          child: const Text("Generate"),
                        ),
                        PopupMenuItem(
                          onTap: (){
                            DoctorArugument doctorArugument = DoctorArugument(doctorId: doctor.id, hospitalId: doctor.hospitalId, isUSerCanBookAppointment: false);
                            Navigator.pushNamed(context, RouteName.doctorAppointmentForHospitalCalendarRoute,arguments: doctorArugument );
                          },
                          value: 1,
                          child: const Text("Calender"),
                        ),
                        
                      ],
                    );
  }
}
