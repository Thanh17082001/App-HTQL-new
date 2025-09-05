import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:app_flutter/model/company/company_model.dart';
import 'package:app_flutter/model/plan/general_plan.dart';
import 'package:app_flutter/model/plan/plan_model.dart';
import 'package:app_flutter/model/staff/staff_model.dart';
import 'package:app_flutter/shared/dialog.dart';
import 'package:app_flutter/shared/loading_form.dart';
import 'package:app_flutter/ui/plan/manager/companion_manager.dart';
import 'package:app_flutter/ui/plan/manager/company_manager.dart';
import 'package:app_flutter/ui/plan/manager/cost_business_manager.dart';
import 'package:app_flutter/ui/plan/manager/cost_other_manager.dart';
import 'package:app_flutter/ui/plan/manager/cost_plan_manager.dart';
import 'package:app_flutter/ui/plan/manager/plan_manager.dart';
import 'package:app_flutter/ui/plan/manager/use_car_manager.dart';
import 'package:app_flutter/ui/plan/manager/working_content_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

class GeneralInfomation extends StatefulWidget {
  const GeneralInfomation({super.key});

  @override
  State<GeneralInfomation> createState() => _GeneralInfomationState();
}

class _GeneralInfomationState extends State<GeneralInfomation> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  List<DateTime>? dateTimeList;
  late String selected;
  List<WeekModel> weeks = [];
  List<StaffModel> staffs = [];
  bool isDate = false;
  bool isLoading = false;
  List<CompanyModel> companies = [];

  final PlanDayModel _data = PlanDayModel();

  Future getPlanWeekByIdUser(BuildContext context) async {
    await context.read<PlanManager>().getPlanWeekByIdUser();
    // ignore: use_build_context_synchronously
    await context.read<PlanManager>().getStaffByRoles();
    // ignore: use_build_context_synchronously
    await getAllCompanies(context);
  }

  Future getAllCompanies(BuildContext context) async {
    await context.read<CompanyManager>().getAll();
  }

  submit() async {
    try {
      if (!_formKey.currentState!.validate() ||
          dateTimeList?[0] == null ||
          dateTimeList?[1] == null) {
        setState(() {
          isDate = true;
        });
        return;
      }
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      final companions = context.read<CompanionManager>().companions;
      final wokrs = context.read<WorkingContentManager>().works;
      final cars = context.read<UseCarManager>().cars;
      final costPlan = context.read<CostPlanManager>().costs;
      final costBusiness = context.read<CostBusinessManager>().costs;
      final costOther = context.read<CostOtherManager>().costs;
      await context.read<PlanManager>().addPlanDay(
          _data, companions, wokrs, cars, costPlan, costBusiness, costOther);
      setState(() {
        isLoading = false;
        DialogForm.successDialog(context);
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getPlanWeekByIdUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loadingFrom()
        : SingleChildScrollView(
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
                        child: const Text('Kế hoạch tuần'),
                      ),
                      _selectPlanWeek(),
                        Container(
                        height: 25,
                        margin: const EdgeInsets.only(top: 20),
                        child: const Text('Chọn công ty đi công tác'),
                      ),
                      _selectPlanCompany(),
                      Container(
                        height: 25,
                        margin: const EdgeInsets.only(top: 20),
                        child: const Text('Người duyệt kế hoạch'),
                      ),
                      _selectReviewerWeek(),
                      Container(
                        height: 25,
                        margin: const EdgeInsets.only(top: 20),
                        child: const Text('Ngày bắt đầu - Ngày kết thúc'),
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
                        child: const Text('Mục đích'),
                      ),
                      _purpose(),
                      SizedBox(
                        height: isDate ? 5 : 30,
                      ),
                      _buttonSubmit()
                    ],
                  ),
                ),
              ),
            ),
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
        _data.tuNgay = formatDateTime(dateTimeList![0]);
        _data.denNgay = formatDateTime(dateTimeList![1]);
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
          setState(() {
            _data.khctCongTyID = selectedConpany.congTyID;
            _data.khctTenCongTy = value;
          });
        },
      );
    });
  }

  Widget _selectPlanWeek() {
    return Consumer<PlanManager>(builder: (ctx, planManager, index) {
      List<String> weeksName = [];
      weeks = planManager.planWeeks;
      for (var elm in weeks) {
        final name = elm.tieuDe.toString();
        weeksName.add(name);
      }
      return CustomDropdown<String>.search(
        validator: (value) {
          if (value == null) {
            return 'Chọn kế hoạch tuần';
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
        hintText: 'Chọn kế hoạch tuần',
        items: weeksName,
        excludeSelected: false,
        onChanged: (value) {
          final weekSelected =
              weeks.firstWhere((element) => element.tieuDe == value);
          _data.tuanID = weekSelected.tuanID!;
        },
      );
    });
  }

  Widget _selectReviewerWeek() {
    return Consumer<PlanManager>(builder: (ctx, planManager, idx) {
      List<String> staffsName = [];
      staffs = planManager.staffs;
      for (var elm in staffs) {
        staffsName.add(elm.tenNhanVien.toString());
      }
      print({'nhân viên:': staffs});
      return CustomDropdown<String>.search(
        validator: (value) {
          if (value == null) {
            return 'Chọn người duyệt kế hoạch';
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
        hintText: 'Chọn người duyệt',
        items: staffsName,
        excludeSelected: false,
        onChanged: (value) {
          final staffSelected =
              staffs.firstWhere((element) => element.tenNhanVien == value);
          _data.tenNguoiDuyet = staffSelected.tenNhanVien;
          _data.nguoiDuyetID = staffSelected.nhanVienID;
        },
      );
    });
  }

  Widget _purpose() {
    return TextFormField(
      decoration: InputDecoration(
          hintText: 'Mục đích',
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
          return 'Nhập mục đích';
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        _data.mucDich = newValue!;
      },
    );
  }

  Widget _buttonSubmit() {
    return GestureDetector(
      onTap: () async {
        await submit();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(4)),
        child: const Center(
            child: Text(
          'Trình kế hoạch',
          style: TextStyle(color: Colors.white, fontSize: 18),
        )),
      ),
    );
  }

  String formatDate(DateTime date) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    String formattedDate =
        dateFormat.format(date.toUtc().add(const Duration(hours: 7)));
    return formattedDate;
  }

  String formatDateTime(DateTime date) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    String formattedDate =
        dateFormat.format(date.toUtc().add(const Duration(hours: 7)));
    return formattedDate;
  }
}
