import 'dart:async';
import 'dart:convert';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:app_flutter/model/auth/auth_model.dart';
import 'package:app_flutter/model/plan/day_plan_history.dart';
import 'package:app_flutter/model/plan/plan_day_model.dart';
import 'package:app_flutter/model/plan/role_model.dart';
import 'package:app_flutter/model/staff/staff_model.dart';
import 'package:app_flutter/shared/dialog.dart';
import 'package:app_flutter/shared/format_curency.dart';
import 'package:app_flutter/shared/loading_form.dart';
import 'package:app_flutter/ui/plan/manager/plan_manager.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

class PlanDetailScreen extends StatefulWidget {
  static String routerName = '/plan-detail';
  final int id;
  const PlanDetailScreen(this.id, {super.key});

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  late DayPlanModel? plan;
  String nameApproved = '';
  String nameAccountant = '';
  String nameAdministrative = '';
  int status = 0;
  bool check = false;
  late AuthModel user;
  final List<String> rolesAccountant = RoleModel().rolesAccountant;
  List<StaffModel> staffsAccountant = [];
  final List<String> rolesAdministrative = RoleModel().rolesAdministrative;
  List<StaffModel> staffsAdministrative = [];

  Future userLogin() async {
    final prefs = await SharedPreferences.getInstance();
    var initUser = prefs.getString('user');
    if (initUser != null) {
      user = AuthModel.fromJson(jsonDecode(initUser));
    }
  }

  Future getPlanDayByID(BuildContext context) async {
    await context.read<PlanManager>().getPlanDayByID(widget.id);
    await userLogin();
    getStaffByRolesCheck(context);
  }

  Future getStaffByRolesCheck(BuildContext context) async {
    staffsAccountant =
        await context.read<PlanManager>().getStaffByRolesCheck(rolesAccountant);
    // ignore: use_build_context_synchronously
    staffsAdministrative = await context
        .read<PlanManager>()
        .getStaffByRolesCheck(rolesAdministrative);
  }

  Future changeStatusPlan(type) async {
    int trangThaiID = plan!.khcTNgayLichSu![0].trangThaiID! + 1;
    if (type == 1) {
      if (plan!.khcTNgayLichSu![0].trangThaiID! == 3) {
        trangThaiID = 5;
      }
      final data = {
        "ngayID": plan!.ngayID,
        "trangThaiID": trangThaiID,
        "nguoiDuyetID": plan!.khcTNgayLichSu![0].nguoiDuyetID,
        "tenNguoiDuyet": plan!.khcTNgayLichSu![0].tenNguoiDuyet
      };

      context.read<PlanManager>().changeStatusPlan(data);
      await context.read<PlanManager>().getPlanDayByID(widget.id);
    } else {
      final data = {
        "ngayID": plan!.ngayID,
        "trangThaiID": 6,
        "nguoiDuyetID": plan!.khcTNgayLichSu![0].nguoiDuyetID,
        "tenNguoiDuyet": plan!.khcTNgayLichSu![0].tenNguoiDuyet
      };

      context.read<PlanManager>().changeStatusPlan(data);
    }
  }

  checkApproved(List<DayHistoryModel> history) {
    if (history.isEmpty) {
      return;
    }
    if (history.indexWhere((element) => element.trangThaiID == 2) != -1) {
      nameApproved =
          history[history.indexWhere((element) => element.trangThaiID == 2)]
                  .nhanVien
                  ?.tenNhanVien ??
              '';
      status = 1;
    }
    if (history.indexWhere((element) => element.trangThaiID == 3) != -1) {
      nameAccountant =
          history[history.indexWhere((element) => element.trangThaiID == 3)]
                  .nhanVien
                  ?.tenNhanVien ??
              '';
      status = 2;
    }
    // hoàn thành
    if (history.indexWhere((element) => element.trangThaiID == 5) != -1) {
      nameAdministrative =
          history[history.indexWhere((element) => element.trangThaiID == 5)]
                  .nhanVien
                  ?.tenNhanVien ??
              '';
      status = 3;
    }
    if (history.indexWhere((element) => element.trangThaiID == 6) != -1) {
      status = 6;
    }
    print('hành chánh');
    print(nameAdministrative);
    print('kế toán');
    print(nameAccountant);
  }

  activeButtonCheck(List<DayHistoryModel> history) {
    if (history.indexWhere((element) => element.trangThaiID == 6) == -1) {
      check = false;
    }
    if (history[0].trangThaiID == 1 && user.userID == history[0].nguoiDuyetID) {
      print('Quản lý d');
      check = true;
    } else if (history[0].trangThaiID == 2 &&
        staffsAccountant
                .indexWhere((element) => element.nhanVienID == user.userID) !=
            -1) {
      print('kết toán d');

      check = true;
    } else if (history[0].trangThaiID == 3 &&
        staffsAdministrative
                .indexWhere((element) => element.nhanVienID == user.userID) !=
            -1) {
      print('hành chánh duyêt');

      check = true;
    } else if (history[0].trangThaiID == 5) {
      print('hành chánh duyêt');

      check = false;
    }
    print('--------------');
    print(check);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color colorTitle = Colors.blue;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết kế hoạch công tác'),
      ),
      floatingActionButton: GestureDetector(
        onTap: () async {
          await getPlanDayByID(context);
          checkApproved(plan?.khcTNgayLichSu ?? []);
          activeButtonCheck(plan?.khcTNgayLichSu ?? []);
          modalBottom();
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          child: const Icon(
            Icons.timeline_sharp,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder(
          future: getPlanDayByID(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingFrom();
            }
            return Consumer<PlanManager>(
                builder: (context, planManager, index) {
              plan = planManager.planDayItem;
              checkApproved(plan?.khcTNgayLichSu ?? []);
              activeButtonCheck(plan?.khcTNgayLichSu ?? []);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  children: [
                    Text(
                      'I. Thông tin chung'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: colorTitle),
                    ),
                    _general(plan),
                    Text(
                      'II. Người đi cùng'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: colorTitle),
                    ),
                    _companion(plan),
                    Text(
                      'III. Nội dung công tác'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: colorTitle),
                    ),
                    _work(plan),
                    Text(
                      'IV. Sử dụng xe'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: colorTitle),
                    ),
                    _useCar(plan),
                    Text(
                      'V. Chi phí công tác'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: colorTitle),
                    ),
                    _costPlan(plan?.khcTChiPhi),
                    Text(
                      'V. Chi phí kinh doanh'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: colorTitle),
                    ),
                    _costBusiness(plan?.khcTChiPhi),
                    Text(
                      'V. Chi phí khác'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: colorTitle),
                    ),
                    _costOther(plan?.khcTChiPhiKhac)
                  ],
                ),
              );
            });
          }),
    );
  }

  Widget _general(plan) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Người tạo: ',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Text('${plan?.hoTen}')
            ],
          ),
           Row(
            children: [
              const Text(
                'Thời gian: ',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Text('${plan?.tuNgay} - ${plan?.denNgay}')
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                'Ngày tạo: ',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Text('${plan?.tuNgay}')
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mục đích: ',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                
              ),
              Expanded(
                child: Text('${plan?.mucDich}',
                  overflow: TextOverflow.fade,
                  softWrap: true,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Công ty đi công tác: ',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Expanded(
                child: Text('${plan?.khctTenCongTy ?? 'Chưa có thông tin'}',  overflow: TextOverflow.fade,
                  softWrap: true,
                ),
              )
            ],
          ),
          Row(
            children: [
              const Text(
                'Phòng ban: ',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Text('${plan?.tenPhongBan ?? 'Chưa có thông tin'}')
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                'Chức vụ: ',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Text('${plan?.tenChucVu ?? 'Chưa có thông tin '}')
            ],
          ),
        ],
      ),
    );
  }

  Widget _companion(plan) {
    final coms = plan.khcTNguoiDiCung;
    return Container(
      child: coms.isEmpty
          ? const Center(
              child: Text(
              'Chưa có dữ liệu',
              style: TextStyle(fontSize: 18),
            ))
          : Accordion(
              disableScrolling: true,
              headerBorderColor: Colors.blueGrey,
              headerBorderColorOpened: Colors.transparent,
              headerBorderWidth: 1,
              headerBackgroundColorOpened: Colors.green,
              contentBackgroundColor: Colors.white,
              contentBorderColor: Colors.green,
              contentBorderWidth: 3,
              scaleWhenAnimating: true,
              openAndCloseAnimation: true,
              headerPadding:
                  const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
              sectionClosingHapticFeedback: SectionHapticFeedback.light,
              children: _section(coms, context)),
    );
  }

  List<AccordionSection> _section(coms, BuildContext context) {
    List<AccordionSection> accs = [];
    coms.forEach((companion) {
      accs.add(
        AccordionSection(
          isOpen: false,
          rightIcon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black54,
            size: 20,
          ),
          headerBackgroundColor: Colors.transparent,
          headerBackgroundColorOpened: Colors.white,
          headerBorderColor: Colors.black54,
          headerBorderColorOpened: Colors.black54,
          headerBorderWidth: 1,
          headerBorderRadius: 4,
          headerPadding: const EdgeInsets.all(12),
          contentBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
          contentBorderColor: Colors.black54,
          contentBorderWidth: 1,
          contentVerticalPadding: 15,
          contentHorizontalPadding: 10,
          header: Text(companion.tenNhanVien.toString(),
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Họ Tên : ${companion.tenNhanVien.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Công ty : ${companion.tenCongTy.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Phòng ban : ${companion.tenPhongBan.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Chức vụ : ${companion.tenChuVu.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
            ],
          ),
        ),
      );
    });
    return accs;
  }

  Widget _work(plan) {
    final works = plan.khcTNoiDung;
    return Container(
      child: works.isEmpty
          ? const Center(
              child: Text(
              'Chưa có dữ liệu',
              style: TextStyle(fontSize: 18),
            ))
          : Accordion(
              disableScrolling: true,
              headerBorderColor: Colors.blueGrey,
              headerBorderColorOpened: Colors.transparent,
              headerBorderWidth: 1,
              headerBackgroundColorOpened: Colors.green,
              contentBackgroundColor: Colors.white,
              contentBorderColor: Colors.green,
              contentBorderWidth: 3,
              scaleWhenAnimating: true,
              openAndCloseAnimation: true,
              headerPadding:
                  const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
              sectionClosingHapticFeedback: SectionHapticFeedback.light,
              children: _sectionWork(works, context)),
    );
  }

  List<AccordionSection> _sectionWork(works, BuildContext context) {
    List<AccordionSection> accs = [];
    works.forEach((work) {
      accs.add(
        AccordionSection(
          isOpen: false,
          rightIcon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black54,
            size: 20,
          ),
          headerBackgroundColor: Colors.transparent,
          headerBackgroundColorOpened: Colors.white,
          headerBorderColor: Colors.black54,
          headerBorderColorOpened: Colors.black54,
          headerBorderWidth: 1,
          headerBorderRadius: 4,
          headerPadding: const EdgeInsets.all(12),
          contentBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
          contentBorderColor: Colors.black54,
          contentBorderWidth: 1,
          contentVerticalPadding: 15,
          contentHorizontalPadding: 0,
          header: Text(work.noiDen.toString(),
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nơi đến : ${work.noiDen.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Bước thị trường : ${work.tenBuocThiTruong.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Nội dung : ${work.chiTiet.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Ngày thực hiện : ${work.ngayThucHien.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Ghi chú : ${work.ghiChu.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
            ],
          ),
        ),
      );
    });
    return accs;
  }

  Widget _useCar(plan) {
    final cars = plan.khcTXe;
    return Container(
      child: cars.isEmpty
          ? const Center(
              child: Text(
              'Chưa có dữ liệu',
              style: TextStyle(fontSize: 18),
            ))
          : Accordion(
              disableScrolling: true,
              headerBorderColor: Colors.blueGrey,
              headerBorderColorOpened: Colors.transparent,
              headerBorderWidth: 1,
              headerBackgroundColorOpened: Colors.green,
              contentBackgroundColor: Colors.white,
              contentBorderColor: Colors.green,
              contentBorderWidth: 3,
              scaleWhenAnimating: true,
              openAndCloseAnimation: true,
              headerPadding:
                  const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
              sectionClosingHapticFeedback: SectionHapticFeedback.light,
              children: _sectionCar(cars, context)),
    );
  }

  List<AccordionSection> _sectionCar(cars, BuildContext context) {
    List<AccordionSection> accs = [];
    cars.forEach((car) {
      accs.add(
        AccordionSection(
          isOpen: false,
          rightIcon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black54,
            size: 20,
          ),
          headerBackgroundColor: Colors.transparent,
          headerBackgroundColorOpened: Colors.white,
          headerBorderColor: Colors.black54,
          headerBorderColorOpened: Colors.black54,
          headerBorderWidth: 1,
          headerBorderRadius: 4,
          headerPadding: const EdgeInsets.all(12),
          contentBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
          contentBorderColor: Colors.black54,
          contentBorderWidth: 1,
          contentVerticalPadding: 15,
          contentHorizontalPadding: 0,
          header: Text(car.ngaySuDung.toString(),
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nơi đi : ${car.noiDi.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Nơi đến : ${car.noiDen.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Số km tạm tính : ${car.kmTamTinh.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Ngày sử dụng : ${car.ngaySuDung.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
              Text(
                'Ghi chú : ${car.ghiChu.toString()}',
                maxLines: 4,
                style: const TextStyle(color: Colors.black45, fontSize: 17),
              ),
            ],
          ),
        ),
      );
    });
    return accs;
  }

  Widget _costPlan(costs) {
    return Container(
      child: costs.isEmpty
          ? const Center(
              child: Text(
              'Chưa có dữ liệu',
              style: TextStyle(fontSize: 18),
            ))
          : Accordion(
              disableScrolling: true,
              headerBorderColor: Colors.blueGrey,
              headerBorderColorOpened: Colors.transparent,
              headerBorderWidth: 1,
              headerBackgroundColorOpened: Colors.green,
              contentBackgroundColor: Colors.white,
              contentBorderColor: Colors.green,
              contentBorderWidth: 3,
              scaleWhenAnimating: true,
              openAndCloseAnimation: true,
              headerPadding:
                  const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
              sectionClosingHapticFeedback: SectionHapticFeedback.light,
              children: _sectionCost(costs, context)),
    );
  }

  List<AccordionSection> _sectionCost(costs, BuildContext context) {
    List<AccordionSection> accs = [];
    costs.forEach((cost) {
      if (cost.loaiChiPhiID == 1) {
        accs.add(
          AccordionSection(
            isOpen: false,
            rightIcon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black54,
              size: 20,
            ),
            headerBackgroundColor: Colors.transparent,
            headerBackgroundColorOpened: Colors.white,
            headerBorderColor: Colors.black54,
            headerBorderColorOpened: Colors.black54,
            headerBorderWidth: 1,
            headerBorderRadius: 4,
            headerPadding: const EdgeInsets.all(12),
            contentBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
            contentBorderColor: Colors.black54,
            contentBorderWidth: 1,
            contentVerticalPadding: 15,
            contentHorizontalPadding: 0,
            header: Text(
                '${cost?.khcT_HangMucChiPhi?['tenHangMuc'].toString()}',
                style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hạng mục : ${cost?.khcT_HangMucChiPhi?['tenHangMuc'].toString()} ',
                  maxLines: 4,
                  style: const TextStyle(color: Colors.black45, fontSize: 17),
                ),
                Text(
                  'Số lượng : ${cost.soLuong.toString()}',
                  maxLines: 4,
                  style: const TextStyle(color: Colors.black45, fontSize: 17),
                ),
                Text(
                  'Đơn giá : ${formatCurency(cost.donGia.toString())}',
                  maxLines: 4,
                  style: const TextStyle(color: Colors.black45, fontSize: 17),
                ),
                Text(
                  'Thành tiền : ${formatCurency(cost.thanhTien.toString())}',
                  maxLines: 4,
                  style: const TextStyle(color: Colors.black45, fontSize: 17),
                ),
                Text(
                  'Ghi chú : ${cost.ghiChu.toString()}',
                  maxLines: 4,
                  style: const TextStyle(color: Colors.black45, fontSize: 17),
                ),
              ],
            ),
          ),
        );
      }
    });
    return accs;
  }

  Widget _costBusiness(costs) {
    return Container(
      child: costs.isEmpty
          ? const Center(
              child: Text(
              'Chưa có dữ liệu',
              style: TextStyle(fontSize: 18),
            ))
          : Accordion(
              disableScrolling: true,
              headerBorderColor: Colors.blueGrey,
              headerBorderColorOpened: Colors.transparent,
              headerBorderWidth: 1,
              headerBackgroundColorOpened: Colors.green,
              contentBackgroundColor: Colors.white,
              contentBorderColor: Colors.green,
              contentBorderWidth: 3,
              scaleWhenAnimating: true,
              openAndCloseAnimation: true,
              headerPadding:
                  const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
              sectionClosingHapticFeedback: SectionHapticFeedback.light,
              children: _sectionCostBusiness(costs, context)),
    );
  }

  List<AccordionSection> _sectionCostBusiness(costs, BuildContext context) {
    List<AccordionSection> accs = [];
    costs.forEach((cost) {
      if (cost.loaiChiPhiID != 1) {
        accs.add(
          AccordionSection(
            isOpen: false,
            rightIcon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black54,
              size: 20,
            ),
            headerBackgroundColor: Colors.transparent,
            headerBackgroundColorOpened: Colors.white,
            headerBorderColor: Colors.black54,
            headerBorderColorOpened: Colors.black54,
            headerBorderWidth: 1,
            headerBorderRadius: 4,
            headerPadding: const EdgeInsets.all(12),
            contentBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
            contentBorderColor: Colors.black54,
            contentBorderWidth: 1,
            contentVerticalPadding: 15,
            contentHorizontalPadding: 0,
            header: Text(
                '${cost?.khcT_HangMucChiPhi?['tenHangMuc'].toString()}',
                style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hạng mục : ${cost?.khcT_HangMucChiPhi?['tenHangMuc'].toString()} ',
                  maxLines: 4,
                  style: const TextStyle(color: Colors.black45, fontSize: 17),
                ),
                Text(
                  'Số lượng : ${cost.soLuong.toString()}',
                  maxLines: 4,
                  style: const TextStyle(color: Colors.black45, fontSize: 17),
                ),
                Text(
                  'Đơn giá : ${formatCurency(cost.donGia.toString())}',
                  maxLines: 4,
                  style: const TextStyle(color: Colors.black45, fontSize: 17),
                ),
                Text(
                  'Thành tiền : ${formatCurency(cost.thanhTien.toString())}',
                  maxLines: 4,
                  style: const TextStyle(color: Colors.black45, fontSize: 17),
                ),
                Text(
                  'Ghi chú : ${cost.ghiChu.toString()}',
                  maxLines: 4,
                  style: const TextStyle(color: Colors.black45, fontSize: 17),
                ),
              ],
            ),
          ),
        );
      }
    });
    return accs;
  }

  Widget _costOther(costs) {
    return Container(
      child: costs.isEmpty
          ? const Center(
              child: Text(
              'Chưa có dữ liệu',
              style: TextStyle(fontSize: 18),
            ))
          : Accordion(
              disableScrolling: true,
              headerBorderColor: Colors.blueGrey,
              headerBorderColorOpened: Colors.transparent,
              headerBorderWidth: 1,
              headerBackgroundColorOpened: Colors.green,
              contentBackgroundColor: Colors.white,
              contentBorderColor: Colors.green,
              contentBorderWidth: 3,
              scaleWhenAnimating: true,
              openAndCloseAnimation: true,
              headerPadding:
                  const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
              sectionClosingHapticFeedback: SectionHapticFeedback.light,
              children: _sectionCostOther(costs, context)),
    );
  }

  List<AccordionSection> _sectionCostOther(costs, BuildContext context) {
    List<AccordionSection> accs = [];
    costs.forEach((cost) {
      if (cost.loaiChiPhiID != 1) {
        accs.add(
          AccordionSection(
            isOpen: false,
            rightIcon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black54,
              size: 20,
            ),
            headerBackgroundColor: Colors.transparent,
            headerBackgroundColorOpened: Colors.white,
            headerBorderColor: Colors.black54,
            headerBorderColorOpened: Colors.black54,
            headerBorderWidth: 1,
            headerBorderRadius: 4,
            headerPadding: const EdgeInsets.all(12),
            contentBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
            contentBorderColor: Colors.black54,
            contentBorderWidth: 1,
            contentVerticalPadding: 15,
            contentHorizontalPadding: 0,
            header: Text('${cost?.hangMuc.toString()}',
                style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hạng mục : ${cost?.hangMuc.toString()} ',
                  maxLines: 4,
                  style: const TextStyle(color: Colors.black45, fontSize: 17),
                ),
                Text(
                  'Số lượng : ${cost.soLuong.toString()}',
                  maxLines: 4,
                  style: const TextStyle(color: Colors.black45, fontSize: 17),
                ),
                Text(
                  'Đơn giá : ${formatCurency(cost.donGia.toString())}',
                  maxLines: 4,
                  style: const TextStyle(color: Colors.black45, fontSize: 17),
                ),
                Text(
                  'Thành tiền : ${formatCurency(cost.thanhTien.toString())}',
                  maxLines: 4,
                  style: const TextStyle(color: Colors.black45, fontSize: 17),
                ),
                Text(
                  'Ghi chú : ${cost.ghiChu.toString()}',
                  maxLines: 4,
                  style: const TextStyle(color: Colors.black45, fontSize: 17),
                ),
              ],
            ),
          ),
        );
      }
    });
    return accs;
  }

  modalBottom() {
    return showBarModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: !check
                ? MediaQuery.of(context).size.height * 0.75
                : MediaQuery.of(context).size.height * 0.90,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Timeline(
                    children: <TimelineModel>[
                      TimelineModel(
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Center(
                              child: status != 6
                                  ? Text(status >= 1
                                      ? nameApproved.toString()
                                      : 'Quản lý duyệt')
                                  : Text(
                                      nameApproved == ''
                                          ? 'Từ chối duyệt'
                                          : nameApproved.toString(),
                                      style: TextStyle(color: Colors.red),
                                    ),
                            ),
                          ),
                          icon: Icon(status >= 1 && status < 6
                              ? Icons.check
                              : Icons.cancel),
                          iconBackground: status >= 1 && status < 6
                              ? Colors.green
                              : Colors.grey,
                          position: TimelineItemPosition.left),
                      TimelineModel(
                          Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Center(
                              child: status != 6
                                  ? Text(status >= 2
                                      ? nameAccountant.toString()
                                      : 'Ban tài chính, kế hoạch')
                                  : Text(
                                      nameAccountant == ''
                                          ? 'Từ chối duyệt'
                                          : nameAccountant.toString(),
                                      style: TextStyle(color: Colors.red),
                                    ),
                            ),
                          ),
                          icon: Icon(status >= 2 && status < 6
                              ? Icons.check
                              : Icons.cancel),
                          iconBackground: status >= 2 && status < 6
                              ? Colors.green
                              : Colors.grey,
                          position: TimelineItemPosition.right),
                      TimelineModel(
                          Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Center(
                              child: status != 6
                                  ? Text(status == 3
                                      ? nameAdministrative.toString()
                                      : 'Ban pháp chế, hành chính, nhân sự')
                                  : Text(
                                      nameAdministrative == ''
                                          ? 'Từ chối duyệt'
                                          : nameAdministrative.toString(),
                                      style: TextStyle(color: Colors.red),
                                    ),
                            ),
                          ),
                          icon: Icon(status == 3 ? Icons.check : Icons.cancel),
                          iconBackground:
                              status == 3 ? Colors.green : Colors.grey,
                          position: TimelineItemPosition.left),
                    ],
                    position: TimelinePosition.Center,
                    iconSize: 40,
                    lineColor: Colors.blue,
                  ),
                ),
                if (check)
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          if (check)
                            GestureDetector(
                              onTap: () async {
                                await changeStatusPlan(1);
                                DialogForm.successDialog(context);
                                setState(() async {
                                  await getPlanDayByID(context);
                                  checkApproved(plan?.khcTNgayLichSu ?? []);
                                  activeButtonCheck(plan?.khcTNgayLichSu ?? []);
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Colors.green,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: const Center(
                                    child: Text(
                                  'Duyệt kế hoạch',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )),
                              ),
                            ),
                          if (check)
                            const SizedBox(
                              height: 15,
                            ),
                          if (check)
                            GestureDetector(
                              onTap: () async {
                                await changeStatusPlan(0);
                                DialogForm.successDialog(context);
                                setState(() async {
                                  await getPlanDayByID(context);
                                  checkApproved(plan?.khcTNgayLichSu ?? []);
                                  activeButtonCheck(plan?.khcTNgayLichSu ?? []);
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: const Center(
                                    child: Text(
                                  'Từ chối',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        });
  }
}
