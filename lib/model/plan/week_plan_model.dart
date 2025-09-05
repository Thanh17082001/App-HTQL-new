class WeekPlanModel {
  int? tuanID;
  String? tieuDe;
  String? noiDung;
  int? tuanThang;
  int? nam;
  int? thangID;
  int? nguoiDuyetID;
  String? nguoiDuyet;
  String? tuNgay;
  String? denNgay;

  WeekPlanModel(
      {this.tuanID,
      this.tieuDe,
      this.noiDung,
      this.tuanThang,
      this.nam,
      this.thangID,
      this.nguoiDuyetID,
      this.nguoiDuyet,
      this.tuNgay,
      this.denNgay});

  WeekPlanModel.fromJson(Map<String, dynamic> json) {
    tuanID = json['tuanID'];
    tieuDe = json['tieuDe'];
    noiDung = json['noiDung'];
    tuanThang = json['tuan_Thang'];
    nam = json['nam'];
    thangID = json['thangID'];
    nguoiDuyetID = json['nguoiDuyetID'];
    nguoiDuyet = json['nguoiDuyet'];
    tuNgay = json['tuNgay'];
    denNgay = json['denNgay'];
  }

  toJson() {}

}
