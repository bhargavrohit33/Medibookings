import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About MediBookings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.blue),
              ),
              SizedBox(height: 16),
              Text(
                'Welcome to MediBookings, your trusted healthcare companion! Our mission is to make it easier for you to manage your medical appointments and connect with healthcare providers in your area.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Key Features:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.blue),
              ),
              SizedBox(height: 8),
              Text(
                '- Schedule appointments with healthcare professionals seamlessly.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '- Receive reminders and notifications for upcoming appointments.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '- View and manage your medical history and records securely.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'We are dedicated to providing you with a user-friendly platform that prioritizes your health and well-being. With MediBookings, you can focus on what matters most – your health.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Thank you for choosing MediBookings!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
