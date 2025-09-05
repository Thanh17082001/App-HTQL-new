import 'package:app_flutter/model/staff/staff_model.dart';
import 'package:app_flutter/model/task/status_task_model.dart';

class HistoryTaskModel {
  int? lsid;
  int? nhanVienID;
  StaffModel? nhanVien;
  String? moTa;
  String? thoiGian;
  int? trangThaiID;
  StatusTaskModel? trangThaiCongViec;
  int? tienDo;

  HistoryTaskModel(
      {this.lsid,
      this.nhanVienID,
      this.nhanVien,
      this.moTa,
      this.thoiGian,
      this.trangThaiID,
      this.trangThaiCongViec,
      this.tienDo});

  HistoryTaskModel.fromJson(Map<String, dynamic> json) {
    lsid = json['lsid'];
    nhanVienID = json['nhanVienID'];
    nhanVien = json['nhanVien'] != null
        ? StaffModel.fromJson(json['nhanVien'])
        : null;
    moTa = json['moTa'];
    thoiGian = json['thoiGian'];
    trangThaiID = json['trangThaiID'];
    trangThaiCongViec = json['trangThaiCongViec'] != null
        ? StatusTaskModel.fromJson(json['trangThaiCongViec'])
        : null;
    tienDo = json['tienDo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lsid'] = this.lsid;
    data['nhanVienID'] = this.nhanVienID;
    if (this.nhanVien != null) {
      data['nhanVien'] = this.nhanVien!.toJson();
    }
    data['moTa'] = this.moTa;
    data['thoiGian'] = this.thoiGian;
    data['trangThaiID'] = this.trangThaiID;
    if (this.trangThaiCongViec != null) {
      data['trangThaiCongViec'] = this.trangThaiCongViec!.toJson();
    }
    data['tienDo'] = this.tienDo;
    return data;
  }
}

