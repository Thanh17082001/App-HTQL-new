import 'package:app_flutter/model/company/company_model.dart';
import 'package:app_flutter/model/department/department_model.dart';
import 'package:app_flutter/model/position/position_model.dart';
import 'package:app_flutter/model/staff/staff_model.dart';
import 'package:app_flutter/service/company/company_service.dart';
import 'package:flutter/material.dart';

class CompanyManager with ChangeNotifier {
  final CompanyService _companyService = CompanyService();

  List<CompanyModel> _items = [];
  List<DepartmentModel> _itemsDepartment = [];
  List<PositionModel> _itemsPositons = [];
  List<StaffModel> _itemsStaffs = [];

  List<CompanyModel> get companies {
    return [..._items];
  }

  List<DepartmentModel> get departments {
    return [..._itemsDepartment];
  }

   List<PositionModel> get positons {
    return [..._itemsPositons];
  }

   List<StaffModel> get staffs {
    return [..._itemsStaffs];
  }


  int get itemCount {
    return _items.length;
  }

  Future getAll() async {
    _items = await _companyService.getAll();
    notifyListeners();
  }

  Future getDepartmentByIdCompany(int idCompany) async {
    _itemsDepartment =
        await _companyService.getDepartmentByIdCompany(idCompany);
    notifyListeners();
  }

   Future getPositionByIdDepartment(int id) async {
    _itemsPositons =
        await _companyService.getPositionByIdDepartment(id);
    notifyListeners();
  }

  Future getStaffByIdPositon(int id) async {
    _itemsStaffs = await _companyService.getStaffByIdPositon(id);
    notifyListeners();
  }
}
