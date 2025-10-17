import 'package:flutter/cupertino.dart';

// To properly access the list of meds
// Use: Provider.of<MedsListProvider>(context, listen:false).meds
class MedsListProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _meds = [];

  List<Map<String, dynamic>> get meds => _meds;

  set setMeds(List<Map<String, dynamic>> newval) {
    _meds = newval;
    notifyListeners();
  }

  void addMeds(nameControllerText, selectedTime) {
    final newMed = {
      'title': nameControllerText,
      'time': selectedTime,
      'taken': false,
    };

    _meds.add(newMed);
    notifyListeners();
  }
}
