import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentPreviewScreen extends StatefulWidget {
  final List<DateTime> appointments;

  const AppointmentPreviewScreen({super.key, required this.appointments});

  @override
  State<AppointmentPreviewScreen> createState() => _AppointmentPreviewScreenState();
}

class _AppointmentPreviewScreenState extends State<AppointmentPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Preview'),
      ),
      body: _buildAppointmentGrid(context),
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
        appointmentTime: appointmentTime,
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
  final DateTime appointmentTime;
  final VoidCallback onDelete;

  const AppointmentTile({super.key, required this.appointmentTime, required this.onDelete});

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
              children: [
                Text(DateFormat('hh:mm a').format(appointmentTime)),
               
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
