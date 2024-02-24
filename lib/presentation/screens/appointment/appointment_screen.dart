import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late DateTime _selectedDate;
  late Map<DateTime, List<String>> _events;
  late List<String> _availableTimeSlots;
  late String _selectedTimeSlot;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _events = {};
    _availableTimeSlots = [];
    _selectedTimeSlot = '';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar(
            focusedDay: _selectedDate,
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 30)),
            calendarFormat: CalendarFormat.week,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
                _availableTimeSlots = _events[selectedDay] ?? [];
                _selectedTimeSlot = _availableTimeSlots.isNotEmpty ? _availableTimeSlots.first : '';
              });
            },
            eventLoader: (day) {
              return _events[day] ?? [];
            },
          ),
          const SizedBox(height: 20),
          const Text('Available Time Slots:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            children: _availableTimeSlots
                .map(
                  (timeSlot) => GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTimeSlot = timeSlot;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: timeSlot == _selectedTimeSlot ? Colors.blue.withOpacity(0.3) : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(timeSlot),
                ),
              ),
            )
                .toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _bookAppointment();
            },
            child: const Text('Book Appointment'),
          ),
        ],
      ),
    );
  }

  void _bookAppointment() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Appointment Booked'),
          content: Text('You have successfully booked an appointment for $_selectedDate at $_selectedTimeSlot.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
