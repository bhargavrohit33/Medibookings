import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/presentation/screens/common/textFormField.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/custom_appbar.dart';

class GenerateAppointmentScreen extends StatefulWidget {
  @override
  _GenerateAppointmentScreenState createState() => _GenerateAppointmentScreenState();
}

class _GenerateAppointmentScreenState extends State<GenerateAppointmentScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedOpeningTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _selectedClosingTime = TimeOfDay(hour: 17, minute: 0);
  List<TimeOfDayRange> _selectedBreakTimes = [];
  List<DateTime> _generatedAppointments = [];
  TextEditingController _durationOfAppointment = TextEditingController();
  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(title: "Generate Appointments"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
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
                  child: Container(
                    width: size.width ,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(
                      'Select Date:',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      DateFormat('MMMM dd, yyyy').format(_selectedDate),
                      style: TextStyle(fontSize: 16),
                    ),],),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               timeCard(() async{ 
                       
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: _selectedOpeningTime,
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
                          );
                          if (pickedTime != null && pickedTime != _selectedOpeningTime) {
                            setState(() {
                              _selectedOpeningTime = pickedTime;
                            });
                          }
                        
                      }, "Closing Time:", _selectedClosingTime),
                
              ],
            ),
            SizedBox(height: 20),
            Form(
              key: key,
              child: textFormField(textEditingController: _durationOfAppointment,
              keyboardType:TextInputType.numberWithOptions(),
               decoration: defaultInputDecoration(hintText: "Appointment duration"),
               validator: (v){
                if(int.tryParse(v!)== null){
                  return "Enter integer only";
                }
                return null;
              }),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Doctor Break Times:',
                  style: TextStyle(fontSize: 18),
                ),
                IconButton(onPressed: ()async{
                  final startTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (startTime != null) {
                        final endTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (endTime != null) {
                          setState(() {
                            _selectedBreakTimes.add(TimeOfDayRange(start: startTime, end: endTime));
                          });
                        }
                      }
                }, icon: Icon(Icons.add_circle))
              ],
            ),
            SizedBox(height: 10),

            if (_selectedBreakTimes.length > 0)
            listOfBreakTime(),
            
            
           
           
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: basicButton(onPressed: ()async{
          if (key.currentState!.validate()){
        await generateAppointments();
        
           Navigator.of(context).pushNamed(
  RouteName.appointmentPreviewScreen,
  arguments: _generatedAppointments,
);}
        }, text: "Generate Appointments"),
      ),
    );
  }
Widget listOfBreakTime() {
  return Container(
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
                        child: ElevatedButton(child: Text("Delete"),
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
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.schedule),
                                SizedBox(width: 5,),
                                FittedBox(
                                  child: Text(
                                   text,
                                   
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap : onPressed,
                              
                              child: Text(
                                formatTimeOfDay(time),
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
  }

  Future<void> generateAppointments() async{
    int? duration  = int.tryParse(_durationOfAppointment.text);
    _generatedAppointments.clear();

    DateTime startTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedOpeningTime.hour, _selectedOpeningTime.minute);
    DateTime endTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedClosingTime.hour, _selectedClosingTime.minute);

    while (startTime.isBefore(endTime)) {
      bool isBreakTime = false;
      for (TimeOfDayRange breakTime in _selectedBreakTimes) {
        DateTime breakStart = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, breakTime.start.hour, breakTime.start.minute);
        DateTime breakEnd = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, breakTime.end.hour, breakTime.end.minute);
        if (startTime.isAtSameMomentAs(breakStart) || (startTime.isAfter(breakStart) && startTime.isBefore(breakEnd))) {
          isBreakTime = true;
          break;
        }
      }
      if (!isBreakTime) {
        _generatedAppointments.add(startTime);
      }
      startTime = startTime.add(Duration(minutes:duration! )); // Adjust appointment duration here
    }

    setState(() {});
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
