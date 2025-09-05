import 'dart:convert';

import 'package:app_flutter/model/auth/auth_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<AuthModel?> login(username, password) async {
    try {
      final user = {'tenDangNhap': username, 'matKhau': password};
      final urlApi = Uri.parse('${dotenv.env['API_URL']}/nguoidung/DangNhap');
      final headers = {'Content-Type': 'application/json'};
      final response =
          await http.post(urlApi, headers: headers, body: json.encode(user));
      if (response.statusCode != 200) {
        throw Exception('Thất bại');
      } else {
        final result = json.decode(response.body);
        _saveAuthToken(AuthModel.fromJson(result));
        return AuthModel.fromJson(result);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> _saveAuthToken(AuthModel authModel) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', json.encode(authModel.toJson()));
  }
}
