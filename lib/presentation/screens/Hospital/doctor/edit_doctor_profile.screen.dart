

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';
import 'package:medibookings/presentation/screens/Hospital/doctor/create_doctor_profile_screen.dart';
import 'package:medibookings/presentation/screens/common/textFormField.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/service/hospital/doctor.service.dart';
import 'package:provider/provider.dart';


class EditDoctorProfileScreen extends StatefulWidget {
  final Doctor doctor;

  const EditDoctorProfileScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  State<EditDoctorProfileScreen> createState() => _EditDoctorProfileScreenState();
}

class _EditDoctorProfileScreenState extends State<EditDoctorProfileScreen> {
  PlatformFile? _selectedFile;
  String? selectedSpecialty;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.doctor.firstName);
    lastNameController = TextEditingController(text: widget.doctor.lastName);
    
    selectedSpecialty = widget.doctor.specialization;
    if (widget.doctor.profilePhoto != null) {
      _selectedFile = PlatformFile(
        path: widget.doctor.profilePhoto!,
        name: 'profile_picture',
        size: 50,
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

  @override
  Widget build(BuildContext context) {
    final doctorService = Provider.of<DoctorService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Doctor Profile'),
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
                  const SizedBox(height: 16,),
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
                  const SizedBox(height: 16),
                  basicButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                         setState(() {
                            _isLoading = false;
                          });
                        String firstName = firstNameController.text;
                        String lastName = lastNameController.text;
                        String specialty = selectedSpecialty ?? '';
                        String? profilePicture = _selectedFile?.path;
                        Doctor updatedDoctor = Doctor(
                          id: widget.doctor.id,
                          firstName: firstName,
                          lastName: lastName,
                          specialization: specialty,
                          profilePhoto: profilePicture,
                          hospitalId: widget.doctor.hospitalId,
                        );
            
                        try {
                          await doctorService.editDoctorProfile(
                            widget.doctor.id,
                            firstName,
                            lastName,
                            specialty,
                            file: _selectedFile,
                          );
            
                          Navigator.pop(context);
                        } catch (e) {
                          print('Error updating doctor profile: $e');
                        }finally{
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                    text: 'Update Profile',
                  )
                ],
              ),
            ),
           if (_isLoading)
            commonLoading()
          ],
        ),
      ),
    );
  }
}
