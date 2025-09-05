class CostModel {
  int? id;
  int? soLuong;
  int? donGia;
  int? thanhTien;
  String? ghiChu;
  int? loaiChiPhiID;
  int? hangMucChiPhiID;
  String? hangMuc;
  Map<String, dynamic>? khcT_HangMucChiPhi;
  int? ngayID;

  CostModel(
      {this.id,
      this.soLuong,
      this.donGia,
      this.thanhTien,
      this.ghiChu,
      this.loaiChiPhiID,
      this.hangMucChiPhiID,
      this.hangMuc,
      this.khcT_HangMucChiPhi,
      this.ngayID});

  CostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    soLuong = json['soLuong'];
    donGia = json['donGia'];
    thanhTien = json['thanhTien'];
    ghiChu = json['ghiChu'];
    loaiChiPhiID = json['loaiChiPhiID'];
    hangMucChiPhiID = json['hangMucChiPhiID'];
    hangMuc = json['hangMuc'];
    khcT_HangMucChiPhi = json['khcT_HangMucChiPhi'];
    ngayID = json['ngayID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['soLuong'] = soLuong;
    data['donGia'] = donGia;
    data['thanhTien'] = thanhTien;
    data['ghiChu'] = ghiChu;
    data['loaiChiPhiID'] = loaiChiPhiID;
    data['hangMucChiPhiID'] = hangMucChiPhiID;
    data['hangMuc'] = hangMuc;
    data['ngayID'] = ngayID;
    return data;
  }
}
