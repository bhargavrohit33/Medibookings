import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:medibookings/screens/button.dart';


class AppointmentBookingPage extends StatefulWidget {
  const AppointmentBookingPage({super.key});

  @override
  _AppointmentBookingPageState createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
  late DateTime _selectedDate;
  late List<String> _availableTimeSlots;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _availableTimeSlots = [];
    _loadAvailableTimeSlots(_selectedDate);
  }

  void _loadAvailableTimeSlots(DateTime selectedDate) {
    _availableTimeSlots = [
      '10:00 AM', '11:00 AM', '12:00 PM',
      '1:00 PM', '2:00 PM', '3:00 PM'
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCalendar(),
            const SizedBox(height: 20),
            const Text(
              'Available Time Slots:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTimeSlots(),
            const SizedBox(height: 20),
            basicButton(
              onPressed: (){
                // _selectedIndex != null ? _bookAppointment : null
              },
              text: 'Confirm Appointment',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return SizedBox(
      height: 300,
      child: CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> events) {
          setState(() {
            _selectedDate = date;
            _loadAvailableTimeSlots(date);
            _selectedIndex = null;
          });
        },
        weekendTextStyle: const TextStyle(color: Colors.red),
        thisMonthDayBorderColor: Colors.grey,
        daysTextStyle: const TextStyle(color: Colors.black),
        headerTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
        selectedDateTime: _selectedDate,
        selectedDayButtonColor: Colors.blue,
        selectedDayTextStyle: const TextStyle(color: Colors.white),
        todayTextStyle: const TextStyle(color: Colors.blue),
        onCalendarChanged: (DateTime date) {
          // Handle calendar changes if needed
        },
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _availableTimeSlots.map((timeSlot) {
        final index = _availableTimeSlots.indexOf(timeSlot);
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: _selectedIndex == index
                  ? LinearGradient(
                colors: [Colors.blue.withOpacity(0.5), Colors.blue.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
                  : null,
              border: Border.all(color: Colors.grey),
            ),
            alignment: Alignment.center,
            child: Text(
              timeSlot,
              style: TextStyle(
                fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _bookAppointment() {
    // Add your logic here to book the appointment
    final selectedTimeSlot = _availableTimeSlots[_selectedIndex!];
    final formattedDate = '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
    // Show a popup message for booking confirmation
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Booking Confirmed',style: TextStyle(color: Colors.black)),
          content: Text('Appointment Confirmed on $formattedDate at $selectedTimeSlot',style: const TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK',style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
