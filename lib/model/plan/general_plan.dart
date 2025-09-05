class PlanDayModel {
  int? ngayID;
  String? tuNgay;
  String? denNgay;
  String? mucDich;
  int? tuanID;
  int? nguoiDuyetID;
  String? tenNguoiDuyet;
  int? khctCongTyID;
  String? khctTenCongTy;

  PlanDayModel(
      {this.ngayID,
      this.tuNgay,
      this.denNgay,
      this.mucDich,
      this.tuanID,
      this.nguoiDuyetID,
      this.khctTenCongTy,
      this.khctCongTyID,
      this.tenNguoiDuyet});

  PlanDayModel.fromJson(Map<String, dynamic> json) {
    ngayID = json['ngayID'];
    tuNgay = json['tuNgay'];
    denNgay = json['denNgay'];
    mucDich = json['mucDich'];
    tuanID = json['tuanID'];
    nguoiDuyetID = json['nguoiDuyetID'];
    tenNguoiDuyet = json['tenNguoiDuyet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ngayID'] = ngayID;
    data['tuNgay'] = tuNgay;
    data['denNgay'] = denNgay;
    data['mucDich'] = mucDich;
    data['tuanID'] = tuanID;
    data['nguoiDuyetID'] = nguoiDuyetID;
    data['tenNguoiDuyet'] = tenNguoiDuyet;
    return data;
  }
}
