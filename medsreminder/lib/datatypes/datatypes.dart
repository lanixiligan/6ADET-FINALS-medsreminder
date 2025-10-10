
enum TimeType {
  TIME_SCHEDULE, // rings at a specific hour of the day
  REPEAT_TIME_SCHEDULE, // rings every set amount of day
  ONCE_A_DAY, // no ringing but for letting the user know they consumed their medicine for the day
}

class Reminder {
  TimeType? time_type;
  bool? isEnabled;
  String? label;

  DateTime? time; // for TIME_SCHEDULE
  List<DateTime>? times; // for REPEAT_TIME_SCHEDULE
  bool? isTaken; // only for ONCE_A_DAY

  DateTime? lastTaken; // saves the last time the user consumed their medicine.

  int? remainingQuantity;
}