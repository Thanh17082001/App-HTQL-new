import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:app_flutter/model/company/company_model.dart';
import 'package:app_flutter/model/department/department_model.dart';
import 'package:app_flutter/model/plan/companion_model.dart';
import 'package:app_flutter/model/position/position_model.dart';
import 'package:app_flutter/model/staff/staff_model.dart';
import 'package:app_flutter/shared/dialog.dart';
import 'package:app_flutter/ui/plan/manager/company_manager.dart';
import 'package:app_flutter/ui/plan/manager/companion_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Companion extends StatefulWidget {
  static const routerName = '/companion';
  const Companion({super.key});

  @override
  State<Companion> createState() => _GeneralInfomationState();
}

class _GeneralInfomationState extends State<Companion> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormFieldState<String>> departmentKey =
      GlobalKey<FormFieldState<String>>();

  final TextEditingController selectController = TextEditingController();
  List<DateTime>? dateTimeList;
  late String selected;
  List<CompanyModel> companies = [];
  List<DepartmentModel> departments = [];
  List<PositionModel> positons = [];
  List<StaffModel> staffs = [];
  bool isDate = false;

  CompanionModel _companionData = CompanionModel();

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

  submit() {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        isDate = true;
      });
      return;
    }
    _formKey.currentState!.save();

    context.read<CompanionManager>().addCompanion(_companionData);

    DialogForm.successDialog(context);
    _formKey.currentState!.reset();
    _companionData = CompanionModel();
  }

  @override
  void initState() {
    super.initState();
    getAllCompanies(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm người đi cùng'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    child: const Text('Người đi cùng'),
                  ),
                  _selectStaff(),
                  Container(
                    height: 25,
                    margin: const EdgeInsets.only(top: 20),
                  ),
                  _buttonSubmit()
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
            _companionData.tenCongTy = value;
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
        key: departmentKey,
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
            _companionData.tenPhongBan = value;
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
            _companionData.tenChuVu = value;
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
            return 'Chọn người đi cùng';
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
        hintText: 'Chọn người đi cùng',
        items: staffsName,
        excludeSelected: false,
        onChanged: (value) {
          final staffSelect =
              staffs.firstWhere((element) => element.tenNhanVien == value);
          _companionData.tenNhanVien = value;
          _companionData.nhanVienID = staffSelect.nhanVienID;
        },
      );
    });
  }

  Widget _buttonSubmit() {
    return GestureDetector(
      onTap: () {
        submit();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(4)),
        child: const Center(
            child: Text(
          'Thêm',
          style: TextStyle(color: Colors.white, fontSize: 18),
        )),
      ),
    );
  }
}
