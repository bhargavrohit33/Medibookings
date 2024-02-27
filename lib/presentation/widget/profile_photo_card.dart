import 'package:flutter/material.dart';

Widget profilePhoto({required String? profilePhoto,double height = 50,double width = 50}){
    return ClipOval(
      child: profilePhoto != null
        ? Image.network(
       profilePhoto,
        width: width,
        height: height,
        fit: BoxFit.fill,
      ):Image.asset("assets/Logo.png",  width: width,
        height: height,
        fit: BoxFit.fill,),
    );
  }