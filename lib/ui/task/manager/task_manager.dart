import 'package:app_flutter/model/task/group_task.dart';
import 'package:app_flutter/model/task/priority_task.dart';
import 'package:app_flutter/model/task/status_task_model.dart';
import 'package:app_flutter/model/task/task_model.dart';
import 'package:app_flutter/service/task/task_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskManager with ChangeNotifier {
  final TaskService _taskService = TaskService();

  List<GroupTask> _groupTasksItems = [];
  List<PriorityTaskModel> _priorityTasksItems = [];
  List<TaskModel> _tasksItems = [];
  List<TaskModel> filterTasks = [];
  List<StatusTaskModel> _statusItems = [];

  List<GroupTask> get groupTasks {
    return _groupTasksItems;
  }

  List<PriorityTaskModel> get priorityTasks {
    return _priorityTasksItems;
  }

  List<TaskModel> get tasks {
    return _tasksItems;
  }

  List<StatusTaskModel> get status {
    return _statusItems;
  }

  Future getAllGroupTask() async {
    _groupTasksItems = await _taskService.getAllGroupTask();
    notifyListeners();
  }

  Future getAllPriorityTask() async {
    _priorityTasksItems = await _taskService.getAllPriorityTask();
    notifyListeners();
  }

  Future<bool> addTask(data) async {
    return await _taskService.addTask(data);
  }

  Future<bool> updateStatus(data) async {
    return await _taskService.updateStatus(data);
  }

  Future getListTask() async {
    _tasksItems = await _taskService.getListTask();
    notifyListeners();
  }

  Future getListStatus() async {
    _statusItems = await _taskService.getListStatus();
    notifyListeners();
  }

  TaskModel getTaskByIdex(index) {
    final item = filterTasks.isEmpty ? _tasksItems[index] : filterTasks[index];
    notifyListeners();
    return item;
  }

  List<TaskModel> filterByName(name) {
    // await getListTask();
    if (filterTasks.isEmpty) {
      filterTasks =
          _tasksItems.where((item) => item.nguoiThucHienTen == name).toList();
    } else {
      filterTasks =
          filterTasks.where((item) => item.nguoiThucHienTen == name).toList();
    }
    notifyListeners();
    return filterTasks;
  }

  List<TaskModel> filterByDate(start, end) {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    DateTime startDate = dateFormat.parse(start);
    DateTime endDate = dateFormat.parse(end);

    if (filterTasks.isEmpty) {
      filterTasks = _tasksItems.where((item) {
        if (startDate == dateFormat.parse(item.ngayBatDau.toString()) &&
            endDate == dateFormat.parse(item.ngayKetThuc.toString())) {
          return true;
        } else {
          return false;
        }
      }).toList();
    } else {
      filterTasks = filterTasks.where((item) {
        if (startDate == dateFormat.parse(item.ngayBatDau.toString()) &&
            endDate == dateFormat.parse(item.ngayKetThuc.toString())) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }

    return filterTasks;
  }

  clearFilter() {
    filterTasks = [];
    notifyListeners();
  }
}
