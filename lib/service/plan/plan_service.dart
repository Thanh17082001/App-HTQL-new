import 'dart:convert';

import 'package:app_flutter/model/auth/auth_model.dart';
import 'package:app_flutter/model/plan/general_plan.dart';
import 'package:app_flutter/model/plan/plan_day_model.dart';
import 'package:app_flutter/model/plan/plan_model.dart';
import 'package:app_flutter/model/plan/role_model.dart';
import 'package:app_flutter/model/staff/staff_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PlanService {
  Future<List<WeekModel>> getPlanWeekByIdUser() async {
    try {
      final List<WeekModel> planWeeks = [];
      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }
      final urlApi = Uri.parse('${dotenv.env['API_URL']}/KHCT_Tuan/GetAll');
      final headers = {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json'
      };
      final response = await http.get(urlApi, headers: headers);

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      } else {
        final result = json.decode(response.body);
        print(result);
        for (var i = 0; i < result.length; i++) {
          final week = WeekModel.fromJson(result[i]);
          if (week.nguoiTaoID == user.userID) {
            planWeeks.add(WeekModel.fromJson(result[i]));
          }
        }
      }
      return planWeeks;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<StaffModel>> getStaffByRoles() async {
    try {
      final List<StaffModel> staffs = [];
      final List<String> roles = RoleModel().roles;
      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }

      for (var i = 0; i < roles.length; i++) {
        final urlApi = Uri.parse(
            '${dotenv.env['API_URL']}/Roles/GetAllUserOfRole?roleName=${roles[i]}');
        final headers = {
          'Authorization': 'Bearer ${user.token}',
          'Content-Type': 'application/json'
        };
        final response = await http.get(urlApi, headers: headers);
        final result = json.decode(response.body);
        result.forEach((staff) {
          staffs.add(StaffModel.fromJson(staff));
        });
      }
      return staffs;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future addPlanDay(PlanDayModel data, companions, wokrs, cars, costPlan,
      costBusiness, costOther) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }

      final urlApi = Uri.parse('${dotenv.env['API_URL']}/KHCT_Ngay/Add');
      final headers = {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json'
      };
      final Map<String, dynamic> planDay = {
        "tuNgay": data.tuNgay,
        "denNgay": data.denNgay,
        "mucDich": data.mucDich,
        "tuanID": data.tuanID,
        "nguoiDuyetID": data.nguoiDuyetID,
        "tenNguoiDuyet": data.tenNguoiDuyet,
        "khctCongTyID": data.khctCongTyID,
        "khctTenCongTy": data.khctTenCongTy
      };

      final response =
          await http.post(urlApi, headers: headers, body: json.encode(planDay));
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      } else {
        final result = json.decode(response.body);
        final ngayID = result['ngayID'];
        await addCompanion(ngayID, companions);
        await addWork(ngayID, wokrs);
        await addCar(ngayID, cars);
        await addCostPlan(ngayID, costPlan);
        await addCostPlan(ngayID, costBusiness);
        await addCostOther(ngayID, costOther);
      }
    } catch (e) {
      print(e);
    }
  }

  Future addCompanion(ngayID, companions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }

      final urlApi = Uri.parse('${dotenv.env['API_URL']}/KHCT_NguoiDiCung/Add');
      final headers = {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json'
      };
      final data = [];

      for (var i = 0; i < companions.length; i++) {
        final covertData = {
          "nhanVienID": companions[i].nhanVienID,
          "tenNhanVien": companions[i].tenNhanVien,
          "tenChuVu": companions[i].tenChuVu,
          "tenPhongBan": companions[i].tenPhongBan,
          "tenCongTy": companions[i].tenCongTy,
          "ngayID": ngayID
        };
        data.add(covertData);
        final response = await http.post(urlApi,
            headers: headers, body: json.encode(covertData));

        if (response.statusCode != 200) {
          throw Exception(json.decode(response.body)['error']);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future addWork(ngayID, works) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }

      final urlApi = Uri.parse('${dotenv.env['API_URL']}/KHCT_NoiDung/Add');
      final headers = {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json'
      };
      for (var i = 0; i < works.length; i++) {
        final covertData = {
          "noiDen": works[i].noiDen,
          "tenBuocThiTruong": works[i].tenBuocThiTruong,
          "chiTiet": works[i].chiTiet,
          "ngayThucHien": works[i].ngayThucHien,
          "ghiChu": works[i].ghiChu,
          "coQuanID": works[i].coQuanID,
          "ngayID": ngayID
        };
        final response = await http.post(urlApi,
            headers: headers, body: json.encode(covertData));
        if (response.statusCode != 200) {
          throw Exception(json.decode(response.body)['error']);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future addCar(ngayID, cars) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }

      final urlApi = Uri.parse('${dotenv.env['API_URL']}/KHCT_Xe/Add');
      final headers = {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json'
      };
      final data = [];

      for (var i = 0; i < cars.length; i++) {
        final covertData = {
          "noiDi": cars[i].noiDi,
          "noiDen": cars[i].noiDen,
          "kmTamTinh": cars[i].kmTamTinh,
          "ngaySuDung": cars[i].ngaySuDung,
          "ghiChu": cars[i].ghiChu,
          "ngayID": ngayID
        };
        print(covertData);
        data.add(covertData);
        final response = await http.post(urlApi,
            headers: headers, body: json.encode(covertData));
        print(response.statusCode);
        if (response.statusCode != 200) {
          throw Exception(json.decode(response.body)['error']);
        }
      }
      print(data);
    } catch (e) {
      print(e);
    }
  }

  Future addCostPlan(ngayID, costs) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }

      final urlApi = Uri.parse('${dotenv.env['API_URL']}/KHCT_ChiPhi/Add');
      final headers = {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json'
      };
      final data = [];

      for (var i = 0; i < costs.length; i++) {
        final covertData = {
          "soLuong": costs[i].soLuong,
          "donGia": costs[i].donGia,
          "thanhTien": costs[i].thanhTien,
          "ghiChu": costs[i].ghiChu,
          "loaiChiPhiID": costs[i].loaiChiPhiID,
          "hangMucChiPhiID": costs[i].hangMucChiPhiID,
          "ngayID": ngayID
        };
        data.add(covertData);
        final response = await http.post(urlApi,
            headers: headers, body: json.encode(covertData));
        print(response.statusCode);
        if (response.statusCode != 200) {
          throw Exception(json.decode(response.body)['error']);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future addCostOther(ngayID, costs) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }

      final urlApi = Uri.parse('${dotenv.env['API_URL']}/KHCT_ChiPhiKhac/Add');
      final headers = {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json'
      };
      final data = [];

      for (var i = 0; i < costs.length; i++) {
        final covertData = {
          "soLuong": costs[i].soLuong,
          "donGia": costs[i].donGia,
          "thanhTien": costs[i].thanhTien,
          "ghiChu": costs[i].ghiChu,
          "hangMuc": costs[i].hangMuc,
          "ngayID": ngayID
        };
        print(covertData);
        data.add(covertData);
        final response = await http.post(urlApi,
            headers: headers, body: json.encode(covertData));
        print(response.statusCode);
        if (response.statusCode != 200) {
          throw Exception(json.decode(response.body)['error']);
        }
      }
      print(data);
    } catch (e) {
      print(e);
    }
  }

  Future<List<DayPlanModel>> getAllPlanDay() async {
    try {
      final List<DayPlanModel> planDays = [];
      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }
      final urlApi = Uri.parse('${dotenv.env['API_URL']}/KHCT_Ngay/GetAll');
      final headers = {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json'
      };
      final response = await http.get(urlApi, headers: headers);

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      } else {
        final result = json.decode(response.body);
        for (var i = 0; i < result.length; i++) {
          planDays.add(DayPlanModel.fromJson(result[i]));
        }
        print(result);
      }

      return planDays;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<DayPlanModel?> getPlanDayById(int id) async {
    try {
      DayPlanModel planDay = DayPlanModel();
      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }
      final urlApi =
          Uri.parse('${dotenv.env['API_URL']}/KHCT_Ngay/GetDetailsById/$id');
      final headers = {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json'
      };
      final response = await http.get(urlApi, headers: headers);
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      } else {
        final result = json.decode(response.body);
        print(result);
        planDay = DayPlanModel.fromJson(result);
      }
      return planDay;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<StaffModel>> getStaffByRolesCheck(roles) async {
    try {
      final List<StaffModel> staffs = [];
      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }

      for (var i = 0; i < roles.length; i++) {
        final urlApi = Uri.parse(
            '${dotenv.env['API_URL']}/Roles/GetAllUserOfRole?roleName=${roles[i]}');
        final headers = {
          'Authorization': 'Bearer ${user.token}',
          'Content-Type': 'application/json'
        };
        final response = await http.get(urlApi, headers: headers);
        final result = json.decode(response.body);
        result.forEach((staff) {
          staffs.add(StaffModel.fromJson(staff));
        });
      }
      return staffs;
    } catch (e) {
      return [];
    }
  }

  Future changeStatusPlan(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }
      final urlApi = Uri.parse('${dotenv.env['API_URL']}/KHCT_Ngay/TrangThai');
      final headers = {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json'
      };
      final response =
          await http.put(urlApi, headers: headers, body: json.encode(data));
      print(response.body);
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }
    } catch (e) {
      print(e);
    }
  }
}
