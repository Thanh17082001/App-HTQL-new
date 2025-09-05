class WeekModel {
  int? tuanID;
  String? tieuDe;
  String? noiDung;
  bool? active;
  int? thangID;
  int? tuanThang;
  int? tuanNam;
  int? nam;
  String? tuNgay;
  String? denNgay;
  bool? isApprove;
  int? nguoiTaoID;
  int? nguoiDuyetID;
  String? nguoiDuyet;
  String? khcTThang;
  String? khcTNgay;
  String? createDate;
  String? createBy;
  String? updateDate;
  String? updateBy;
  String? activeDate;
  String? activeBy;

  WeekModel(
      {this.tuanID,
      this.tieuDe,
      this.noiDung,
      this.active,
      this.thangID,
      this.tuanThang,
      this.tuanNam,
      this.nam,
      this.tuNgay,
      this.denNgay,
      this.isApprove,
      this.nguoiTaoID,
      this.nguoiDuyetID,
      this.nguoiDuyet,
      this.khcTThang,
      this.khcTNgay,
      this.createDate,
      this.createBy,
      this.updateDate,
      this.updateBy,
      this.activeDate,
      this.activeBy});

  WeekModel.fromJson(Map<String, dynamic> json) {
    tuanID = json['tuanID'];
    tieuDe = json['tieuDe'];
    noiDung = json['noiDung'];
    active = json['active'];
    thangID = json['thangID'];
    tuanThang = json['tuan_Thang'];
    tuanNam = json['tuan_Nam'];
    nam = json['nam'];
    tuNgay = json['tuNgay'];
    denNgay = json['denNgay'];
    isApprove = json['isApprove'];
    nguoiTaoID = json['nguoiTaoID'];
    nguoiDuyetID = json['nguoiDuyetID'];
    nguoiDuyet = json['nguoiDuyet'];
    khcTThang = json['khcT_Thang'];
    khcTNgay = json['khcT_Ngay'];
    createDate = json['createDate'];
    createBy = json['createBy'];
    updateDate = json['updateDate'];
    updateBy = json['updateBy'];
    activeDate = json['activeDate'];
    activeBy = json['activeBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tuanID'] = tuanID;
    data['tieuDe'] = tieuDe;
    data['noiDung'] = noiDung;
    data['active'] = active;
    data['thangID'] = thangID;
    data['tuan_Thang'] = tuanThang;
    data['tuan_Nam'] = tuanNam;
    data['nam'] = nam;
    data['tuNgay'] = tuNgay;
    data['denNgay'] = denNgay;
    data['isApprove'] = isApprove;
    data['nguoiTaoID'] = nguoiTaoID;
    data['nguoiDuyetID'] = nguoiDuyetID;
    data['nguoiDuyet'] = nguoiDuyet;
    data['khcT_Thang'] = khcTThang;
    data['khcT_Ngay'] = khcTNgay;
    data['createDate'] = createDate;
    data['createBy'] = createBy;
    data['updateDate'] = updateDate;
    data['updateBy'] = updateBy;
    data['activeDate'] = activeDate;
    data['activeBy'] = activeBy;
    return data;
  }
}
