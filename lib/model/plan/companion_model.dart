class CompanionModel {
  int? id;
  int? nhanVienID;
  String? tenNhanVien;
  String? tenChuVu;
  String? tenPhongBan;
  String? tenCongTy;
  int? ngayID;

  CompanionModel(
      {this.id,
      this.nhanVienID,
      this.tenNhanVien,
      this.tenChuVu,
      this.tenPhongBan,
      this.tenCongTy,
      this.ngayID});

  CompanionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nhanVienID = json['nhanVienID'];
    tenNhanVien = json['tenNhanVien'];
    tenChuVu = json['tenChuVu'];
    tenPhongBan = json['tenPhongBan'];
    tenCongTy = json['tenCongTy'];
    ngayID = json['ngayID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['nhanVienID'] = nhanVienID;
    data['tenNhanVien'] = tenNhanVien;
    data['tenChuVu'] = tenChuVu;
    data['tenPhongBan'] = tenPhongBan;
    data['tenCongTy'] = tenCongTy;
    data['ngayID'] = ngayID;
    return data;
  }
}
