import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalender extends StatelessWidget {
  const CustomCalender({
    super.key,
    required this.calendarFormat,
    required this.focusedDay,
    this.selectedDay,
    this.onDaySelected,
    this.onFormatChanged,
    this.selectedDayPredicate,
    this.onPageChanged,
    this.firstDay,
    this.lastDay,
  });

  final CalendarFormat calendarFormat;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime, DateTime)? onDaySelected;
  final Function(CalendarFormat)? onFormatChanged;
  final bool Function(DateTime)? selectedDayPredicate;
  final Function(DateTime)? onPageChanged;
  final DateTime? firstDay;
  final DateTime? lastDay;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: firstDay ??DateTime.now(),
      lastDay: lastDay ?? DateTime.utc(2030, 3, 14),
      focusedDay: focusedDay,
      calendarFormat: calendarFormat,
      selectedDayPredicate: selectedDayPredicate,
      onDaySelected: onDaySelected,
      onFormatChanged: onFormatChanged,
      onPageChanged: onPageChanged,
    );
  }
}
