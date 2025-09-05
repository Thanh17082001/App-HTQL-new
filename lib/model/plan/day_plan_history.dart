import 'package:app_flutter/model/plan/status_plan_model.dart';
import 'package:app_flutter/model/staff/staff_model.dart';
import 'package:app_flutter/model/task/status_task_model.dart';

class DayHistoryModel {
  int? lsid;
  int? nhanVienID;
  StaffModel? nhanVien;
  String? thoiGan;
  int? trangThaiID;
  int? nguoiDuyetID;
  StatusPlanModel? khcTNgayTrangThai;
  String? tenNguoiDuyet;

  DayHistoryModel(
      {this.lsid,
      this.nhanVienID,
      this.nhanVien,
      this.thoiGan,
      this.trangThaiID,
      this.nguoiDuyetID,
      this.tenNguoiDuyet});

  DayHistoryModel.fromJson(Map<String, dynamic> json) {
    lsid = json['lsid'];
    nhanVienID = json['nhanVienID'];
    nhanVien =
        json['nhanVien'] != null ? StaffModel.fromJson(json['nhanVien']) : null;
        khcTNgayTrangThai =
        json['khcT_Ngay_TrangThai'] != null ? StatusPlanModel.fromJson(json['khcT_Ngay_TrangThai']) : null;
    thoiGan = json['thoiGan'];
    trangThaiID = json['trangThaiID'];
    nguoiDuyetID = json['nguoiDuyetID'];
    tenNguoiDuyet = json['tenNguoiDuyet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lsid'] = this.lsid;
    data['nhanVienID'] = this.nhanVienID;
    if (this.nhanVien != null) {
      data['nhanVien'] = this.nhanVien!.toJson();
    }
    data['thoiGan'] = this.thoiGan;
    data['trangThaiID'] = this.trangThaiID;
    data['nguoiDuyetID'] = this.nguoiDuyetID;
    data['tenNguoiDuyet'] = this.tenNguoiDuyet;
    return data;
  }
}
