import 'package:app_flutter/model/plan/general_plan.dart';
import 'package:app_flutter/model/plan/plan_day_model.dart';
import 'package:app_flutter/model/plan/plan_model.dart';
import 'package:app_flutter/model/staff/staff_model.dart';
import 'package:app_flutter/service/plan/plan_service.dart';
import 'package:flutter/material.dart';

class PlanManager with ChangeNotifier {
  final PlanService _planService = PlanService();
  List<WeekModel> _items = [];
  List<StaffModel> items2 = [];
  List<StaffModel> items3 = [];
  List<DayPlanModel> plansDay = [];
  late DayPlanModel? planDay;

  List<WeekModel> get planWeeks {
    return _items;
  }

  List<DayPlanModel> get planDays {
    return plansDay;
  }

  DayPlanModel? get planDayItem {
    return planDay;
  }

  List<StaffModel> get staffs {
    return items2;
  }

  List<StaffModel> get staffsCheck {
    return items3;
  }

  Future getPlanWeekByIdUser() async {
    _items = [];
    _items = await _planService.getPlanWeekByIdUser();
    notifyListeners();
  }

  Future getStaffByRoles() async {
    items2 = await _planService.getStaffByRoles();
    notifyListeners();
  }

  Future getStaffByRolesCheck(roles) async {
    items3 = [];
    items3 = await _planService.getStaffByRolesCheck(roles);
    notifyListeners();
    return items3;
  }

  Future addPlanDay(PlanDayModel data, companions, wokrs, cars, costPlan,
      costBusiness, costOther) async {
    await _planService.addPlanDay(
        data, companions, wokrs, cars, costPlan, costBusiness, costOther);
    notifyListeners();
  }

  Future getAllPlanDay() async {
    plansDay = await _planService.getAllPlanDay();
    notifyListeners();
  }

  Future getPlanDayByID(int id) async {
    planDay = await _planService.getPlanDayById(id);
    notifyListeners();
  }

  Future changeStatusPlan(data) async{
    await _planService.changeStatusPlan(data);
  }
}
