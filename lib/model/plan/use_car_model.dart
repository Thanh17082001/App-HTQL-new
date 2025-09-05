class UseCarModel {
  int? id;
  String? noiDi;
  String? noiDen;
  int? kmTamTinh;
  String? ngaySuDung;
  String? ghiChu;
  int? ngayID;

  UseCarModel(
      {this.id,
      this.noiDi,
      this.noiDen,
      this.kmTamTinh,
      this.ngaySuDung,
      this.ghiChu,
      this.ngayID});

  UseCarModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noiDi = json['noiDi'];
    noiDen = json['noiDen'];
    kmTamTinh = json['kmTamTinh'];
    ngaySuDung = json['ngaySuDung'];
    ghiChu = json['ghiChu'];
    ngayID = json['ngayID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['noiDi'] = noiDi;
    data['noiDen'] = noiDen;
    data['kmTamTinh'] = kmTamTinh;
    data['ngaySuDung'] = ngaySuDung;
    data['ghiChu'] = ghiChu;
    data['ngayID'] = ngayID;
    return data;
  }
}
