import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medibookings/common/app_colors.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/shimera_widget.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/nurse/nurse/nurse_model.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/images_widgets.dart';
import 'package:medibookings/presentation/widget/somethin_went_wrong.dart';
import 'package:medibookings/service/nurse/nurse_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLocationLoading = false;
  @override
  Widget build(BuildContext context) {
    final nurseService = Provider.of<NurseService>(context);
    final size = MediaQuery.of(context).size;
    return StreamBuilder<NurseModel>(
      stream: nurseService.getNurseProfile,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          Duration differnce  = DateTime.now().difference(snapshot.data!.startDateOfService??DateTime.now());
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                          
                   //  if(snapshot.data!.isVerify == true)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(cardRadius)
                    ),
                    child: ListTile(
                            title: const Text('Online'),
                            trailing: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Switch(
                                value:  snapshot.data!.isOnline,
                                onChanged: (value) async {
                                  NurseModel nurseModel = snapshot.data!;
                                  nurseModel.isOnline = value;
                                 await nurseService.updateNurseProfile(nurseModel);
                                },
                              ),
                            ),
                             leading: Padding(
                               padding: const EdgeInsets.all(0),
                               child: snapshot.data!.isOnline ? Icon(Icons.online_prediction,color: Colors.green,) : Icon(Icons.offline_bolt,color: Colors.red,),
                             ),
                          ),
                  ),
                  const SizedBox(height: 10),
                          
                          
                  if(snapshot.data!.isVerify == false)
                  Column(
                    children: [
                      Text('Your profile is not verified.',style: TextStyle(color: Colors.red),),
                      SizedBox(height: 10,)
                    ],
                  ),
                 
                   const SizedBox(height: 20),
                  Center(
                    child: Card(
                      
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
                      child: ClipOval(
                        child: ImageWithPlaceholder(height: 160,width: 160,imageUrl: nurseService.nurseModel!.profileUrl!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        width: size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              capitalizeFirstLetter(snapshot.data!.firstName).toString() +" "+ capitalizeFirstLetter(snapshot.data!.lastName),
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Experience'),
                                   const SizedBox(height: 10),
                                 Text(getDurationString(differnce)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder< List<Placemark>?>(
                            future: _getCurrentLocation(snapshot.data!.address!),
                            builder: (context, addressSnapshot) {
                              if (addressSnapshot.connectionState == ConnectionState.waiting){
                                return Container();
                              }else if(addressSnapshot.hasError){
                                return SomethingWentWrongWidget(superContext: context);
                              }
                              else {
                             return   addressSnapshot.data== null?Container(width: size.width,child: Text("Please set location")):
                               Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.orange,
                                    ),
                                    child: const Icon(Icons.location_on, color: Colors.white),
                                  ),
                                  const SizedBox(width: 10),
                                 Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(' ${addressSnapshot.data!.first.street}'),
                                        Text(' ${addressSnapshot.data!.first.subLocality}'),
                                       Text(' ${addressSnapshot.data!.first.subAdministrativeArea}'),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }}
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: size.width,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child:  Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          
                          children: [
                            Text(
                              'Biography',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              snapshot.data!.biography!,
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (snapshot.data!.documentLinks != null &&
                  snapshot.data!.documentLinks!.length > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Document Count: ${snapshot.data!.documentLinks!.length}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    for (var i = 0; i < snapshot.data!.documentLinks!.length; i++)
                      Card(
                        child: ListTile(
                          title: Text(
                            'Document ${i + 1}',
                          ),
                          onTap: () {
                            downloadDocument(snapshot.data!.documentLinks![i]);
                          },
                        ),
                      ),
                  ],
                                ),
                ),
              
                        
                  basicButton(onPressed: ()async{
                        
                    Navigator.pushNamed(context, RouteName.nurseEditProfileScreen,arguments:snapshot.data );
                  }, text: "Edit Profile")
                ],
              ),
            ),
          );
        }else if(snapshot.hasData){
          return SomethingWentWrongWidget(superContext: context);
        }else{
          return commonLoading();
        }
      }
    );
  }

  String getDurationString(Duration difference) {
  int years = difference.inDays ~/ 365;
  int months = (difference.inDays % 365) ~/ 30;

  String durationString;

  // Display the duration in years and months
  if (years > 0) {
    if (months > 0) {
      durationString = '$years years and $months months';
    } else {
      durationString = '$years years';
    }
  } else {
    durationString = '$months months';
  }

  return durationString;
}

 Future< List<Placemark>?> _getCurrentLocation(GeoPoint geoPoint) async {
    

    try {
      final Position position = Position(longitude: geoPoint.longitude, latitude: geoPoint.latitude, timestamp: DateTime.now(), accuracy: 0, altitude: 0, altitudeAccuracy: 0, heading: 0, headingAccuracy: 0, speed: 0, speedAccuracy: 0);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
   return placemarks;
     
    } catch (e) {
      print('Error getting current location: $e');
     return null;
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
  Future<void> downloadDocument(String url) async {
  // Request permission to access storage
  var status = await Permission.storage.request();
  if (status.isDenied) {
    print('Permission to access storage denied');
    return;
  }


  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;

 
  String fileName = url.split('/').last;

 
  String filePath = '$tempPath/$fileName';

  
  if (await File(filePath).exists()) {
    print('File already exists');
    return;
  }

  // Download the file
  try {
    final ref = FirebaseStorage.instance.refFromURL(
    url);
    final link = await ref.getDownloadURL();

    final taskId = await FlutterDownloader.enqueue(
      url: link.toString(),
      savedDir: tempPath,
      fileName: fileName,
      showNotification: true,
      openFileFromNotification: true,
    );

    print('Download task id: $taskId');
  } catch (e) {
    print('Failed to download file: $e');
  }
}
}