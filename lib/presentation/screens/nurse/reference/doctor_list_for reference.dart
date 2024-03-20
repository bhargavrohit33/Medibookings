import 'package:flutter/material.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/model/hospital/doctor/doctorModel.dart';
import 'package:medibookings/model/route_model.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/custom_appbar.dart';
import 'package:medibookings/presentation/widget/somethin_went_wrong.dart';
import 'package:medibookings/service/hospital/doctor.service.dart';


import 'package:provider/provider.dart'; 

class DoctorListForReferenceWidget extends StatelessWidget {
  
  String hospitalId;

   DoctorListForReferenceWidget({super.key, required this.hospitalId});

  @override
  Widget build(BuildContext context) {
    final doctorService = Provider.of<DoctorService>(context);
   
    return Scaffold(
      appBar: CustomAppBar(title: "Doctors"),
      body: StreamBuilder<List<Doctor>>(
        stream: doctorService.getDoctorsByHospitalIdStream(hospitalId:hospitalId ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return commonLoading();
          } else if (snapshot.hasError) {
            return SomethingWentWrongWidget(
            superContext: context,
          ); 
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No doctors found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final doctor = snapshot.data![index];
                return InkWell(
                  onTap: ()async {
                    
                     DoctorArugument routeArguments = DoctorArugument( hospitalId: hospitalId, doctorId:  snapshot.data![index].id,isUSerCanBookAppointment: true) ;
                     Navigator.pushNamed(context, RouteName.doctorCalenderInreference,arguments: routeArguments);
                  },
                  child: DoctorItemCard(doctor: doctor),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class DoctorItemCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorItemCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text('${doctor.firstName} ${doctor.lastName}'),
        subtitle: Text(doctor.specialization),
      ),
    );
  }
}
