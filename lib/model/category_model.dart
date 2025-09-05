class CategoryModel {
  int? id;
  String? tenHangMuc;
  int? hangMucChiPhiID;

  CategoryModel({this.id, this.tenHangMuc, this.hangMucChiPhiID});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tenHangMuc = json['tenHangMuc'];
    hangMucChiPhiID = json['hangMucChiPhiID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tenHangMuc'] = tenHangMuc;
    data['hangMucChiPhiID'] = hangMucChiPhiID;
    return data;
  }
}
