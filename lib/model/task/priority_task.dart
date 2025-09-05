class PriorityTaskModel {
  int? uuTienId;
  String? tenUuTien;

  PriorityTaskModel({this.uuTienId, this.tenUuTien});

  PriorityTaskModel.fromJson(Map<String, dynamic> json) {
    uuTienId = json['uuTienId'];
    tenUuTien = json['tenUuTien'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuTienId'] = this.uuTienId;
    data['tenUuTien'] = this.tenUuTien;
    return data;
  }
}
