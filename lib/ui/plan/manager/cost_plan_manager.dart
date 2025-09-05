import 'package:app_flutter/model/plan/cost_model.dart';
import 'package:flutter/material.dart';

class CostPlanManager with ChangeNotifier {
  List<CostModel> _items = [];

  List<CostModel> get costs {
    return _items;
  }

  bool addCostPlan(CostModel cost) {
    _items.add(cost);
    notifyListeners();
    return true;
  }

  deleteAt(item) {
    _items.remove(item);
    notifyListeners();
  }
}
