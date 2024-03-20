import 'package:flutter/material.dart';
import 'package:medibookings/common/utils.dart';

class DateSelectionCard extends StatelessWidget {
  final DateTime selectedDate;
  final Function(BuildContext) onSelectDate;

  const DateSelectionCard({
    Key? key,
    required this.selectedDate,
    required this.onSelectDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () => onSelectDate(context),
      child: Card(
        shape: cardShape,
        child: Container(
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(cardRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Row(
              children: [
                Text(
                  customDateFormat(dateTime: selectedDate),
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
