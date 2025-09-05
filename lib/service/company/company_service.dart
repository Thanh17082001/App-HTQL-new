import 'dart:convert';

import 'package:app_flutter/model/auth/auth_model.dart';
import 'package:app_flutter/model/company/company_model.dart';
import 'package:app_flutter/model/department/department_model.dart';
import 'package:app_flutter/model/position/position_model.dart';
import 'package:app_flutter/model/staff/staff_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CompanyService {
  Future<List<CompanyModel>> getAll() async {
    try {
      final List<CompanyModel> companies = [];

      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }
      final urlApi = Uri.parse('${dotenv.env['API_URL']}/CongTy/GetAll');

      final headers = {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json'
      };
      final response = await http.get(urlApi, headers: headers);
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      } else {
        final result = json.decode(response.body);
        result.forEach((staff) {
          companies.add(CompanyModel.fromJson(staff));
        });
      }

      return companies;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List<DepartmentModel>> getDepartmentByIdCompany(int idCompany) async {
    try {
      final List<DepartmentModel> departments = [];

      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }
      final urlApi =
          Uri.parse('${dotenv.env['API_URL']}/PhongBan/GetByCty/${idCompany}');

      final headers = {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json'
      };
      final response = await http.get(urlApi, headers: headers);
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      } else {
        final result = json.decode(response.body);
        result.forEach((staff) {
          departments.add(DepartmentModel.fromJson(staff));
        });
      }

      return departments;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List<PositionModel>> getPositionByIdDepartment(
      int idDepartment) async {
    try {
      final List<PositionModel> positions = [];

      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }
      final urlApi = Uri.parse(
          '${dotenv.env['API_URL']}/ChucVu/GetByPhongBan/$idDepartment');

      final headers = {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json'
      };
      final response = await http.get(urlApi, headers: headers);
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      } else {
        final result = json.decode(response.body);
        result.forEach((staff) {
          positions.add(PositionModel.fromJson(staff));
        });
      }

      return positions;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List<StaffModel>> getStaffByIdPositon(int id) async {
    try {
      final List<StaffModel> staffs = [];

      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }
      final urlApi =
          Uri.parse('${dotenv.env['API_URL']}/NhanVien/GetByChucVu/$id');

      final headers = {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json'
      };
      final response = await http.get(urlApi, headers: headers);
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      } else {
        final result = json.decode(response.body);
        result.forEach((staff) {
          staffs.add(StaffModel.fromJson(staff));
        });
      }

      return staffs;
    } catch (e) {
      print(e);
    }
    return [];
  }
}
