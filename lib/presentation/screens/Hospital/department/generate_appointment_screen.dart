import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/presentation/screens/common/textFormField.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/custom_appbar.dart';

class GenerateAppointmentScreen extends StatefulWidget {
  const GenerateAppointmentScreen({super.key});

  @override
  _GenerateAppointmentScreenState createState() => _GenerateAppointmentScreenState();
}

class _GenerateAppointmentScreenState extends State<GenerateAppointmentScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedOpeningTime = const TimeOfDay(hour: 9, minute: 0);
  final TimeOfDay _selectedClosingTime = const TimeOfDay(hour: 17, minute: 0);
  final List<TimeOfDayRange> _selectedBreakTimes = [];
  final List<DateTime> _generatedAppointments = [];
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
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.schedule),
                                const SizedBox(width: 5,),
                                FittedBox(
                                  child: Text(
                                   text,
                                   
                                  ),
                                ),
                              ],
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
