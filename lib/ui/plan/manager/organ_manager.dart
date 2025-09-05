import 'package:app_flutter/model/organ/organe_model.dart';
import 'package:app_flutter/service/organ/organ_service.dart';
import 'package:flutter/material.dart';

class OrganManager with ChangeNotifier {
  final OrganService _organService = OrganService();

  List<OrganModel> _items = [];

  List<OrganModel> get organs {
    return [..._items];
  }

  

  int get itemCount {
    return _items.length;
  }

  Future getAll() async {
    _items = await _organService.getAll();
    notifyListeners();
  }

  
}
