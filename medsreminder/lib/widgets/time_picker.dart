import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<TimeOfDay?> showCupertinoTimePicker({
  required BuildContext ctx,
  TimeOfDay? initialTime,
}) async {
  DateTime now = DateTime.now();
  DateTime initialDateTime = DateTime(
    now.year,
    now.month,
    now.day,
    initialTime?.hour ?? now.hour,
    initialTime?.minute ?? now.minute,
  );

  DateTime chosen = initialDateTime;

  final result = await showCupertinoModalPopup<DateTime>(
    context: ctx,
    builder: (_) {
      return Container(
        height: 260,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(ctx),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // top action bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Text('Done', style: TextStyle(color: Colors.cyan)),
                      onPressed: () => Navigator.of(ctx).pop(chosen),
                    ),
                  ],
                ),
              ),
              // the picker
              SizedBox(
                height: 180,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: initialDateTime,
                  use24hFormat: false,
                  onDateTimeChanged: (DateTime newDate) {
                    chosen = newDate;
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  if (result == null) return null;
  return TimeOfDay(hour: result.hour, minute: result.minute);
}
