
class LocationModel {
  final int? viTriID;
  final int? nhanVienID;
  final double? viDo;
  final double? kinhDo;
  final String? diaChi;
  late  String? thoiGian;
  LocationModel(
      {this.viTriID,this.nhanVienID, this.viDo, this.thoiGian, this.diaChi, this.kinhDo});

  Map<String, dynamic> toJson() {
    return {
      'viTriID': viTriID,
      'nhanVienID': nhanVienID,
      'viDo': viDo,
      'kinhDo': kinhDo,
      'diaChi': diaChi,
      'thoiGian': thoiGian
    };
  }

  static LocationModel fromJson(Map<String, dynamic> auth) {
    return LocationModel(
      viTriID: auth['viTriID'],
      nhanVienID: auth['nhanVienID'],
      viDo: auth['viDo'],
      diaChi: auth['diaChi'],
      thoiGian: auth['thoiGian'],
      kinhDo: auth['kinhDo'],
    );
  }
}
