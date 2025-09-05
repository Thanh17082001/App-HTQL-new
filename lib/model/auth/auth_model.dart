class AuthModel {
  final int? userID;
  final String? hoVaTen;
  final String? tenDangNhap;
  final String? matKhau;
  final String? token;
  AuthModel({this.userID, this.hoVaTen, this.matKhau, this.tenDangNhap, this.token});

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'hoVaTen': hoVaTen,
      'tenDangNhap': tenDangNhap,
      'matKhau': matKhau,
      'token': token
    };
  }

  static AuthModel fromJson(Map<String, dynamic> auth) {
    return AuthModel(
      userID: auth['userID'],
      hoVaTen: auth['hoVaTen'],
      matKhau: auth['matKhau'],
      tenDangNhap: auth['tenDangNhap'],
      token: auth['token'],
    );
  }
}
