class TimeSlot {
  final String startTime;
  final String endTime;
  late bool isAvailable;

  TimeSlot(this.startTime, this.endTime, {this.isAvailable = true});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeSlot &&
        other.startTime == startTime &&
        other.endTime == endTime;
  }

  @override
  int get hashCode => Object.hash(startTime, endTime);

  @override
  String toString() {
    return 'TimeSlot(start: $startTime, end: $endTime, available: $isAvailable)';
  }
}

final List<TimeSlot> morningSlots = [
  TimeSlot('06:30', '06:45'),
  TimeSlot('06:45', '07:00'),
  TimeSlot('07:00', '07:15'),
  TimeSlot('07:15', '07:30'),
  TimeSlot('07:30', '07:45'),
  TimeSlot('07:45', '08:00'),
  TimeSlot('08:00', '08:15'),
  TimeSlot('08:15', '08:30'),
  TimeSlot('08:30', '08:45'),
  TimeSlot('08:45', '09:00'),
  TimeSlot('09:00', '09:15'),
  TimeSlot('09:15', '09:30'),
  TimeSlot('09:30', '09:45'),
  TimeSlot('09:45', '10:00'),
  TimeSlot('10:00', '10:15'),
  TimeSlot('10:15', '10:30'),
  TimeSlot('10:30', '10:40'),
];

final List<TimeSlot> afternoonSlots = [
  TimeSlot('12:45', '13:00'),
  TimeSlot('13:00', '13:15'),
  TimeSlot('13:15', '13:30'),
  TimeSlot('13:30', '13:45'),
  TimeSlot('13:45', '14:00'),
  TimeSlot('14:00', '14:15'),
  TimeSlot('14:15', '14:30'),
  TimeSlot('14:30', '14:45'),
  TimeSlot('14:45', '15:00'),
  TimeSlot('15:00', '15:15'),
  TimeSlot('15:15', '15:30'),
  TimeSlot('15:30', '15:45'),
  TimeSlot('15:45', '16:00'),
  TimeSlot('16:00', '16:15'),
  TimeSlot('16:15', '16:30'),
  TimeSlot('16:30', '16:40'),
];
