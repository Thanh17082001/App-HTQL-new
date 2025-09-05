class StatusPlanModel {
  int? trangThaiID;
  String? tenTrangThai;

  StatusPlanModel({this.trangThaiID, this.tenTrangThai});

  StatusPlanModel.fromJson(Map<String, dynamic> json) {
    trangThaiID = json['trangThaiID'];
    tenTrangThai = json['tenTrangThai'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trangThaiID'] = this.trangThaiID;
    data['tenTrangThai'] = this.tenTrangThai;
    return data;
  }
}
