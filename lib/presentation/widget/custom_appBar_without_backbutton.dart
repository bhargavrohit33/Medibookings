import 'package:flutter/material.dart';

class CustomAppBarWithoutBackButton extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final TextStyle textStyle;
  final PreferredSizeWidget? bottom; 
final double appBarSize ;
  CustomAppBarWithoutBackButton({
    required this.title,
    this.actions = const [],
    this.textStyle = const TextStyle(),
    this.bottom,
    this.appBarSize = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      shadowColor: theme.scaffoldBackgroundColor,
      backgroundColor: theme.scaffoldBackgroundColor,
      bottom: bottom, 
      surfaceTintColor: theme.scaffoldBackgroundColor,
      title: Text(title, style: textStyle),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + appBarSize); 
}
