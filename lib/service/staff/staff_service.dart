import 'dart:convert';

import 'package:app_flutter/model/auth/auth_model.dart';
import 'package:app_flutter/model/staff/staff_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StaffService {
  Future<List<StaffModel>> getAll() async {
    try {
      final List<StaffModel> products = [];

      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }
      final urlApi = Uri.parse(
          '${dotenv.env['API_URL']}/QuanLyNhanVien/GetNhanVien?quanLyID=${user.userID}');

          // final urlApi = Uri.parse('${dotenv.env['API_URL']}/NhanVien/GetNhanVien');
      final headers = {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json'
      };
      final response = await http.get(urlApi, headers: headers);
      final result = json.decode(response.body);
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      } else {
        result.forEach((staff) {
          products.add(StaffModel.fromJson(staff));
        });
      }
      return products;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<StaffModel?> getNhanVienByID(int nhanVienID) async {
    try {
      final StaffModel staff;

      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }
      final urlApi = Uri.parse(
          '${dotenv.env['API_URL']}/NhanVien/GetNhanVienById/$nhanVienID');
      final headers = {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json'
      };
      final response = await http.get(urlApi, headers: headers);
      final result = json.decode(response.body);
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      } else {
        staff = (StaffModel.fromJson(result));
      }
      return staff;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
