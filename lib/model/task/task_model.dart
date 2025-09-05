
import 'package:app_flutter/model/task/history_model.dart';
import 'package:app_flutter/model/task/task_file.dart';

class TaskModel {
  int? congViecID;
  String? tenCongViec;
  String? moTa;
  String? ngayBatDau;
  String? ngayKetThuc;
  int? uuTienID;
  String? tenDoUuTien;
  int? nhomCongViecID;
  String? tenNhomCongViec;
  int? congTyID;
  String? tenCongTy;
  int? phongBanID;
  String? tenPhongBan;
  int? chuVuID;
  String? tenChucVu;
  int? nguoiTaoID;
  String? tenNguoiTao;
  int? nguoiThucHienID;
  String? nguoiThucHienTen;
  List<TaskFileModel>? fileCongViec;
  List<HistoryTaskModel>? lichSuCongViec;

  TaskModel(
      {this.congViecID,
      this.tenCongViec,
      this.moTa,
      this.ngayBatDau,
      this.ngayKetThuc,
      this.uuTienID,
      this.tenDoUuTien,
      this.nhomCongViecID,
      this.tenNhomCongViec,
      this.congTyID,
      this.tenCongTy,
      this.phongBanID,
      this.tenPhongBan,
      this.chuVuID,
      this.tenChucVu,
      this.nguoiTaoID,
      this.tenNguoiTao,
      this.nguoiThucHienID,
      this.nguoiThucHienTen,
      this.fileCongViec,
      this.lichSuCongViec});

  TaskModel.fromJson(Map<String, dynamic> json) {
    congViecID = json['congViecID'];
    tenCongViec = json['tenCongViec'];
    moTa = json['moTa'];
    ngayBatDau = json['ngayBatDau'];
    ngayKetThuc = json['ngayKetThuc'];
    uuTienID = json['uuTienID'];
    tenDoUuTien = json['tenDoUuTien'];
    nhomCongViecID = json['nhomCongViecID'];
    tenNhomCongViec = json['tenNhomCongViec'];
    congTyID = json['congTyID'];
    tenCongTy = json['tenCongTy'];
    phongBanID = json['phongBanID'];
    tenPhongBan = json['tenPhongBan'];
    chuVuID = json['chuVuID'];
    tenChucVu = json['tenChucVu'];
    nguoiTaoID = json['nguoiTaoID'];
    tenNguoiTao = json['tenNguoiTao'];
    nguoiThucHienID = json['nguoiThucHienID'];
    nguoiThucHienTen = json['nguoiThucHienTen'];
   
    if (json['lichSuCongViec'] != null) {
      lichSuCongViec = <HistoryTaskModel>[];
      json['lichSuCongViec'].forEach((v) {
        lichSuCongViec!.add(HistoryTaskModel.fromJson(v));
      });
    }

    if (json['fileCongViec'] != null) {
      fileCongViec = <TaskFileModel>[];
      json['fileCongViec'].forEach((v) {
        fileCongViec!.add(TaskFileModel.fromJson(v));
      });
    }
  }

}
