import 'package:flutter/material.dart';
import 'package:medibookings/model/nurse/nurse/nurse_model.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/custom_appbar.dart';
import 'package:medibookings/presentation/widget/somethin_went_wrong.dart';
import 'package:medibookings/service/nurse/nurse_service.dart';
import 'package:provider/provider.dart';

class ServiceListPage extends StatefulWidget {
  @override
  _ServiceListPageState createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  String? _selectedService;
 
  final List<String> _nurseServices = const [
    "Primary Care",
    "Clinical Care",
    "Specialty Care",
    "Patient Advocacy",
    "Health Education and Counseling",
    "Coordination of Care",
    "Public Health and Community Outreach",
    "Research and Quality Improvement",
    "Leadership and Management",
    "Emergency Care"
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nurseProvider = Provider.of<NurseService>(context);
    return Scaffold(
      appBar: CustomAppBar(title: "Service"),
      body: StreamBuilder<NurseModel>(
        stream: nurseProvider.getNurseProfile,
        builder: (context, nurseSnapshot,) {
          if(nurseSnapshot.hasData)
          {
          return Column(
            children: [
            Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButton<String>(
        
        value: _selectedService,
        onChanged: (newValue)async {
          _selectedService = newValue;
          nurseSnapshot.data!.listOfService.add(_selectedService!);
                          await nurseProvider.updateNurseProfile(nurseSnapshot.data!);
         
        },
        dropdownColor: theme.scaffoldBackgroundColor,
        items: _nurseServices.map<DropdownMenuItem<String>>((service) {
          return DropdownMenuItem<String>(
            value: service,
            child: Text(service),
          );
        }).toList(),
      ),
            ),
              Expanded(
                child: ListView.builder(
                  itemCount: nurseSnapshot.data!.listOfService.length,
                  itemBuilder: (context, index) {
                    final service = nurseSnapshot.data!.listOfService.toList()[index];
                    return Card(
                      child: ListTile(
                        title: Text(service),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: ()async {
                           nurseSnapshot.data!.listOfService.remove(service!);
                          
                            await nurseProvider.updateNurseProfile(nurseSnapshot.data!);
                           
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
       }else if(nurseSnapshot.hasError){
        return SomethingWentWrongWidget(superContext: context);
       } else{
        return commonLoading();
       }},
      ),
      
    );
  }
}


