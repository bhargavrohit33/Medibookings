import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medibookings/common/app_colors.dart';



// dummy data

String hospitalDemoImage =
        "https://lh3.googleusercontent.com/p/AF1QipNOxpY1rI-Z2vIS_UduYodhD3sOL1oWHECRuRlg=s1360-w1360-h1020";

String nurseDemoImageURL =
        "https://images.pexels.com/photos/6749773/pexels-photo-6749773.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2";

// app theme 
final themeData = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: themeColor,
    // Ensure secondary color is defined appropriately
    // secondarySwatch: secondaryColor,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: primaryColor,
    unselectedItemColor: Colors.grey,
    // Ensure elevation and shadow properties align with MD3
    elevation: 8,
    selectedIconTheme: IconThemeData(size: 24),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.white,
    // Ensure elevation and shadow properties align with MD3
    elevation: 24,
  ),
  textTheme: Typography.material2018().black.apply(
    fontFamily: 'Poppins', // Use appropriate font family
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
  ),
  tabBarTheme: TabBarTheme(
    labelColor: primaryColor,
    unselectedLabelColor: Colors.grey,
    // Ensure indicator size aligns with MD3
    indicatorSize: TabBarIndicatorSize.label,
    // Ensure indicator weight aligns with MD3
    
  ),
  iconTheme: IconThemeData(color: primaryColor),
  cardTheme: CardTheme(
    color: Colors.white,
    // Ensure elevation and shadow properties align with MD3
    elevation: 4,
    shadowColor: Colors.black.withOpacity(0.1),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateColor.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.white; // Thumb color when switch is on
      } else {
        return Colors.grey; // Thumb color when switch is off
      }
    }),
    trackColor: MaterialStateColor.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return primaryColor; // Track color when switch is on
      } else {
        return Colors.white; // Track color when switch is off
      }
    }),
    // Ensure elevation and shadow properties align with MD3
  
    overlayColor: MaterialStateColor.resolveWith((states) {
      if (states.contains(MaterialState.hovered)) {
        return Colors.red.withOpacity(0.1); // Overlay color when switch is hovered
      } else {
        return Colors.transparent; // No overlay color
      }
    }),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: Colors.white,
    // Ensure content padding aligns with MD3
    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    // Ensure shape aligns with MD3
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(color: primaryColor),
  scaffoldBackgroundColor: Colors.white,
  // Ensure visual density aligns with MD3
  visualDensity: VisualDensity.standard,
);



// variables
double cardRadius = 20.0;

final cardShape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cardRadius),
              );
// decoration
 
 InputDecoration defaultInputDecoration({String? hintText}) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: textFormFieldText)
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: textFormFieldText)
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: textFormFieldText)
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: textFormFieldText)
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    fillColor: textFormFieldText,
    hintText: hintText,
    filled: true
    
    
  );
}

