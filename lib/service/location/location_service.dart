import 'dart:convert';
import 'package:app_flutter/model/location/location_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/auth/auth_model.dart';

class LocationService {
  Future<bool> checkIn(Map<String, dynamic> location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }
      final locationInfo = {
        'userID': location['userID'],
        'viDo': location['viDo'],
        'kinhDo': location['kinhDo'],
        'diaChi': location['diachi'],
        'thoiGian':
            DateFormat('dd/MM/yyyy HH:mm:ss').format(location['ngayCheckIn']),
        'nhanVienID': user.userID
      };
      final urlApi = Uri.parse('${dotenv.env['API_URL']}/Vitri/Add');
      final headers = {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json'
      };
      final response = await http.post(urlApi,
          headers: headers, body: json.encode(locationInfo));
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<LocationModel>> getByStaffId(int nhanVienID) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      late List<LocationModel> locations = [];
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }
      final urlApi =
          Uri.parse('${dotenv.env['API_URL']}/Vitri/GetByNhanVien/$nhanVienID');

      final headers = {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json'
      };
      final response = await http.get(urlApi, headers: headers);
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      final result = json.decode(response.body);
      result.forEach((staff) {
        locations.add(LocationModel.fromJson(staff));
      });
      return locations;
    } catch (e) {
      print(e);
    }
    return [];
  }
}
