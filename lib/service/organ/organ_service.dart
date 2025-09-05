import 'dart:convert';
import 'package:app_flutter/model/auth/auth_model.dart';
import 'package:app_flutter/model/organ/organe_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrganService {
  Future<List<OrganModel>> getAll() async {
    try {
      final List<OrganModel> organs = [];

      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }
      final urlApi = Uri.parse('${dotenv.env['API_URL']}/NSCoQuan/GetCoQuan');

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
          organs.add(OrganModel.fromJson(staff));
        });
      }

      return organs;
    } catch (e) {
      print(e);
    }
    return [];
  }
}
