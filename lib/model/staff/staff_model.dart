class StaffModel{
  final int? nhanVienID;
  final String? tenNhanVien;
  final String? soDienThoai;
  final String? email;

  StaffModel({this.nhanVienID, this.tenNhanVien,this.soDienThoai, this.email});

  Map<String, dynamic> toJson() {
    return {
      'nhanVienID': nhanVienID,
      'tenNhanVien': tenNhanVien,
      'soDienThoai': soDienThoai,
      'email': email,
    };
  }

  static StaffModel fromJson(Map<String, dynamic> auth) {
    return StaffModel(
      nhanVienID: auth['nhanVienID'],
      tenNhanVien: auth['tenNhanVien'],
      soDienThoai: auth['soDienThoai'],
      email: auth['email'],
    );
  }
}