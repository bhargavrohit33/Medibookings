import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/hospital/hospital_model.dart';
import 'package:medibookings/presentation/screens/common/textFormField.dart';
import 'package:medibookings/presentation/screens/reference/hospital_item.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/custom_appbar.dart';
import 'package:medibookings/service/hospital/hospital_service.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HospitalList extends StatefulWidget {
  const HospitalList({super.key});

  @override
  State<HospitalList> createState() => _HospitalListState();
}

class _HospitalListState extends State<HospitalList> {
 
String searchValue = '';
  @override
  Widget build(BuildContext context) {
    final hospitalService = Provider.of<HospitalService>(context);
    
    final size= MediaQuery.of(context).size;
     return Scaffold(
      appBar: CustomAppBar(title: "Hospitals"),
       body: Column(
         children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(onChanged: (c){
              setState(() {
                  searchValue =c;
                 
              });
            },decoration: defaultInputDecoration(hintText: "Search")),
          ),
          
           Expanded(
             child: StreamBuilder<List<HospitalModel>>(
                  stream: hospitalService.hospitalsByPartialNameStream(searchValue),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting){
                       return commonLoading();
                    }
                    else if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                            Navigator.pushNamed(context, RouteName.doctorListForReferenceScreen,arguments: snapshot.data![index].id);
                            },
                            child: HospitalItemWidget(hospitalModel: snapshot.data![index]));
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else {
                      return commonLoading();
                    }
                  },
                ),
           ),
         ],
       ),
     );
  }

}

