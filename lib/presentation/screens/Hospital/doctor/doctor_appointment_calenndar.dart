import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medibookings/common/app_colors.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/custom_appbar.dart';
import 'package:medibookings/presentation/widget/somethin_went_wrong.dart';
import 'package:medibookings/service/hospital/doctor.service.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class DoctorAppointmentCalendar extends StatefulWidget {
  String? doctodID ;
  String? hospitalID;
  bool? isUSerCanBookAppointment;
   DoctorAppointmentCalendar({super.key, required this.doctodID,required this.hospitalID,required this.isUSerCanBookAppointment});
  @override
  _DoctorAppointmentCalendarState createState() =>
      _DoctorAppointmentCalendarState();
}

class _DoctorAppointmentCalendarState extends State<DoctorAppointmentCalendar> {
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
    final doctorService = Provider.of<DoctorService>(context);
    return Scaffold(
      appBar: CustomAppBar(title: "Appointment Calendar"),
      body: FutureBuilder<DateTime>(
          future: doctorService.getLastAppointmentDate(),
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
                        IconButton(
                            onPressed: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            icon: Icon(_isExpanded
                                ? Icons.expand_less
                                : Icons.expand_more)),
                      const SizedBox(height: 16),
                     const Text(
                        'Appointments',
                        style:
                             TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: AppointmentSlotList(
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
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _isExpanded = !_isExpanded;
                                });
                              },
                              icon: Icon(_isExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more)),
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

class AppointmentSlotList extends StatelessWidget {
  final DateTime dateTime;
  final String doctodID;
  final String hospitalID;

  const AppointmentSlotList({super.key, 
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
            if (snapshot.data!.length == 0){
              return const Center(child: Text("No appointment found"),);
            }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return AppointmentSlotCard(appointment: snapshot.data![index]);
              },
            );
          }
        });
  }
}

class AppointmentSlotCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentSlotCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
      
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              FittedBox(
                child: Text(
                  formatTimeForAppintment(
                      time: appointment.appointmentDate, context: context),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              FittedBox(
                child: Row(
                  children: [
                    const Icon(Icons.timer),
                    Text(
                        '${appointment.timeSlotDuration} min'), // Appointment duration
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
String formatTimeForAppintment(
    {required DateTime time, required BuildContext context}) {
  final bool is24HourFormat = MediaQuery.of(context).alwaysUse24HourFormat;

  if (is24HourFormat) {
    return DateFormat('HH:mm').format(time);
  } else {
    return DateFormat('hh:mm a').format(time);
  }
}