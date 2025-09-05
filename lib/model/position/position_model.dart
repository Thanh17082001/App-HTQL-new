class PositionModel {
  int? chucVuID;
  String? tenChucVu;
  String? chiTiet;
  int? phongBanID;
  bool? active;
  String? phongBan;
  String? nhanVien;
  String? createDate;
  String? createBy;
  String? updateDate;
  String? updateBy;
  String? activeDate;
  String? activeBy;

  PositionModel(
      {this.chucVuID,
      this.tenChucVu,
      this.chiTiet,
      this.phongBanID,
      this.active,
      this.phongBan,
      this.nhanVien,
      this.createDate,
      this.createBy,
      this.updateDate,
      this.updateBy,
      this.activeDate,
      this.activeBy});

  PositionModel.fromJson(Map<String, dynamic> json) {
    chucVuID = json['chucVuID'];
    tenChucVu = json['tenChucVu'];
    chiTiet = json['chiTiet'];
    phongBanID = json['phongBanID'];
    active = json['active'];
    phongBan = json['phongBan'];
    nhanVien = json['nhanVien'];
    createDate = json['createDate'];
    createBy = json['createBy'];
    updateDate = json['updateDate'];
    updateBy = json['updateBy'];
    activeDate = json['activeDate'];
    activeBy = json['activeBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chucVuID'] = chucVuID;
    data['tenChucVu'] = tenChucVu;
    data['chiTiet'] = chiTiet;
    data['phongBanID'] = phongBanID;
    data['active'] = active;
    data['phongBan'] = phongBan;
    data['nhanVien'] = nhanVien;
    data['createDate'] = createDate;
    data['createBy'] = createBy;
    data['updateDate'] = updateDate;
    data['updateBy'] = updateBy;
    data['activeDate'] = activeDate;
    data['activeBy'] = activeBy;
    return data;
  }
}
