import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medibookings/presentation/widget/button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  TextStyle textStyle;
  

  CustomAppBar({required this.title, this.actions = const [], this.textStyle= const TextStyle()});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
       shadowColor: theme.scaffoldBackgroundColor,
      backgroundColor: theme.scaffoldBackgroundColor,
      
     surfaceTintColor: theme.scaffoldBackgroundColor,
      leading: InkWell(
        onTap: (() {
          Navigator.pop(context);
        }),
        child: Icon(Icons.arrow_back_ios,size: 20,color: primaryColor)),
      title: Text(title,style: textStyle,),
      actions: actions,
      centerTitle: true,
      // Customize other properties of the AppBar as needed
    );
  }


  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 20); 
}

