import 'package:flutter/material.dart';
import 'package:medibookings/screens/button.dart';


class SetAvailabilityPage extends StatefulWidget {
  const SetAvailabilityPage({super.key});

  @override
  _SetAvailabilityPageState createState() => _SetAvailabilityPageState();
}

class _SetAvailabilityPageState extends State<SetAvailabilityPage> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Availability', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            basicButton(
              onPressed: () {
                _selectDate(context);
              },
              text : _selectedDate.toString().substring(0, 10)
            ),
            const SizedBox(height: 20),
            Text(
              'Select Time Range:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: basicButton(
                    onPressed: () {
                      _selectTime(context, isStartTime: true);
                    },
                    text:(_startTime.format(context)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: basicButton(
                    onPressed: () {
                      _selectTime(context, isStartTime: false);
                    },
                    text:(_endTime.format(context)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            basicButton(
              onPressed: () {
                //
              },
              color: Colors.blue,
              text: 'Set Availability',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, {required bool isStartTime}) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    }
  }
}
