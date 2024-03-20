import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medibookings/presentation/screens/Hospital/home/hospital_wrapper_screen.dart';
import 'package:medibookings/presentation/screens/auth/account_not_verified_screen.dart';
import 'package:medibookings/presentation/screens/nurse/home/home_screen.dart';
import 'package:medibookings/presentation/screens/upload_document/upload_documents_screen.dart';
import 'package:medibookings/presentation/screens/welcome/welcome_screen.dart';
import 'package:medibookings/presentation/widget/button.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/service/auth_service.dart';
import 'package:medibookings/service/hospital/hospital_service.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
      
    final _authService =
        Provider.of<AuthService>(context, listen: true);
        final _hospitalService =
        Provider.of<HospitalService>(context, listen: true);
    return StreamBuilder<User?>(stream: _authService.authStream, builder: (context,snapshot){
      if (snapshot.connectionState == ConnectionState.waiting){
        return commonLoading();
      }
     
      else if(snapshot.hasData ){
         return FutureBuilder<bool>(
            future: _hospitalService.checkHospitalExistsByUID(snapshot.data!.uid.toString()),
            builder: (context, futureSnapshot) {
             
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return commonLoading();
              } else if (futureSnapshot.hasData ) {

                if ( _hospitalService.hospitalModel!.documentLinks.isEmpty){
                  return  UploadDocumentsScreen();
                }else if (_hospitalService.hospitalModel!.isVerified == false ){
                return  const AccountNotVerifiedScreen();
                }
                else{
                  return const HospitalWrapperScreen();
                }
               
              } 
              else {
                return NurseHomePage();
                return  Scaffold(
                  body: Center(child: Column(
                    children: [
                     const Text("Nurse Wrapper"),
                      basicButton(onPressed: (){
                        _authService.logout();
                      }, text: "log out")
                    ],
                  ),),
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
