import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/hospital/hospital_model.dart';
import 'package:medibookings/presentation/widget/images_widgets.dart';
import 'package:medibookings/service/hospital/hospital_service.dart';

import 'package:provider/provider.dart';

class HospitalItemWidget extends StatelessWidget {
  final HospitalModel hospitalModel;

  const HospitalItemWidget({super.key, required this.hospitalModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hospitalService = Provider.of<HospitalService>(context);
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        child: Container(
          decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(cardRadius)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                hospitalModel.hospitalImages.isEmpty
                    ? NoImageWidget(
                        height: 80,
                        width: 80,
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: ImageWithPlaceholder(imageUrl: hospitalModel.hospitalImages.first,width: 80,height: 80),
                        ),
                      ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospitalModel.name.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<String?>(
                      future: getCityFromLocation(hospitalModel.address!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                            'Loading...',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          );
                        } else {
                          return Text(
                            snapshot.data ?? '',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      getDistance(
                              currentLocation: hospitalService.hospitalModel!.address!,
                              hospitalLocation: hospitalModel.address!)
                          .toString(),
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> getCityFromLocation(GeoPoint position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      String city = placemarks.first.locality ?? '';
      return city;
    } catch (e) {
      print('Error getting city from location: $e');
      return null;
    }
  }
}
double getDistance({required GeoPoint currentLocation,required GeoPoint hospitalLocation}) {

    double distanceInMeters = Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      hospitalLocation.latitude,
      hospitalLocation.longitude,
    );
    double distanceInKm = distanceInMeters / 1000;
  double roundedDistance = double.parse(distanceInKm.toStringAsFixed(2));
  
  return roundedDistance;
  }