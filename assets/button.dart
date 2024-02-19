import 'package:flutter/material.dart';

var primaryColor = const Color(0xFF92A3FD);
var buttonGradient = const Color(0xFF9DCEFF);
Widget basicButton({
  required Function() onPressed,
  double? width,
  double? height,
  String? text,
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
