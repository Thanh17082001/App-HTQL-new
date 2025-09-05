class CompanyModel {
  int? congTyID;
  String? tenCongTy;
  String? maSoThue;
  int? tinhID;
  String? tinh;
  String? diaChi;
  bool? active;
  String? phongBan;
  String? createDate;
  String? createBy;
  String? updateDate;
  String? updateBy;
  String? activeDate;
  String? activeBy;

  CompanyModel(
      {this.congTyID,
      this.tenCongTy,
      this.maSoThue,
      this.tinhID,
      this.tinh,
      this.diaChi,
      this.active,
      this.phongBan,
      this.createDate,
      this.createBy,
      this.updateDate,
      this.updateBy,
      this.activeDate,
      this.activeBy});

  CompanyModel.fromJson(Map<String, dynamic> json) {
    congTyID = json['congTyID'];
    tenCongTy = json['tenCongTy'];
    maSoThue = json['maSoThue'];
    tinhID = json['tinhID'];
    tinh = json['tinh'];
    diaChi = json['diaChi'];
    active = json['active'];
    phongBan = json['phongBan'];
    createDate = json['createDate'];
    createBy = json['createBy'];
    updateDate = json['updateDate'];
    updateBy = json['updateBy'];
    activeDate = json['activeDate'];
    activeBy = json['activeBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['congTyID'] = congTyID;
    data['tenCongTy'] = tenCongTy;
    data['maSoThue'] = maSoThue;
    data['tinhID'] = tinhID;
    data['tinh'] = tinh;
    data['diaChi'] = diaChi;
    data['active'] = active;
    data['phongBan'] = phongBan;
    data['createDate'] = createDate;
    data['createBy'] = createBy;
    data['updateDate'] = updateDate;
    data['updateBy'] = updateBy;
    data['activeDate'] = activeDate;
    data['activeBy'] = activeBy;
    return data;
  }
}
