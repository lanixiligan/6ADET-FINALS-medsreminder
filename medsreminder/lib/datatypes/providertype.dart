import 'package:flutter/cupertino.dart';
import 'dart:math';

import 'package:medsreminder/datatypes/timetype.dart';

// To properly access the list of meds
// Use: Provider.of<MedsListProvider>(context, listen:false).meds
Random random = Random();

class MedsListProvider extends ChangeNotifier {
  List<Map<String, Reminder>> _meds = [];

  List<Map<String, Reminder>> get meds => _meds;

  set setMeds(List<Map<String, Reminder>> newval) {
    _meds = newval;
    notifyListeners();
  }

  void addMeds({
    required String name,
    required String selectedTime,
    required String reminderType,
  }) {
    final newMed = {
      'uuid': random.nextInt(1000000),
      'title': name,
      'time': selectedTime,
      'taken': false,
    };

    _meds.add(newMed);
    notifyListeners();
  }

  void removeMeds({required int index}) {
    if (index >= 0 && index < _meds.length) {
      _meds.removeAt(index);
      notifyListeners();
    }
  }
}
