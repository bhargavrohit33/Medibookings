import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/snack_bar.dart';
import 'package:medibookings/service/hospital/hospital_appointment_service.dart';
import 'package:provider/provider.dart';

class AppointmentPreviewScreen extends StatefulWidget {
  final List<Appointment> appointments;

  const AppointmentPreviewScreen({super.key, required this.appointments});

  @override
  State<AppointmentPreviewScreen> createState() => _AppointmentPreviewScreenState();
}

class _AppointmentPreviewScreenState extends State<AppointmentPreviewScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final appointmentProvider = Provider.of<HospitalAppointmentService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Preview'),
      ),
      body: Stack(
        children: [
          _buildAppointmentGrid(context),
          if(isLoading)
            commonLoading()
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: basicButton(onPressed: ()async{
          if(!isLoading){
 setState(() {
            isLoading = true;
          });
         try{
          await appointmentProvider.uploadAppointment(widget.appointments);
           custom_snackBar(context, "Appointments successfully added");
           Navigator.popUntil(
              context,
              ModalRoute.withName(RouteName.hospital_doctorList_Screen),
            );
         }
         catch(e){
          custom_snackBar(context, "Fail to add appointments");
         }finally{
          setState(() {
            isLoading = false;
          });
         }
          }
         


        }, text: "Generate Appointment"),
      ),
    );
  }

  Widget _buildAppointmentGrid(BuildContext context) {
 final size = MediaQuery.of(context).size;
   final crossAxisCount = size.width > 200 ? 4 : 2;
  return GridView.builder(
    
    shrinkWrap: true, 
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
       crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
    ),
    itemCount: widget.appointments.length,
    itemBuilder: (context, index) {
      final appointmentTime = widget.appointments[index];
      
      return AppointmentTile(
        appointment: appointmentTime,
        onDelete: () {
          setState(() {
            widget.appointments.remove(appointmentTime);
          });
        },
      );
    },
  );
}
}

class AppointmentTile extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onDelete;

  const AppointmentTile({super.key, required this.appointment, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 3,
        child: InkWell(
          onTap: () {
          
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('hh:mm a').format(appointment.appointmentDate)),
                Text(DateFormat('hh:mm a').format(appointment.appointmentDate.add(Duration(minutes: appointment.timeSlotDuration)))),
                 
               
                InkWell(
                  onTap: onDelete,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.delete, ),
                     
                      
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
