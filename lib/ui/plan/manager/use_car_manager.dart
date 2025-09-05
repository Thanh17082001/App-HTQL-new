import 'package:app_flutter/model/plan/use_car_model.dart';
import 'package:flutter/material.dart';

class UseCarManager with ChangeNotifier {
  final List<UseCarModel> _items = [];

  List<UseCarModel> get cars {
    return _items;
  }

  bool addUseCar(UseCarModel car) {
    print(car);
    _items.add(car);
    notifyListeners();
    return true;
  }

  deleteAt(car) {
    _items.remove(car);
    notifyListeners();
  }
}
