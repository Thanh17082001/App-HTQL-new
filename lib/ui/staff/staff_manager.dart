import 'package:app_flutter/model/staff/staff_model.dart';
import 'package:app_flutter/service/staff/staff_service.dart';
import 'package:flutter/material.dart';

class StaffManager with ChangeNotifier {
  final StaffService _staffService = StaffService();

  List<StaffModel> _items = [];

  List<StaffModel> get staffs {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  Future getAll() async {
    _items = await _staffService.getAll();
    notifyListeners();
  }

  Map<String, dynamic> staff(index) {
    final Map<String, dynamic> _staff = {
      'tenNhanVien': _items[index].tenNhanVien
    };
    return _staff;
  }

  Future<StaffModel?> getNhanVienByID(id) async {
    final resutl = await _staffService.getNhanVienByID(id);
    notifyListeners();
    return resutl;
  }
}
