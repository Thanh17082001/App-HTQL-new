import 'dart:async';
import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:app_flutter/model/auth/auth_model.dart';
import 'package:app_flutter/model/staff/staff_model.dart';
import 'package:app_flutter/model/task/history_model.dart';
import 'package:app_flutter/model/task/task_model.dart';
import 'package:app_flutter/shared/loading_form.dart';
import 'package:app_flutter/ui/staff/staff_manager.dart';
import 'package:app_flutter/ui/task/manager/task_manager.dart';
import 'package:app_flutter/ui/task/task_detail.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListTask extends StatefulWidget {
  const ListTask({super.key});

  @override
  State<ListTask> createState() => _ListTaskState();
}

class _ListTaskState extends State<ListTask> {
  late List<TaskModel> tasks;
  List<TaskModel> filterTasks = [];
  List<StaffModel> staffs = [];
  late List<HistoryTaskModel> historys;
  List<DateTime>? dateTimeList;
  List<DateTime> _dates = [];
  bool isDate = false;
  var _select = null;
  late AuthModel user;

  Map<String, dynamic> data = {
    'nguoiThucHienID': 2,
    'nguoiThucHienTen': '',
  };
  Future getListTask({required BuildContext context}) async {
    await context.read<TaskManager>().getListTask();
    // ignore: use_build_context_synchronously
    await getAllStaff(context: context);
    // ignore: use_build_context_synchronously
    tasks = context.read<TaskManager>().tasks;
  }

  Future getUser() async {
    final prefs = await SharedPreferences.getInstance();
    var initUser = prefs.getString('user');
    if (initUser != null) {
      user = AuthModel.fromJson(jsonDecode(initUser));
    }
  }

  Future getAllStaff({required BuildContext context}) async {
    await context.read<StaffManager>().getAll();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: FutureBuilder(
          future: getListTask(context: context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingFrom();
            }
            return Column(
              children: [
                _selectStaff(),
                const SizedBox(
                  height: 10,
                ),
                _dateTiemPicker(context),
                // date(),
                Container(
                    margin: const EdgeInsets.only(bottom: 20, top: 10),
                    height: 25,
                    child: Text(
                      'Danh sách công việc được giao'.toUpperCase(),
                      style: const TextStyle(fontSize: 20, color: Colors.blue),
                    )),
                Expanded(
                  child: Consumer<TaskManager>(
                      builder: (context, taskManeger, idx) {
                        if(filterTasks.isEmpty){
                          filterTasks = context.read<TaskManager>().tasks;
                        }
                    return ListView.builder(
                        itemCount: filterTasks.length,
                        itemBuilder: (ctx, index) {
                          historys = filterTasks[index].lichSuCongViec!;
                          final int? progress = historys.isNotEmpty
                              ? historys[historys.length - 1].tienDo
                              : 0;
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                    top: index == 0
                                        ? const BorderSide(
                                            width: 1.25, color: Colors.black12)
                                        : BorderSide.none,
                                    bottom: const BorderSide(
                                        width: 1.25, color: Colors.black12))),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                              '${(index + 1).toString()} .')),
                                      Expanded(
                                          flex: 6,
                                          child: Text(
                                            filterTasks[index]
                                                .tenCongViec
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          )),
                                      Expanded(
                                          flex: 4,
                                          child: Text(
                                              'Tiến độ: ${progress ?? '0'}%')),
                                      Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    TaskDetail.routerName,
                                                    arguments: index);
                                              },
                                              child: const Icon(
                                                Icons.remove_red_eye,
                                                color: Color.fromARGB(
                                                    255, 117, 191, 252),
                                              )))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Từ: ${filterTasks[index].ngayBatDau}',
                                        style: const TextStyle(
                                            color: Colors.black45),
                                      ),
                                      Text(
                                        'Đến: ${filterTasks[index].ngayKetThuc}',
                                        style: const TextStyle(
                                            color: Colors.black45),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }),
                )
              ],
            );
          }),
    );
  }

  Widget _selectStaff() {
    return Consumer<StaffManager>(builder: (ctx, staffManager, idx) {
      List<String> staffsName = [];
      staffs = [];
      staffs = staffManager.staffs;
      for (var elm in staffs) {
        staffsName.add(elm.tenNhanVien.toString());
      }

      staffsName.add(user.hoVaTen.toString());

      return Stack(
        children: [
          CustomDropdown<String>.search(
              decoration: CustomDropdownDecoration(
                  headerStyle: const TextStyle(color: Colors.blue),
                  expandedBorderRadius: BorderRadius.circular(1),
                  closedBorderRadius: BorderRadius.circular(4),
                  closedBorder: Border.all(
                      color: Colors.black38,
                      width: 1,
                      style: BorderStyle.solid)),
              closeDropDownOnClearFilterSearch: true,
              canCloseOutsideBounds: true,
              hintText: 'Nhân viên phụ trách',
              items: staffsName,
              excludeSelected: false,
              onChanged: (value) {
                context.read<TaskManager>().filterByName(value);
                filterTasks = context.read<TaskManager>().filterByName(value);

                setState(() {
                  _select = value;
                });
              },
              initialItem: _select),
          if (_select != null)
            Positioned(
              right: 30,
              top: 2,
              child: TextButton(
                onPressed: () {
                  context.read<TaskManager>().clearFilter();
                  filterTasks = tasks;
                  setState(() {
                    _select = null;
                  });
                },
                child: const Icon(Icons.close),
              ),
            )
        ],
      );
    });
  }

  Widget _dateTiemPicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        dateTimeList = await showOmniDateTimeRangePicker(
          isForceEndDateAfterStartDate: true,
          theme: ThemeData(
            cardColor: Colors.red,
          ),
          context: context,
          startInitialDate: DateTime.now(),
          startFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
          startLastDate: DateTime.now().add(
            const Duration(days: 3652),
          ),
          endInitialDate: DateTime.now(),
          endFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
          endLastDate: DateTime.now().add(
            const Duration(days: 3652),
          ),
          is24HourMode: true,
          isShowSeconds: false,
          minutesInterval: 1,
          secondsInterval: 1,
          isForce2Digits: false,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          constraints: const BoxConstraints(
            maxWidth: 350,
            maxHeight: 650,
          ),
          transitionBuilder: (context, anim1, anim2, child) {
            return FadeTransition(
              opacity: anim1.drive(
                Tween(
                  begin: 0,
                  end: 1,
                ),
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 200),
          barrierDismissible: true,
          selectableDayPredicate: (dateTime) {
            // Disable 25th Feb 2023
            if (dateTime == DateTime(2023, 2, 25)) {
              return false;
            } else {
              return true;
            }
          },
        );

        if (dateTimeList?[0] != null && dateTimeList?[1] != null) {
          // ignore: use_build_context_synchronously
          filterTasks = context.read<TaskManager>().filterByDate(
              formatDate(dateTimeList![0]), formatDate(dateTimeList![1]));
          isDate = false;
        } else {
          filterTasks = tasks;
          // ignore: use_build_context_synchronously
          context.read<TaskManager>().clearFilter();
        }
        setState(() {
          if (dateTimeList?[0] != null && dateTimeList?[1] != null) {
            isDate = false;
          }
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
            border: Border.all(
                width: 1.25, color: !isDate ? Colors.black38 : Colors.red),
            color: const Color.fromARGB(26, 192, 192, 192),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateTimeList?[1] != null && dateTimeList?[0] != null
                  ? '${formatDate(dateTimeList![0])} - ${formatDate(dateTimeList![1])}'
                  : 'Từ ngày - đến ngày',
              style: const TextStyle(fontSize: 18, color: Colors.black38),
            ),
            const Icon(Icons.date_range)
          ],
        ),
      ),
    );
  }

  Widget date() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: CalendarDatePicker2(
          config: CalendarDatePicker2Config(
            calendarType: CalendarDatePicker2Type.range,
          ),
          value: _dates,
          onValueChanged: (dates) {
            print(dates);
            _dates = dates;
          },
        ));
  }

  String formatDateTime(DateTime date) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    String formattedDate =
        dateFormat.format(date.toUtc().add(const Duration(hours: 7)));
    return formattedDate;
  }

  String formatDate(DateTime date) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    String formattedDate =
        dateFormat.format(date.toUtc().add(const Duration(hours: 7)));
    return formattedDate;
  }
}
