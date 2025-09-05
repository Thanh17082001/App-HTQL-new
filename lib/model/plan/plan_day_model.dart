import 'package:app_flutter/model/plan/companion_model.dart';
import 'package:app_flutter/model/plan/cost_model.dart';
import 'package:app_flutter/model/plan/day_plan_history.dart';
import 'package:app_flutter/model/plan/use_car_model.dart';
import 'package:app_flutter/model/plan/week_plan_model.dart';
import 'package:app_flutter/model/plan/working_content_model.dart';

class DayPlanModel {
  int? ngayID;
  int? nguoiTaoID;
  String? hoTen;
  int? chucVuID;
  String? tenChucVu;
  int? phongBanID;
  String? tenPhongBan;
  int? congTyID;
  String? tenCongTy;
  String? tuNgay;
  String? denNgay;
  String? mucDich;
  int? khctCongTyID;
  String? khctTenCongTy;
  int? tuanID;
  WeekPlanModel? khcTTuan;
  List<CompanionModel>? khcTNguoiDiCung;
  List<WorkingContentModel>? khcTNoiDung;
  List<UseCarModel>? khcTXe;
  List<CostModel>? khcTChiPhi;
  List<DayHistoryModel>? khcTNgayLichSu;
  List<CostModel>? khcTChiPhiKhac;

  DayPlanModel(
      {this.ngayID,
      this.nguoiTaoID,
      this.hoTen,
      this.chucVuID,
      this.tenChucVu,
      this.phongBanID,
      this.tenPhongBan,
      this.congTyID,
      this.tenCongTy,
      this.tuNgay,
      this.denNgay,
      this.mucDich,
      this.tuanID,
      this.khctTenCongTy,
      this.khctCongTyID,
      this.khcTTuan,
      this.khcTNguoiDiCung,
      this.khcTNoiDung,
      this.khcTXe,
      this.khcTChiPhi,
      this.khcTNgayLichSu,
      this.khcTChiPhiKhac});

  DayPlanModel.fromJson(Map<String, dynamic> json) {
    ngayID = json['ngayID'];
    nguoiTaoID = json['nguoiTaoID'];
    hoTen = json['hoTen'];
    chucVuID = json['chucVuID'];
    tenChucVu = json['tenChucVu'];
    phongBanID = json['phongBanID'];
    tenPhongBan = json['tenPhongBan'];
    congTyID = json['congTyID'];
    tenCongTy = json['tenCongTy'];
    tuNgay = json['tuNgay'];
    denNgay = json['denNgay'];
    mucDich = json['mucDich'];
    tuanID = json['tuanID'];
    khctCongTyID = json['khctCongTyID'];
    khctTenCongTy = json['khctTenCongTy'];
    khcTTuan = json['khcT_Tuan'] != null
        ? WeekPlanModel.fromJson(json['khcT_Tuan'])
        : null;
    if (json['khcT_NguoiDiCung'] != null) {
      khcTNguoiDiCung = <CompanionModel>[];
      json['khcT_NguoiDiCung'].forEach((v) {
        khcTNguoiDiCung!.add(CompanionModel.fromJson(v));
      });
    }
    if (json['khcT_NoiDung'] != null) {
      khcTNoiDung = <WorkingContentModel>[];
      json['khcT_NoiDung'].forEach((v) {
        khcTNoiDung!.add(WorkingContentModel.fromJson(v));
      });
    }
    if (json['khcT_Xe'] != null) {
      khcTXe = <UseCarModel>[];
      json['khcT_Xe'].forEach((v) {
        khcTXe!.add(UseCarModel.fromJson(v));
      });
    }
    if (json['khcT_ChiPhi'] != null) {
      khcTChiPhi = <CostModel>[];
      json['khcT_ChiPhi'].forEach((v) {
        khcTChiPhi!.add(CostModel.fromJson(v));
      });
    }
    if (json['khcT_Ngay_LichSu'] != null) {
      khcTNgayLichSu = <DayHistoryModel>[];
      json['khcT_Ngay_LichSu'].forEach((v) {
        khcTNgayLichSu!.add(DayHistoryModel.fromJson(v));
      });
    }
    if (json['khcT_ChiPhiKhac'] != null) {
      khcTChiPhiKhac = <CostModel>[];
      json['khcT_ChiPhiKhac'].forEach((v) {
        khcTChiPhiKhac!.add(CostModel.fromJson(v));
      });
    }
  }
}
