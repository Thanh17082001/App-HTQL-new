import 'package:app_flutter/model/auth/auth_model.dart';
import 'package:flutter/material.dart';
import '../../service/auth/auth_service.dart';
import '../staff/location_manager.dart';

class AuthManager with ChangeNotifier {
  AuthModel? _authModel;
  final AuthService _authService = AuthService();
  bool get isLogin {
    return _authModel != null;
  }

  AuthModel? get authModel {
    return _authModel;
  }

  void setAuthModel(AuthModel? authModel) {
    _authModel = authModel;
    notifyListeners();
  }

  Future<void> login(username, password) async {
    final response = await _authService.login(username, password);
    setAuthModel(response);
    notifyListeners();
  }

  logout() {
    final locationManager = LocationManager();
    locationManager.setChecked = false;
    _authModel = null;
    notifyListeners();
  }
}
