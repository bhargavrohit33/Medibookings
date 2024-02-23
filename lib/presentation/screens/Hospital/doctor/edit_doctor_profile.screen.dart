

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';
import 'package:medibookings/presentation/screens/Hospital/doctor/create_doctor_profile_screen.dart';
import 'package:medibookings/presentation/screens/common/textFormField.dart';
import 'package:medibookings/presentation/widget/button.dart';


class EditDoctorProfileScreen extends StatefulWidget {
  

  EditDoctorProfileScreen();

  @override
  State<EditDoctorProfileScreen> createState() => _EditDoctorProfileScreenState();
}

class _EditDoctorProfileScreenState extends State<EditDoctorProfileScreen> {
   Doctor doctor =Doctor(id: 1, firstName: 'Dr. Smith', lastName: '', specialty: 'Cardiology') ;
  PlatformFile? _selectedFile;
  String? selectedSpecialty ;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  
    firstNameController.text = doctor.firstName;
    lastNameController.text = doctor.lastName;
    specialtyController.text = doctor.specialty;
    
    if (doctor.profilePicture != null) {
      _selectedFile = PlatformFile(
        path: doctor.profilePicture!,
        name: 'profile_picture',
        size: 50
      );
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Doctor Profile'),
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
              SizedBox(height: 16,),
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
                  child: ImageWidget(selectedFile: _selectedFile), // Use ImageWidget to display profile picture
                ),
              ),
              SizedBox(height: 16),
              
              basicButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Get updated information
                    String firstName = firstNameController.text;
                    String lastName = lastNameController.text;
                    String specialty = specialtyController.text;
                    String? profilePicture =
                        _selectedFile != null ? _selectedFile!.path : null;

                    // Create updated Doctor object
                    Doctor updatedDoctor = Doctor(
                      id: doctor.id,
                      firstName: firstName,
                      lastName: lastName,
                      specialty: specialty,
                      profilePicture: profilePicture,
                    );

                    // TODO: Call updateDoctor method to update doctor information

                    // Navigate back
                    Navigator.pop(context);
                  }
                },
                text: 'Update Profile',
              )
            ],
          ),
        ),
      ),
    );
  }
}
