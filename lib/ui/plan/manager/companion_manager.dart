import 'package:app_flutter/model/plan/companion_model.dart';
import 'package:flutter/material.dart';

class CompanionManager with ChangeNotifier {
  List<CompanionModel> coms = [];

  List<CompanionModel> get companions {
    return coms;
  }

  bool addCompanion(CompanionModel companion) {
    coms.add(companion);
    notifyListeners();
    return true;
  }

  deleteByIndex(com) {
    coms.remove(com);
    notifyListeners();
  }
}
