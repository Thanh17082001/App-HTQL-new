import 'dart:convert';

import 'package:app_flutter/model/auth/auth_model.dart';
import 'package:app_flutter/model/task/group_task.dart';
import 'package:app_flutter/model/task/priority_task.dart';
import 'package:app_flutter/model/task/status_task_model.dart';
import 'package:app_flutter/model/task/task_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class TaskService {
  Future<List<GroupTask>> getAllGroupTask() async {
    try {
      final List<GroupTask> groupTasks = [];

      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }
      final urlApi = Uri.parse('${dotenv.env['API_URL']}/NhomCongViec/GetAll');

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
          groupTasks.add(GroupTask.fromJson(staff));
        });
      }
      return groupTasks;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List<PriorityTaskModel>> getAllPriorityTask() async {
    try {
      final List<PriorityTaskModel> priorityTasks = [];

      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }
      final urlApi = Uri.parse('${dotenv.env['API_URL']}/CongViec/GetDoUuTien');

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
          priorityTasks.add(PriorityTaskModel.fromJson(staff));
        });
      }
      return priorityTasks;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<bool> addTask(data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }
      final urlApi = Uri.parse('${dotenv.env['API_URL']}/CongViec/Add');

      final headers = {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json'
      };
      print(json.encode(data));
      final response =
          await http.post(urlApi, headers: headers, body: json.encode(data));
      print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }
      return true;
    } catch (e) {
      print({'thêm thất bại': e});
      return false;
    }
  }

  Future<List<TaskModel>> getListTask() async {
    try {
      final List<TaskModel> tasks = [];

      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }
      final urlApi =
          Uri.parse('${dotenv.env['API_URL']}/CongViec/GetDSNhanViec');

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
          tasks.add(TaskModel.fromJson(staff));
        });
      }
      return tasks;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List<StatusTaskModel>> getListStatus() async {
    try {
      final List<StatusTaskModel> statuss = [];

      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }
      final urlApi =
          Uri.parse('${dotenv.env['API_URL']}/CongViec/GetTrangThai');

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
          statuss.add(StatusTaskModel.fromJson(staff));
        });
      }
      return statuss;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<bool> updateStatus(data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      late AuthModel user;
      var initUser = prefs.getString('user');
      if (initUser != null) {
        user = AuthModel.fromJson(jsonDecode(initUser));
      }
      final urlApi =
          Uri.parse('${dotenv.env['API_URL']}/CongViec/UpdateProgress');

      final headers = {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json'
      };
      if (int.parse(data['tienDo']) == 100) {
        data['trangThaiID'] = 2;
      }
      final response =
          await http.put(urlApi, headers: headers, body: json.encode(data));
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
