class GroupTask {
  int? nhomCongViecID;
  String? tenNhomCongViec;
  String? mota;
  String? congViec;
  bool? active;
  String? createDate;
  String? createBy;
  String? updateDate;
  String? updateBy;
  String? activeDate;
  String? activeBy;

  GroupTask(
      {this.nhomCongViecID,
      this.tenNhomCongViec,
      this.mota,
      this.congViec,
      this.active,
      this.createDate,
      this.createBy,
      this.updateDate,
      this.updateBy,
      this.activeDate,
      this.activeBy});

  GroupTask.fromJson(Map<String, dynamic> json) {
    nhomCongViecID = json['nhomCongViecID'];
    tenNhomCongViec = json['tenNhomCongViec'];
    mota = json['mota'];
    congViec = json['congViec'];
    active = json['active'];
    createDate = json['createDate'];
    createBy = json['createBy'];
    updateDate = json['updateDate'];
    updateBy = json['updateBy'];
    activeDate = json['activeDate'];
    activeBy = json['activeBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nhomCongViecID'] = this.nhomCongViecID;
    data['tenNhomCongViec'] = this.tenNhomCongViec;
    data['mota'] = this.mota;
    data['congViec'] = this.congViec;
    data['active'] = this.active;
    data['createDate'] = this.createDate;
    data['createBy'] = this.createBy;
    data['updateDate'] = this.updateDate;
    data['updateBy'] = this.updateBy;
    data['activeDate'] = this.activeDate;
    data['activeBy'] = this.activeBy;
    return data;
  }
}
