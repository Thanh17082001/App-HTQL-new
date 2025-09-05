class WorkingContentModel {
  int? id;
  String? noiDen;
  String? tenBuocThiTruong;
  String? chiTiet;
  String? ngayThucHien;
  String? ghiChu;
  int? coQuanID;
  int? ngayID;

  WorkingContentModel(
      {this.id,
      this.noiDen,
      this.tenBuocThiTruong,
      this.chiTiet,
      this.ngayThucHien,
      this.ghiChu,
      this.coQuanID,
      this.ngayID});

  WorkingContentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noiDen = json['noiDen'];
    tenBuocThiTruong = json['tenBuocThiTruong'];
    chiTiet = json['chiTiet'];
    ngayThucHien = json['ngayThucHien'];
    ghiChu = json['ghiChu'];
    coQuanID = json['coQuanID'];
    ngayID = json['ngayID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['noiDen'] = noiDen;
    data['tenBuocThiTruong'] = tenBuocThiTruong;
    data['chiTiet'] = chiTiet;
    data['ngayThucHien'] = ngayThucHien;
    data['ghiChu'] = ghiChu;
    data['coQuanID'] = coQuanID;
    data['ngayID'] = ngayID;
    return data;
  }
}
