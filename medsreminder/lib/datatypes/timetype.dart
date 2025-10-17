class Reminder {
  String? label;
  String? timeType;
  DateTime? time;

  bool? isEnabled = true;
  bool? isTaken = false; // only for ONCE_A_DAY
  DateTime? lastTaken; // saves the last time the user consumed their medicine.

  Reminder({
    required String this.label,
    required String this.timeType,
    required DateTime this.time,
  }) {
    this.lastTaken = DateTime.now();
  }
}
