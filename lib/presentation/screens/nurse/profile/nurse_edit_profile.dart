import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/nurse/nurse/nurse_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medibookings/presentation/screens/Hospital/doctor/create_doctor_profile_screen.dart';
import 'package:medibookings/presentation/screens/common/textFormField.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/snack_bar.dart';
import 'package:medibookings/service/auth_service.dart';
import 'package:medibookings/service/nurse/nurse_service.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final NurseModel nurse;

  const EditProfileScreen({Key? key, required this.nurse}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
   Position? currentLocation;
    final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _biographyController;
  late TextEditingController _serviceRadiusController;
  final TextEditingController _addressController = TextEditingController();
   GeoPoint? address;
  String? profileUrl;
  DateTime? _selectedDateOfBirth;
  DateTime? _selectedStartDateOfService;
  bool isLoading  = false;
    bool isLocationLoading = false;
  PlatformFile? _selectedFile;
  @override
  void initState() {
    super.initState();
      
    _firstNameController = TextEditingController(text: widget.nurse.firstName);
    _lastNameController = TextEditingController(text: widget.nurse.lastName);
    _phoneNumberController =
        TextEditingController(text: widget.nurse.phoneNumber.toString());
    _biographyController = TextEditingController(text: widget.nurse.biography);
    _serviceRadiusController =
        TextEditingController(text: widget.nurse.serviceRadius.toString());
    _selectedDateOfBirth = widget.nurse.dateOfBirth;
    _selectedStartDateOfService = widget.nurse.startDateOfService;
    profileUrl = widget.nurse.profileUrl;

     
          address =  widget.nurse.address!;
          if(address!= null){
            findPalce(address!);
          }
          
        
  }
 Future<void> findPalce(GeoPoint geoPoint)async{
  List<Placemark> placemarks =
          await placemarkFromCoordinates(geoPoint.latitude, geoPoint.longitude);
      String address =
          '${placemarks.first.name}, ${placemarks.first.locality}, ${placemarks.first.country}';
      setState(() {
        _addressController.text = address;
      });
 }
  @override
  Widget build(BuildContext context) {
    
    final nurseService = Provider.of<NurseService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: isLoading?commonLoading(): SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _selectFiles();
                },
                child: ClipOval(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ImageWidget(selectedFile: _selectedFile),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              textFormField(
                textEditingController: _firstNameController,
                decoration: defaultInputDecoration(hintText: 'First Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 8,
              ),
              textFormField(
                textEditingController: _lastNameController,
                decoration: defaultInputDecoration(hintText: 'Last Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 8,
              ),
              textFormField(
                textEditingController: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: defaultInputDecoration(hintText: 'Phone Number'),
                validator: (value) {
                  if (value != null) {
                    if (int.tryParse(value) == null) {
                      return 'Must be number';
                    } else if (value.length > 10) {
                      return 'Contact number must be less than 10 digits long.';
                    } else if (value.length < 10) {
                      return 'Contact number must be at least 10 digits long.';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 8,
              ),
              textFormField(
                textEditingController: _biographyController,
                maxLine: 5,
                maxLength: 500,
                decoration: defaultInputDecoration(hintText: 'Biography'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your biography';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 8,
              ),
              textFormField(
                textEditingController: _serviceRadiusController,
                keyboardType: TextInputType.number,
                decoration: defaultInputDecoration(hintText: 'Service Radius'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your service radius';
                  }
          
                  if (double.tryParse(value!) == null) {
                    return 'Please enter a valid number';
                  }
          
                  return null;
                },
              ),
              SizedBox(
                height: 8,
              ),
               GooglePlaceAutoCompleteTextField(
                  textEditingController: _addressController,
                  googleAPIKey: google_place_key,
                  inputDecoration:
                      defaultInputDecoration(hintText: 'Address')
                          .copyWith(
                    suffixIcon: isLocationLoading
                        ? Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: commonLoadingBase(),
                          )
                        : IconButton(
                            icon: const Icon(Icons.location_on),
                            onPressed: _getCurrentLocation,
                          ),
                  ),
                  debounceTime: 800,
                  boxDecoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  containerVerticalPadding: 0,
                  countries: const ["ca"],
                  isLatLngRequired: true,
                  getPlaceDetailWithLatLng: (Prediction prediction) {
                    address = GeoPoint(double.tryParse(prediction.lat!)!,
                        double.tryParse(prediction.lng!)!);
                  },
                  itemClick: (Prediction prediction) {
                    _addressController.text = prediction.description!;
            
                    _addressController.selection = TextSelection.fromPosition(
                        TextPosition(offset: prediction.description!.length));
                  },
                  itemBuilder: (context, index, Prediction prediction) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(width: 7),
                          Expanded(
                              child: Text(prediction.description ?? "")),
                        ],
                      ),
                    );
                  },
                  seperatedBuilder: const Divider(),
                  isCrossBtnShown: false,
                ),
               
               SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(12.0),
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                  onTap: () =>
                      _selectDate(context, 'Date of Birth', _selectedDateOfBirth),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date of Birth:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        _selectedDateOfBirth != null
                            ? '${_selectedDateOfBirth!.year}-${_selectedDateOfBirth!.month.toString().padLeft(2, '0')}-${_selectedDateOfBirth!.day.toString().padLeft(2, '0')}'
                            : 'Select Date',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
             
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(12.0),
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                  onTap: () => _selectDate(context, 'Start Date of Service',
                      _selectedStartDateOfService),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Start Date of Service:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        _selectedStartDateOfService != null
                            ? '${_selectedStartDateOfService!.year}-${_selectedStartDateOfService!.month.toString().padLeft(2, '0')}-${_selectedStartDateOfService!.day.toString().padLeft(2, '0')}'
                            : 'Select Date',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
              basicButton(
                onPressed:()async{
                 try{
                  setState(() {
                    isLoading = true;
                  });
                   await _updateProfile(nurseService);
                   Navigator.pop(context);
                   
                 }catch(e){
                  custom_snackBar(context, 'Fail to update data');
                 }
                 finally{
                  setState(() {
                    isLoading = false;
                  });

                 }
                },
                text: 'Save Changes',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, String title, DateTime? initialDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        if (title == 'Date of Birth') {
          _selectedDateOfBirth = pickedDate;
        } else {
          _selectedStartDateOfService = pickedDate;
        }
      });
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

  Future<void> _updateProfile(NurseService  nurseService) async {
    
    if(_formKey.currentState!.validate()){
      AuthService authService = AuthService();
    String? profileURL = '';
    if (_selectedFile != null) {
      profileURL = await authService.uploadFile(_selectedFile!);
    }
        NurseModel nurseModel = updateModel(profileURL!);
        await nurseService.updateNurseProfile(nurseModel);
        
    }
  }
  NurseModel updateModel(String profileUrl){
    return NurseModel(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phoneNumber: int.parse(_phoneNumberController.text),
      biography: _biographyController.text,
      dateOfBirth: _selectedDateOfBirth,
      startDateOfService: _selectedStartDateOfService,
      isVerify: widget.nurse.isVerify,
      isOnline: widget.nurse.isOnline,
      serviceRadius: double.parse(_serviceRadiusController.text),
      documentLinks: widget.nurse.documentLinks,
      fcmtoken: widget.nurse.fcmtoken,
      profileUrl: _selectedFile!= null ? profileUrl: widget.nurse.profileUrl,
      address: address?? widget.nurse.address,
        listOfService:widget.nurse.listOfService,
      perHourCharge: widget.nurse.perHourCharge,
    );

   
  }
 Future<void> _getCurrentLocation() async {
    setState(() {
      isLocationLoading = true;
    });

    try {
      final Position position = await _determinePosition();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      String address =
          '${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}';
      setState(() {
        currentLocation = position;
        _addressController.text = address;
        print("address as $address");
      });
    } catch (e) {
      print('Error getting current location: $e');
      // Handle error
    } finally {
      setState(() {
        isLocationLoading = false;
      });
    }
  }
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied, we cannot request permissions.';
    }

    return await Geolocator.getCurrentPosition();
  }
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _biographyController.dispose();
    super.dispose();
  }
}
