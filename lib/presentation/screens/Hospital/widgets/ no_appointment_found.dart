import 'package:flutter/material.dart';

class NoAppointmentsFound extends StatelessWidget {
  const NoAppointmentsFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 50,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No appointments',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
