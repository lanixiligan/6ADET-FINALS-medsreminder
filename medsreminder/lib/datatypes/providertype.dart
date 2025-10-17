import 'package:flutter/cupertino.dart';
import 'dart:math';

// To properly access the list of meds
// Use: Provider.of<MedsListProvider>(context, listen:false).meds
Random random = Random();

class MedsListProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _meds = [];

  List<Map<String, dynamic>> get meds => _meds;

  set setMeds(List<Map<String, dynamic>> newval) {
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
