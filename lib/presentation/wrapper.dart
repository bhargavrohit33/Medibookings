import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medibookings/model/nurse/nurse/nurse_model.dart';
import 'package:medibookings/presentation/screens/Hospital/home/hospital_wrapper_screen.dart';
import 'package:medibookings/presentation/screens/auth/account_not_verified_screen.dart';
import 'package:medibookings/presentation/screens/nurse/home/home_screen.dart';
import 'package:medibookings/presentation/screens/upload_document/upload_documents_screen.dart';
import 'package:medibookings/presentation/screens/welcome/welcome_screen.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/somethin_went_wrong.dart';
import 'package:medibookings/service/auth_service.dart';
import 'package:medibookings/service/hospital/hospital_service.dart';
import 'package:medibookings/service/nurse/nurse_service.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
      
    final authService =
        Provider.of<AuthService>(context, listen: true);
        final hospitalService =
        Provider.of<HospitalService>(context, listen: true);
        final nurseService  =
        Provider.of<NurseService>(context, listen: true);
    return StreamBuilder<User?>(stream: authService.authStream, builder: (context,snapshot){
      if (snapshot.connectionState == ConnectionState.waiting){
        return commonLoading();
      }
     
      else if(snapshot.hasData ){
         return FutureBuilder<bool>(
            future: hospitalService.checkHospitalExistsByUID(snapshot.data!.uid.toString()),
            builder: (context, futureSnapshot) {
             
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return commonLoading();
              } else if (futureSnapshot.hasData ) {

                if ( hospitalService.hospitalModel!.documentLinks.isEmpty){
                  return   UploadDocumentsScreen(isFromNurse: false,);
                }else if (hospitalService.hospitalModel!.isVerified == false ){
                return  const AccountNotVerifiedScreen();
                }
                else{
                  return const HospitalWrapperScreen();
                }
               
              } 
              else {
                return StreamBuilder<NurseModel>(
                  stream: nurseService.getNurseProfile,
                  builder: (context, nurseSnapshot) {
                   
                    if(nurseSnapshot.hasData){
                      return const NurseHomePage();
                    }
                    else  if(nurseSnapshot.hasError){
                      return SomethingWentWrongWidget(superContext: context,message: "Fail to fetch nurse profile",);
                    }
                    else{
                      return commonLoading();
                    }
                  }
                );
                
              }
            },
          );
        
         
      }
      else{
        return const  WelcomeScreen();
      }

    });
  }
}
