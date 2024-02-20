import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/presentation/screens/common/textFormField.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:file_picker/file_picker.dart';

class CreateDoctorProfileScreen extends StatefulWidget {
  @override
  State<CreateDoctorProfileScreen> createState() => _CreateDoctorProfileScreenState();
}

class _CreateDoctorProfileScreenState extends State<CreateDoctorProfileScreen> {
  PlatformFile? _selectedFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
     
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
       
      });
    }
  }

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController specialtyController = TextEditingController();
  String? selectedSpecialty;
  List<String> specialtyOptions = [
    'Cardiology',
    'Dermatology',
    'Endocrinology',
    'Gastroenterology',
    'Hematology',
    'Neurology',
    'Oncology',
    'Pediatrics',
    // Add more specialties as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Doctor Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              textFormField(
                textEditingController: firstNameController,
                decoration: defaultInputDecoration(hintText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              textFormField(
                textEditingController: lastNameController,
                decoration: defaultInputDecoration(hintText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField(
                decoration: defaultInputDecoration(hintText: 'Specialty'),
                value: selectedSpecialty,
                onChanged: (newValue) {
                  setState(() {
                    selectedSpecialty = newValue as String?;
                  });
                },
                items: specialtyOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  _selectFiles();
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ImageWidget(selectedFile: _selectedFile), // Use ImageWidget here
                ),
              ),
              SizedBox(height: 16),
              basicButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Add logic to save doctor profile
                  }
                },
                text: 'Save Profile',
              )
            ],
          ),
        ),
      ),
    );
  }
}


class ImageWidget extends StatelessWidget {
  final PlatformFile? selectedFile;

  const ImageWidget({Key? key, this.selectedFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if (selectedFile != null ) {
      return Image.file(
        File(selectedFile!.path!),
        fit: BoxFit.cover,
      );
    } else {
      return Icon(
        Icons.add_a_photo,
        size: 40,
      );
    }
  }
}
