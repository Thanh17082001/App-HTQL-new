class DepartmentModel {
  int? phongBanID;
  String? tenPhongBan;
  String? chiTiet;
  int? congTyID;
  bool? active;
  String? congTy;
  String? chucVu;
  String? createDate;
  String? createBy;
  String? updateDate;
  String? updateBy;
  String? activeDate;
  String? activeBy;

  DepartmentModel(
      {this.phongBanID,
      this.tenPhongBan,
      this.chiTiet,
      this.congTyID,
      this.active,
      this.congTy,
      this.chucVu,
      this.createDate,
      this.createBy,
      this.updateDate,
      this.updateBy,
      this.activeDate,
      this.activeBy});

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    phongBanID = json['phongBanID'];
    tenPhongBan = json['tenPhongBan'];
    chiTiet = json['chiTiet'];
    congTyID = json['congTyID'];
    active = json['active'];
    congTy = json['congTy'];
    chucVu = json['chucVu'];
    createDate = json['createDate'];
    createBy = json['createBy'];
    updateDate = json['updateDate'];
    updateBy = json['updateBy'];
    activeDate = json['activeDate'];
    activeBy = json['activeBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phongBanID'] = phongBanID;
    data['tenPhongBan'] = tenPhongBan;
    data['chiTiet'] = chiTiet;
    data['congTyID'] = congTyID;
    data['active'] = active;
    data['congTy'] = congTy;
    data['chucVu'] = chucVu;
    data['createDate'] = createDate;
    data['createBy'] = createBy;
    data['updateDate'] = updateDate;
    data['updateBy'] = updateBy;
    data['activeDate'] = activeDate;
    data['activeBy'] = activeBy;
    return data;
  }
}
