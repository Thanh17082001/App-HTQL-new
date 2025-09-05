class OrganModel {
  int? coQuanID;
  String? tenCoQuan;
  String? maSoThue;
  int? tinhID;
  int? huyenID;
  int? xaID;
  String? huyen;
  String? diaChi;
  bool? active;
  List<dynamic>? nsCanBo;
  String? tuongTac;
  int? nhanVienID;
  String? nhanVien;
  String? nsDuToan;
  String? createDate;
  String? createBy;
  String? updateDate;
  String? updateBy;
  String? activeDate;
  String? activeBy;

  OrganModel(
      {this.coQuanID,
      this.tenCoQuan,
      this.maSoThue,
      this.tinhID,
      this.huyenID,
      this.xaID,
      this.huyen,
      this.diaChi,
      this.active,
      this.nsCanBo,
      this.tuongTac,
      this.nhanVienID,
      this.nhanVien,
      this.nsDuToan,
      this.createDate,
      this.createBy,
      this.updateDate,
      this.updateBy,
      this.activeDate,
      this.activeBy});

  OrganModel.fromJson(Map<String, dynamic> json) {
    coQuanID = json['coQuanID'];
    tenCoQuan = json['tenCoQuan'];
    maSoThue = json['maSoThue'];
    tinhID = json['tinhID'];
    huyenID = json['huyenID'];
    xaID = json['xaID'];
    huyen = json['huyen'];
    diaChi = json['diaChi'];
    active = json['active'];
    nsCanBo = json['nsCanBo'];
    tuongTac = json['tuongTac'];
    nhanVienID = json['nhanVienID'];
    nhanVien = json['nhanVien'];
    nsDuToan = json['nsDuToan'];
    createDate = json['createDate'];
    createBy = json['createBy'];
    updateDate = json['updateDate'];
    updateBy = json['updateBy'];
    activeDate = json['activeDate'];
    activeBy = json['activeBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coQuanID'] = coQuanID;
    data['tenCoQuan'] = tenCoQuan;
    data['maSoThue'] = maSoThue;
    data['tinhID'] = tinhID;
    data['huyenID'] = huyenID;
    data['xaID'] = xaID;
    data['huyen'] = huyen;
    data['diaChi'] = diaChi;
    data['active'] = active;
    data['nsCanBo'] = nsCanBo;
    data['tuongTac'] = tuongTac;
    data['nhanVienID'] = nhanVienID;
    data['nhanVien'] = nhanVien;
    data['nsDuToan'] = nsDuToan;
    data['createDate'] = createDate;
    data['createBy'] = createBy;
    data['updateDate'] = updateDate;
    data['updateBy'] = updateBy;
    data['activeDate'] = activeDate;
    data['activeBy'] = activeBy;
    return data;
  }
}
