import 'package:flutter/material.dart';

Widget commonLoading(){
  return const Scaffold(body:  Center(child: CircularProgressIndicator()));
}

Widget commonLoadingBase(){
  return const CircularProgressIndicator();
}