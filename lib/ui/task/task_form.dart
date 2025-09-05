import 'dart:convert';
import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:app_flutter/model/company/company_model.dart';
import 'package:app_flutter/model/department/department_model.dart';
import 'package:app_flutter/model/position/position_model.dart';
import 'package:app_flutter/model/staff/staff_model.dart';
import 'package:app_flutter/model/task/group_task.dart';
import 'package:app_flutter/model/task/priority_task.dart';
import 'package:app_flutter/shared/dialog.dart';
import 'package:app_flutter/shared/loading_form.dart';
import 'package:app_flutter/ui/plan/manager/company_manager.dart';
import 'package:app_flutter/ui/task/manager/task_manager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  List<DateTime>? dateTimeList;
  bool isDate = false;
  List<CompanyModel> companies = [];
  List<GroupTask> groupTasks = [];
  List<PriorityTaskModel> priorityTasks = [];
  List<DepartmentModel> departments = [];
  List<PositionModel> positons = [];
  List<StaffModel> staffs = [];
  bool isLoading = false;

  Map<String, dynamic> data = {
    "congViecDto": {
      "tenCongViec": "",
      "moTa": "",
      "ngayBatDau": "",
      "ngayKetThuc": "",
      "nhomCongViecID": 0,
      "uuTienID": 0,
      "congTyID": 0,
      "phongBanID": 0,
      "chuVuID": 0,
      "nguoiThucHienID": 0,
      "nguoiThucHienTen": ""
    },
    "fileCongViecDto": []
  };
  File? _selectedFile;
  String? _fileName;
  String? _fileType;
  String? _base64File;

  Future<void> _pickFile() async {
    // Yêu cầu quyền truy cập vào bộ nhớ
    if (await _requestPermission()) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null && result.files.single.path != null) {
          _selectedFile = File(result.files.single.path!);

        await _convertFileToBase64();
        setState(() {
          _fileName = result.files.single.name;
          _fileType = lookupMimeType(result.files.single.path!);
          final test = {
            "fileID":0,
            "fileName": _fileName,
            "fileType": _fileType,
            "fileUrl": "data:$_fileType;base64,${_base64File!}",
          };
          data['fileCongViecDto'].add(test);
        });
      }
    } else {
      // Quyền truy cập bị từ chối
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quyền truy cập bị từ chối')),
      );
    }
  }

  Future<void> _convertFileToBase64() async {
    if (_selectedFile != null) {
      final bytes = await _selectedFile!.readAsBytes();
      setState(() {
        _base64File = base64Encode(bytes);
      });
    }
  }

  Future<bool> _requestPermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future getAllCompanies(BuildContext context) async {
    await context.read<CompanyManager>().getAll();
  }

  Future getDepartmentByIdCompany(BuildContext context, id) async {
    await context.read<CompanyManager>().getDepartmentByIdCompany(id);
  }

  Future getPositionByIdDepartment(
      {required BuildContext context, required id}) async {
    await context.read<CompanyManager>().getPositionByIdDepartment(id);
  }

  Future getStaffByIdPositon(
      {required BuildContext context, required id}) async {
    await context.read<CompanyManager>().getStaffByIdPositon(id);
  }

  Future getAllGroupTask({required BuildContext context}) async {
    await context.read<TaskManager>().getAllGroupTask();
  }

  Future getAllPriorityTask({required BuildContext context}) async {
    await context.read<TaskManager>().getAllPriorityTask();
  }

  @override
  void initState() {
    super.initState();
    getAllCompanies(context);
    getAllGroupTask(context: context);
    getAllPriorityTask(context: context);
  }

  submit() async {
    try {
      if (!_formKey.currentState!.validate()) {
        setState(() {
          isDate = true;
        });
        return;
      }
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      final result = await context.read<TaskManager>().addTask(data);
      if (result) {
        DialogForm.successDialog(context);
      } else {
        DialogForm.failureDialog(context);
      }

      setState(() {
        _selectedFile = null;
        _fileName = null;
        _fileType = null;
        _base64File = null;
      });
      data = {
        "congViecDto": {
          "tenCongViec": "",
          "moTa": "",
          "ngayBatDau": "",
          "ngayKetThuc": "",
          "nhomCongViecID": 0,
          "uuTienID": 0,
          "congTyID": 0,
          "phongBanID": 0,
          "chuVuID": 0,
          "nguoiThucHienID": 0,
          "nguoiThucHienTen": ""
        },
        "fileCongViecDto": []
      };
      // _formKey.currentState!.reset();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      DialogForm.failureDialog(context);
      print({'lỗi': e});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
            height: 50,
            child: Center(
                child: Text(
              'Giao việc mới',
              style: TextStyle(fontSize: 26),
            ))),
        Expanded(
          child: isLoading
              ? loadingFrom()
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 25,
                              child: Text('Tên công việc'),
                            ),
                            _nameTaskField(),
                            Container(
                              height: 25,
                              margin: const EdgeInsets.only(top: 20),
                              child: const Text('Mô tả'),
                            ),
                            _desciptionField(),
                            Container(
                              height: 25,
                              margin: const EdgeInsets.only(top: 20),
                              child: const Text('Ngày bắt đầu - ngày kết thúc'),
                            ),
                            _dateTiemPicker(),
                            if (isDate)
                              const SizedBox(
                                height: 20,
                                child: Text(
                                  'Chọn thời gian',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            Container(
                              height: 25,
                              margin: const EdgeInsets.only(top: 20),
                              child: const Text('Mức độ ưu tiên'),
                            ),
                            _selectPriority(),
                            Container(
                              height: 25,
                              margin: const EdgeInsets.only(top: 20),
                              child: const Text('Loai công việc'),
                            ),
                            _selectTypeTask(),
                            Container(
                              height: 25,
                              margin: const EdgeInsets.only(top: 20),
                              child: const Text('Công ty'),
                            ),
                            _selectPlanCompany(),
                            Container(
                              height: 25,
                              margin: const EdgeInsets.only(top: 20),
                              child: const Text('Phòng ban'),
                            ),
                            _selectDepartment(),
                            Container(
                              height: 25,
                              margin: const EdgeInsets.only(top: 20),
                              child: const Text('Chức vụ'),
                            ),
                            _selectPosition(),
                            Container(
                              height: 25,
                              margin: const EdgeInsets.only(top: 20),
                              child: const Text('Người được giao việc'),
                            ),
                            _selectStaff(),
                            Container(
                              height: 25,
                              margin: const EdgeInsets.only(top: 0),
                            ),
                            _selectFile(),
                            Container(
                              height: 25,
                              margin: const EdgeInsets.only(top: 0),
                            ),
                            _buttonSubmit()
                          ],
                        )),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _nameTaskField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
          hintText: 'Tên công việc',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.black38, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(12)),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1.25),
            borderRadius: BorderRadius.circular(12),
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Nhập Tên công việc';
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        data["congViecDto"]["tenCongViec"] = newValue!;
      },
    );
  }

  Widget _desciptionField() {
    return TextFormField(
      decoration: InputDecoration(
          hintText: 'Mô tả',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.black38, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(12)),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1.25),
            borderRadius: BorderRadius.circular(12),
          )),
      minLines: 6,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Nhập mô tả công việc';
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        data["congViecDto"]["moTa"] = newValue!;
      },
    );
  }

  Widget _dateTiemPicker() {
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
          isForce2Digits: true,
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
        data["congViecDto"]["ngayBatDau"] = formatDateTime(dateTimeList![0]);
        data["congViecDto"]["ngayKetThuc"] = formatDateTime(dateTimeList![1]);
        setState(() {
          if (dateTimeList?[0] != null && dateTimeList?[1] != null) {
            setState(() {
              isDate = false;
            });
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
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateTimeList?[1] != null && dateTimeList?[0] != null
                  ? '${formatDate(dateTimeList![0])} - ${formatDate(dateTimeList![1])}'
                  : 'Từ ngày - đến ngày',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const Icon(Icons.date_range)
          ],
        ),
      ),
    );
  }

  Widget _selectPriority() {
    return Consumer<TaskManager>(builder: (ctx, taskManager, index) {
      List<String> priorityTaskNames = [];
      priorityTasks = taskManager.priorityTasks;
      for (var item in priorityTasks) {
        priorityTaskNames.add(item.tenUuTien.toString());
      }
      return CustomDropdown<String>.search(
        validator: (value) {
          if (value == null) {
            return 'Chọn độ ưu tiên';
          } else {
            return null;
          }
        },
        decoration: CustomDropdownDecoration(
            headerStyle: const TextStyle(color: Colors.blue),
            expandedBorderRadius: BorderRadius.circular(1),
            closedBorderRadius: BorderRadius.circular(4),
            closedBorder: Border.all(
                color: Colors.black38, width: 1, style: BorderStyle.solid)),
        hintText: 'Chọn độ ưu tiên',
        items: priorityTaskNames,
        excludeSelected: false,
        onChanged: (value) async {
          final selectedPriorityTask = priorityTasks.firstWhere(
            (element) => element.tenUuTien == value,
          );

          setState(() {
            data["congViecDto"]["uuTienID"] = selectedPriorityTask.uuTienId;
          });
        },
      );
    });
  }

  Widget _selectTypeTask() {
    return Consumer<TaskManager>(builder: (ctx, taskManager, index) {
      List<String> groupTaskNames = [];
      groupTasks = taskManager.groupTasks;
      for (var item in groupTasks) {
        groupTaskNames.add(item.tenNhomCongViec.toString());
      }
      return CustomDropdown<String>.search(
        validator: (value) {
          if (value == null) {
            return 'Chọn loại công việc';
          } else {
            return null;
          }
        },
        decoration: CustomDropdownDecoration(
            headerStyle: const TextStyle(color: Colors.blue),
            expandedBorderRadius: BorderRadius.circular(1),
            closedBorderRadius: BorderRadius.circular(4),
            closedBorder: Border.all(
                color: Colors.black38, width: 1, style: BorderStyle.solid)),
        hintText: 'Chọn loại công việc',
        items: groupTaskNames,
        excludeSelected: false,
        onChanged: (value) async {
          final selectedGroupTask = groupTasks.firstWhere(
            (element) => element.tenNhomCongViec == value,
          );
          setState(() {
            data["congViecDto"]["nhomCongViecID"] =
                selectedGroupTask.nhomCongViecID;
          });
        },
      );
    });
  }

  Widget _selectPlanCompany() {
    return Consumer<CompanyManager>(builder: (ctx, companyManager, index) {
      List<String> companiesName = [];
      companies = companyManager.companies;
      for (var company in companies) {
        companiesName.add(company.tenCongTy.toString());
      }
      return CustomDropdown<String>.search(
        validator: (value) {
          if (value == null) {
            return 'Chọn Công ty';
          } else {
            return null;
          }
        },
        decoration: CustomDropdownDecoration(
            headerStyle: const TextStyle(color: Colors.blue),
            expandedBorderRadius: BorderRadius.circular(1),
            closedBorderRadius: BorderRadius.circular(4),
            closedBorder: Border.all(
                color: Colors.black38, width: 1, style: BorderStyle.solid)),
        hintText: 'Chọn Công ty',
        items: companiesName,
        excludeSelected: false,
        onChanged: (value) async {
          final selectedConpany = companies.firstWhere(
            (element) => element.tenCongTy == value,
          );
          await getDepartmentByIdCompany(ctx, selectedConpany.congTyID);
          setState(() {
            data["congViecDto"]["congTyID"] = selectedConpany.congTyID;
          });
        },
      );
    });
  }

  Widget _selectDepartment() {
    return Consumer<CompanyManager>(builder: (ctx, companyManager, index) {
      List<String> departMentsName = [];
      departments = companyManager.departments;
      for (var elm in departments) {
        departMentsName.add(elm.tenPhongBan.toString());
      }
      return CustomDropdown<String>.search(
        validator: (value) {
          if (value == null) {
            return 'Chọn phòng ban';
          } else {
            return null;
          }
        },
        decoration: CustomDropdownDecoration(
            headerStyle: const TextStyle(color: Colors.blue),
            expandedBorderRadius: BorderRadius.circular(1),
            closedBorderRadius: BorderRadius.circular(4),
            closedBorder: Border.all(
                color: Colors.black38, width: 1, style: BorderStyle.solid)),
        hintText: 'Chọn phòng ban',
        items: departMentsName,
        excludeSelected: false,
        onChanged: (value) async {
          final selectedDepartment = departments.firstWhere(
            (element) => element.tenPhongBan == value,
          );
          await getPositionByIdDepartment(
              context: ctx, id: selectedDepartment.phongBanID);
          setState(() {
            data["congViecDto"]["phongBanID"] = selectedDepartment.phongBanID;
          });
        },
      );
    });
  }

  Widget _selectPosition() {
    return Consumer<CompanyManager>(builder: (ctx, companyManger, index) {
      List<String> positionsName = [];
      positons = [];
      positons = companyManger.positons;
      for (var elm in positons) {
        positionsName.add(elm.tenChucVu.toString());
      }
      return CustomDropdown<String>.search(
        validator: (value) {
          if (value == null) {
            return 'Chọn chức vụ';
          } else {
            return null;
          }
        },
        decoration: CustomDropdownDecoration(
            headerStyle: const TextStyle(color: Colors.blue),
            expandedBorderRadius: BorderRadius.circular(1),
            closedBorderRadius: BorderRadius.circular(4),
            closedBorder: Border.all(
                color: Colors.black38, width: 1, style: BorderStyle.solid)),
        hintText: 'Chọn chức vụ',
        items: positionsName,
        excludeSelected: false,
        onChanged: (value) async {
          final selectedPotions = positons.firstWhere(
            (element) => element.tenChucVu == value,
          );
          await getStaffByIdPositon(context: ctx, id: selectedPotions.chucVuID);
          setState(() {
            data["congViecDto"]["chuVuID"] = selectedPotions.chucVuID;
          });
        },
      );
    });
  }

  Widget _selectStaff() {
    return Consumer<CompanyManager>(builder: (ctx, companyManger, idx) {
      List<String> staffsName = [];
      staffs = [];
      staffs = companyManger.staffs;
      for (var elm in staffs) {
        staffsName.add(elm.tenNhanVien.toString());
      }
      return CustomDropdown<String>.search(
        validator: (value) {
          if (value == null) {
            return 'Chọn người giao việc';
          } else {
            return null;
          }
        },
        decoration: CustomDropdownDecoration(
            headerStyle: const TextStyle(color: Colors.blue),
            expandedBorderRadius: BorderRadius.circular(1),
            closedBorderRadius: BorderRadius.circular(4),
            closedBorder: Border.all(
                color: Colors.black38, width: 1, style: BorderStyle.solid)),
        hintText: 'Chọn người giao việc',
        items: staffsName,
        excludeSelected: false,
        onChanged: (value) {
          final staffSelect =
              staffs.firstWhere((element) => element.tenNhanVien == value);
          data["congViecDto"]["nguoiThucHienTen"] = value;
          data["congViecDto"]["nguoiThucHienID"] = staffSelect.nhanVienID;
        },
      );
    });
  }

  Widget _selectFile() {
    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            await _pickFile();
          },
          child: Container(
            width: 105,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(30)),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chọn file',
                  style: TextStyle(color: Colors.white),
                ),
                Icon(
                  Icons.file_open,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: _fileName != null
              ? Text(_fileName.toString())
              : const Text('Tải file lên từ thiết bị'),
        )
      ],
    );
  }

  Widget _buttonSubmit() {
    return GestureDetector(
      onTap: () {
        submit();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(4)),
        child: const Center(
            child: Text(
          'Giao việc',
          style: TextStyle(color: Colors.white, fontSize: 18),
        )),
      ),
    );
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
