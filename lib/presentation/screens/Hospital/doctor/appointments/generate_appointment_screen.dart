import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';
import 'package:medibookings/presentation/screens/common/textFormField.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/custom_appbar.dart';

class GenerateAppointmentScreen extends StatefulWidget {
  Doctor doctor;
   GenerateAppointmentScreen({super.key,required this.doctor});

  @override
  _GenerateAppointmentScreenState createState() => _GenerateAppointmentScreenState();
}

class _GenerateAppointmentScreenState extends State<GenerateAppointmentScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedOpeningTime = const TimeOfDay(hour: 9, minute: 0);
   TimeOfDay _selectedClosingTime = const TimeOfDay(hour: 17, minute: 0);
  final List<TimeOfDayRange> _selectedBreakTimes = [];
   List<Appointment> _generatedAppointments = [];
  final TextEditingController _durationOfAppointment = TextEditingController();
  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(title: "Generate Appointments"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (pickedDate != null && pickedDate != _selectedDate) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
              child: Card(
                shape: cardShape,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: size.width ,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [const Text(
                      'Select Date:',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      DateFormat('MMMM dd, yyyy').format(_selectedDate),
                      style: const TextStyle(fontSize: 16),
                    ),],),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               timeCard(() async{ 
                       
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: _selectedOpeningTime,
                            helpText: "Opening time"
                          );
                          if (pickedTime != null && pickedTime != _selectedOpeningTime) {
                            setState(() {
                              _selectedOpeningTime = pickedTime;
                            });
                          }
                        
                      }, "Opening time", _selectedOpeningTime),
                      timeCard(() async{ 
                       
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: _selectedOpeningTime,
                            helpText: "Closing time"
                          );
                          if (pickedTime != null && pickedTime != _selectedOpeningTime) {
                            setState(() {
                              _selectedClosingTime = pickedTime;
                            });
                          }
                        
                      }, "Closing Time:", _selectedClosingTime),
                
              ],
            ),
            const SizedBox(height: 20),
            Form(
              key: key,
              child: textFormField(textEditingController: _durationOfAppointment,
              keyboardType:const TextInputType.numberWithOptions(),
               decoration: defaultInputDecoration(hintText: "Appointment duration"),
               validator: (v){
                if(int.tryParse(v!)== null){
                  return "Enter integer only";
                }
                return null;
              }),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Doctor Break Times:',
                  style: TextStyle(fontSize: 18),
                ),
                IconButton(onPressed: ()async{
                  final startTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        helpText: "Break Start Time",

                      );
                      if (startTime != null) {
                        final endTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          helpText: "Break end Time",

                        );
                        if (endTime != null) {
                          setState(() {
                            _selectedBreakTimes.add(TimeOfDayRange(start: startTime, end: endTime));
                          });
                        }
                      }
                }, icon: const Icon(Icons.add_circle))
              ],
            ),
            const SizedBox(height: 10),

            if (_selectedBreakTimes.isNotEmpty)
            listOfBreakTime(),
            
            
           
           
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: basicButton(onPressed: ()async{
          if (key.currentState!.validate()){
      _generatedAppointments =  generateAppointments(
        selectedDate: _selectedDate,
        duration: int.parse(_durationOfAppointment.text),
        selectedOpeningTime: _selectedOpeningTime,
        selectedClosingTime:_selectedClosingTime ,
        selectedBreakTimes: _selectedBreakTimes,
        doctor: widget.doctor);
        
           Navigator.of(context).pushNamed(
  RouteName.appointmentPreviewScreen,
  arguments: _generatedAppointments,
);}
        }, text: "Generate Appointments"),
      ),
    );
  }
Widget listOfBreakTime() {
  return SizedBox(
    height: 100,
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: _selectedBreakTimes.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final breakTime = _selectedBreakTimes[index];
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(formatTimeOfDay(breakTime.start)),
                      Text(formatTimeOfDay(breakTime.end)),
                      
                      Expanded(
                        child: ElevatedButton(child: const Text("Delete"),
                          onPressed: (){ setState(() {
                          _selectedBreakTimes.removeAt(index);
                        },
                        
                        );
                        
                        },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            
          ],
        );
      },
    ),
  );
}


  Widget timeCard(VoidCallback onPressed,String text,TimeOfDay time){
 return Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(Icons.schedule),
                                 
                                  FittedBox(
                                    child: Text(
                                     text,
                                     
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap : onPressed,
                              
                              child: Text(
                                formatTimeOfDay(time),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
  }

  
  static List<Appointment> generateAppointments({
    required DateTime selectedDate,
    required TimeOfDay selectedOpeningTime,
    required TimeOfDay selectedClosingTime,
    required List<TimeOfDayRange> selectedBreakTimes,
    required int duration,
    required Doctor doctor
  }) {
    
    List<Appointment> appointments = [];
    DateTime startTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedOpeningTime.hour,
      selectedOpeningTime.minute,
    );
    DateTime endTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedClosingTime.hour,
      selectedClosingTime.minute,
    );

    while (startTime.isBefore(endTime)) {
      Duration adjustedTime = Duration(minutes: duration);
      bool isBreakTime = false;
      for (TimeOfDayRange breakTime in selectedBreakTimes) {
        DateTime breakStart = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          breakTime.start.hour,
          breakTime.start.minute,
        );
        DateTime breakEnd = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          breakTime.end.hour,
          breakTime.end.minute,
        );
       DateTime breakending  = startTime.add(Duration(minutes: duration));
        if (startTime.isAtSameMomentAs(breakStart) ||
            (startTime.isAfter(breakStart) && startTime.isBefore(breakEnd)) || (breakending.isAfter(breakStart) && breakending.isBefore(breakEnd))) {
          isBreakTime = true;
          adjustedTime = breakEnd.difference(startTime);
          break;
        }
        if (breakending.isAfter(endTime)){
          isBreakTime = true;
        }
      }
      if (!isBreakTime) {

        appointments.add(Appointment(
          providerId: doctor.hospitalId, 
          timeSlotDuration: duration,
          doctorid: doctor.id, 
          appointmentDate: startTime,
          isBooked: false,
         
        ));
      }
      startTime = startTime.add(adjustedTime);
    }
   
    return appointments;
  }

  

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dateTime);
  }
}

class TimeOfDayRange {
  final TimeOfDay start;
  final TimeOfDay end;

  TimeOfDayRange({required this.start, required this.end});
}
