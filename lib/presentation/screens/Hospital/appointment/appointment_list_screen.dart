import 'package:flutter/material.dart';
import 'package:medibookings/common/app_colors.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';
import 'package:medibookings/presentation/screens/Hospital/appointment/appointment_card.dart';
import 'package:medibookings/presentation/screens/Hospital/widgets/date_selection_bar.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/somethin_went_wrong.dart';
import 'package:medibookings/service/hospital/doctor.service.dart';
import 'package:medibookings/service/hospital/hospital_appointment_service.dart';
import 'package:medibookings/service/hospital/hospital_service.dart';
import 'package:provider/provider.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  
  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen>  {
   final List<String> filterOptions = ['All', 'Today', 'Tomorrow', 'Next 7 Days',"By date"];
  DateTime? _selectedDate = DateTime.now();
   int _selectedFilterIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    final hospitalProvider = Provider.of<HospitalService>(context);
    final hospitalAppointmentService = Provider.of<HospitalAppointmentService>(context);    
     final theme = Theme.of(context);
    return Scaffold(
      
      body: Column(
        children: [
           Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filterOptions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilterIndex = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedFilterIndex == index ? theme.primaryColor : textFormFieldText,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        filterOptions[index],
                        style: TextStyle(color: _selectedFilterIndex == index ?Colors.white:Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_selectedFilterIndex == 4) // Step 4: Show the date picker if "By date" is selected
            DateSelectionCard(selectedDate:  _selectedDate!, onSelectDate: (v){
               _selectDate(context);
            }),
          Expanded(
            child: StreamBuilder<List<Appointment>>(
              stream: hospitalAppointmentService.getAppointmentsByHospitalId(hospitalProvider.hospitalModel!.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: commonLoading());
                    } else if (snapshot.hasError) {
                      return SomethingWentWrongWidget(superContext: context);
                    } 
                    else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No appointment found.'));
                    }
                    else {
                      final filteredAppointments = filterAppointments(snapshot.data!);
                  if (filteredAppointments.isEmpty){
                     return Center(child: Text('No appointment found.'));
                  }
                 
                  
                return AppointmentListView(
                  appointments:filteredAppointments,
                );
              }
                  }
            ),
          ),
        ],
      ),
        
    );
  }
Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(), // Use selected date if available, else use today's date
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Step 3: Update the filterAppointments method to filter appointments based on the selected date
  List<Appointment> filterAppointments(List<Appointment> appointments) {
    switch (_selectedFilterIndex) {
      case 0: 
        return appointments;
      case 1:
        return appointments.where((appointment) => isToday(appointment.appointmentDate)).toList();
      case 2: 
        return appointments.where((appointment) => isTomorrow(appointment.appointmentDate)).toList();
      case 3:
        final next7Days = DateTime.now().add(Duration(days: 7));
        final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
        final next7DaysRange = today.add(Duration(days: 7));
        return appointments.where((appointment) => appointment.appointmentDate.isAfter(today) && appointment.appointmentDate.isBefore(next7DaysRange)).toList();
      case 4: // Filter by selected date
        return appointments.where((appointment) => isSameDate(appointment.appointmentDate, _selectedDate!)).toList();
    }
    return appointments;
  }
  bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day;
  }

  bool isTomorrow(DateTime dateTime) {
    final tomorrow = DateTime.now().add(Duration(days: 1));
    return dateTime.year == tomorrow.year && dateTime.month == tomorrow.month && dateTime.day == tomorrow.day;
  }
   bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
 
}
class AppointmentListView extends StatelessWidget {
  final List<Appointment> appointments;

  const AppointmentListView({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
   
    final doctorService = Provider.of<DoctorService>(context); 
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
       
         
        return AppointcardWidget(appointment: appointment,);
      },
    );
  }
}