import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:medibookings/common/utils.dart';
// Import your Firebase services
import 'package:medibookings/model/hospital/hospital/hospital_model.dart';
import 'package:medibookings/presentation/screens/common/textFormField.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/snack_bar.dart';
import 'package:medibookings/service/hospital/hospital_service.dart';
import 'package:provider/provider.dart';
// Import your Hospital model

class HospitalProfileUpdatePage extends StatefulWidget {
  HospitalProfileUpdatePage({
    Key? key,
  }) : super(key: key);

  @override
  _HospitalProfileUpdatePageState createState() =>
      _HospitalProfileUpdatePageState();
}

class _HospitalProfileUpdatePageState extends State<HospitalProfileUpdatePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  GeoPoint? addressGeoPoint;
  Position? currentLocation;
  bool isLocationLoading = false;
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final hospitalProvider =
          Provider.of<HospitalService>(context, listen: false);
      // Populate the text controllers with current hospital data
      _nameController.text = hospitalProvider.hospitalModel!.name;
      addressGeoPoint =
          addressGeoPoint = hospitalProvider.hospitalModel!.address;
          if(addressGeoPoint!= null){
            findPalce(addressGeoPoint!);
          }
          
           if (hospitalProvider.hospitalModel!.contactNumber.toString().length ==10){
            _contactController.text = hospitalProvider.hospitalModel!.contactNumber.toString();
           }
      
    });
    // // Populate the text controllers with current hospital data
    // _nameController.text = hospitalProvider.hospitalModel!.name;
    // _addressController.text = widget.hospital.address;
    // _contactController.text = widget.hospital.contact;
  }

  @override
  Widget build(BuildContext context) {
     final hospitalProvider =
          Provider.of<HospitalService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Hospital'),
      ),
      body: Form(
         key: _formKey,
        child: isLoading?commonLoading(): SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                textFormField(
                  textEditingController: _nameController,
                  decoration: defaultInputDecoration(hintText: 'Hospital Name'),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(),
                
                textFormField(
                  textEditingController: _contactController,
                  decoration: defaultInputDecoration(hintText: 'Contact'),
                  keyboardType: TextInputType.phone,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  // ],
                  maxLength: 10,
                  validator: (value) {
                    if (value != null ) {
                      if (int.tryParse(value)== null){
                          return 'Must be numberasd';
                      }
                      else if (value.length > 10) {
                        return 'Contact number must be less than 10 digits long.';
                      }
                      else if (value.length < 10) {
                        return 'Contact number must be at least 10 digits long.';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                GooglePlaceAutoCompleteTextField(
                  textEditingController: _addressController,
                  googleAPIKey: google_place_key,
                  inputDecoration:
                      defaultInputDecoration(hintText: 'Hospital Address')
                          .copyWith(
                    suffixIcon: isLocationLoading
                        ? Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: commonLoadingBase(),
                          )
                        : IconButton(
                            icon: Icon(Icons.location_on),
                            onPressed: _getCurrentLocation,
                          ),
                  ),
                  debounceTime: 800,
                  boxDecoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  containerVerticalPadding: 0,
                  countries: ["ca"],
                  isLatLngRequired: true,
                  getPlaceDetailWithLatLng: (Prediction prediction) {
                    addressGeoPoint = GeoPoint(double.tryParse(prediction.lat!)!,
                        double.tryParse(prediction.lng!)!);
                  },
                  itemClick: (Prediction prediction) {
                    _addressController.text = prediction.description!;
            
                    _addressController.selection = TextSelection.fromPosition(
                        TextPosition(offset: prediction.description!.length));
                  },
                  itemBuilder: (context, index, Prediction prediction) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(Icons.location_on),
                          SizedBox(width: 7),
                          Expanded(
                              child: Text("${prediction.description ?? ""}")),
                        ],
                      ),
                    );
                  },
                  seperatedBuilder: Divider(),
                  isCrossBtnShown: false,
                ),
                SizedBox(height: 16.0),
               
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: basicButton(
            onPressed: () async{
              if(_formKey.currentState!.validate() && !isLoading){ 
                setState(() {
                  isLoading = true;
                });
               try{
                await hospitalProvider.updateHospitalProfile(_nameController.text, int.parse(_contactController.text), addressGeoPoint!);
               }catch(e){
                print(e.toString());
                 custom_snackBar(context, "Failed to update data");
               }finally{
                setState(() {
                  isLoading = false;
                });
               }
              }
            },
            text: 'Update',
          ),
      ),
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
          '${placemarks.first.name}, ${placemarks.first.locality}, ${placemarks.first.country}';
      setState(() {
        currentLocation = position;
        _addressController.text = address;
        print("address as ${address}");
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
  
 Future<void> findPalce(GeoPoint geoPoint)async{
  List<Placemark> placemarks =
          await placemarkFromCoordinates(geoPoint.latitude, geoPoint.longitude);
      String address =
          '${placemarks.first.name}, ${placemarks.first.locality}, ${placemarks.first.country}';
      setState(() {
        _addressController.text = address;
      });
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
}
