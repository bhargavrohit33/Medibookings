import 'package:flutter/material.dart';
import 'package:medibookings/common/app_colors.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/presentation/screens/Hospital/widgets/%20no_appointment_found.dart';
import 'package:medibookings/presentation/screens/nurse/reference/appointments_slots_card_reference.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/custom_appbar.dart';
import 'package:medibookings/presentation/widget/somethin_went_wrong.dart';
import 'package:medibookings/service/hospital/doctor.service.dart';

import 'package:provider/provider.dart';

import 'package:table_calendar/table_calendar.dart';

class DoctorAppointmentCalendarInReference extends StatefulWidget {
  String? doctodID ;
  String? hospitalID;
   DoctorAppointmentCalendarInReference({super.key, required this.doctodID,required this.hospitalID});
  @override
  _DoctorAppointmentCalendarInReferenceState createState() =>
      _DoctorAppointmentCalendarInReferenceState();
}

class _DoctorAppointmentCalendarInReferenceState extends State<DoctorAppointmentCalendarInReference> {
  late DateTime _selectedDate;

  bool _isExpanded = false;
  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    
  }

  

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    Color color = primaryColor;
    final locationService = Provider.of<DoctorService>(context);
    return Scaffold(
      appBar: CustomAppBar(title: "Appointment Calendar"),
      body: FutureBuilder<DateTime>(
          future: locationService.getLastAppointmentDate(),
          builder: (context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return commonLoading();
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_isExpanded)
                        calenderShow(
                            calendarFormat: CalendarFormat.week,
                            lastDate: futureSnapshot.data!),
                      const SizedBox(height: 16),
                      if (!_isExpanded)
                        Center(
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isExpanded = !_isExpanded;
                                });
                              },
                              icon: Icon(_isExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more)),
                        ),
                      const SizedBox(height: 16),
                     const Text(
                        'Appointments',
                        style:
                             TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: AppointmentSlotListInReference(
                          dateTime: _selectedDate,
                          doctodID:widget.doctodID!,
                          hospitalID: widget.hospitalID!,
                        ),
                      ),
                    ],
                  ),
                  if (_isExpanded)
                    Material(
                      elevation: 4,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          calenderShow(
                              calendarFormat: CalendarFormat.month,
                              lastDate: futureSnapshot.data!),
                          Center(
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                                icon: Icon(_isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more)),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            );
          }),
    );
  }

  Widget calenderShow(
      {required CalendarFormat calendarFormat, required DateTime lastDate}) {
    DateTime lastDate0 = lastDate;
    if (lastDate0.isBefore(DateTime.now())) {
      lastDate0 = DateTime.now().add(const Duration(days: 31));
    }
    return TableCalendar(

      currentDay: _selectedDate,
      focusedDay: _selectedDate,
      
      firstDay:
          DateTime.now(),
      lastDay: lastDate0,
      calendarFormat: _isExpanded ? CalendarFormat.month : CalendarFormat.week,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDate = selectedDay;
         
        });
      },
    );
  }
}

class AppointmentSlotListInReference extends StatelessWidget {
  final DateTime dateTime;
  final String doctodID;
  final String hospitalID;

  const AppointmentSlotListInReference({super.key, 
    required this.dateTime,
    required this.doctodID,
    required this.hospitalID
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final crossAxisCount = size.width > 200 ? 4 : 2;
    final doctorService = Provider.of<DoctorService>(context);
    return StreamBuilder<List<Appointment>>(
        stream: doctorService.getAppointmentsForDate(date: dateTime,doctorId: doctodID,hospitalId:hospitalID ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return commonLoading();
          } else if (snapshot.hasError) {
            
            return SomethingWentWrongWidget(
              superContext: context,
              message: snapshot.error.toString(),
            );
          } else {
            if (snapshot.data!.isEmpty){
              return const NoAppointmentsFound();
            }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return AppointmentSlotCardInreference(appointment: snapshot.data![index]);
              },
            );
          }
        });
  }
}




