import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/presentation/screens/common/textFormField.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/snack_bar.dart';
import 'package:medibookings/service/hospital/doctor.service.dart';

class CreateDoctorProfileScreen extends StatefulWidget {
  const CreateDoctorProfileScreen({super.key});

  @override
  State<CreateDoctorProfileScreen> createState() =>
      _CreateDoctorProfileScreenState();
}

class _CreateDoctorProfileScreenState extends State<CreateDoctorProfileScreen> {
  PlatformFile? _selectedFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool _isSaving = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Doctor Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Form(
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
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  DropdownButtonFormField(
                    decoration: defaultInputDecoration(hintText: 'Specialty'),
                    value: selectedSpecialty,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select the Specialty';
                      }
                    },
                    onChanged: (newValue) {
                      setState(() {
                        selectedSpecialty = newValue;
                      });
                    },
                    items: specialtyOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
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
                      child: ImageWidget(
                          selectedFile: _selectedFile), // Use ImageWidget here
                    ),
                  ),
                  const SizedBox(height: 16),
                  basicButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                  _isSaving = true;
                });
                        final firstName = firstNameController.text;
                        final lastName = lastNameController.text;
                        final specialty = selectedSpecialty!;
                        
            
                        try {
                          String? profilePhotoUrl;
                          if (_selectedFile != null) {}
                          await DoctorService().createDoctorProfile(
                              firstName, lastName, specialty,
                              file: _selectedFile);
                          custom_snackBar(context, 'Doctor profile created successfully');
                          Navigator.pop(context);
                        } catch (e) {
                         custom_snackBar(context, 'Failed to create doctor profile');
                          print('Error creating doctor profile: $e');
                          
                        }finally {
                  setState(() {
            _isSaving = false; 
                  });
                }
                      }
                    },
                    text: 'Save Profile',
                  )
                ],
              ),
            ),
            if (_isSaving)
            commonLoading()
          
          ],
        ),
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  final PlatformFile? selectedFile;

  const ImageWidget({super.key, this.selectedFile});

  @override
  Widget build(BuildContext context) {
    if (selectedFile != null) {
      return Image.file(
        File(selectedFile!.path!),
        fit: BoxFit.cover,
      );
    } else {
      return const Icon(
        Icons.add_a_photo,
        size: 40,
      );
    }
  }
}
