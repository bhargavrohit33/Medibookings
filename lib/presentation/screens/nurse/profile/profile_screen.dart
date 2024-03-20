import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/nurse/nurse/nurse_model.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/images_widgets.dart';
import 'package:medibookings/presentation/widget/somethin_went_wrong.dart';
import 'package:medibookings/service/nurse/nurse_service.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nurseService = Provider.of<NurseService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nurse Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.lightBlue),
        ),
      ),
      body: StreamBuilder<NurseModel>(
        stream: nurseService.getNurseProfile,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            Duration differnce  = snapshot.data!.startDateOfService!.difference(DateTime.now());
            return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            capitalizeFirstLetter(snapshot.data!.firstName).toString() +" "+ capitalizeFirstLetter(snapshot.data!.lastName),
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Text(differnce.inDays.toString()),
                                    
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Add functionality for favorite
                                },
                                icon: const Icon(Icons.favorite_border),
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Address: 60 Frederick Street'),
                                    Text('City: Kitchener'),
                                    Text('Province: Ontario'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: const Padding(
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
                            'I am a dedicated healthcare provider with years of experience in providing exceptional care to patients. My compassionate approach and extensive knowledge make me a reliable and trustworthy member of the medical team. I am skilled in various medical procedures and always strive to ensure the well-being of my patients.',
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Working Time',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Monday - Friday: 9:00 AM - 5:00 PM\nSaturday: 9:00 AM - 1:00 PM\nSunday: Closed',
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          
                basicButton(onPressed: ()async{
          
                  Navigator.pushNamed(context, RouteName.nurseEditProfileScreen,arguments:snapshot.data );
                }, text: "Edit Profile")
              ],
            ),
          );
          }else if(snapshot.hasData){
            return SomethingWentWrongWidget(superContext: context);
          }else{
            return commonLoading();
          }
        }
      ),
    );
  }
}