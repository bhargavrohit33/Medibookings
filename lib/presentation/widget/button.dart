import 'package:flutter/material.dart';
import 'package:medibookings/common/app_colors.dart';
import 'package:medibookings/common/route_name.dart';



Widget basicButton({
  required Function() onPressed,
  double? width,
  double? height=50,
 required String text,
  Color? color,
  double borderRadius = 40,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: const Alignment(-1.00, 0.08),
          end: const Alignment(1, -0.08),
          colors: [color ?? primaryColor, buttonGradient],
        ),
      ),
      child: Center(
        child: Text(
          text ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.02,
          ),
        ),
      ),
    ),
  );
}

Widget backLogin(BuildContext context){
  return Center(
                    child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextButton(
                                  onPressed: () {
                                    // Navigate back to the login screen
                                    Navigator.pushReplacementNamed(context,RouteName.loginRoute);
                                  },
                                  child: Text('Back to Login',style: TextStyle(color: blueColor),),
                                ),
                              ),
                  );
}