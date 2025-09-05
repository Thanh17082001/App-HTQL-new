class TaskFileModel {
  int? fileID;
  String? fileName;
  String? fileType;
  String? fileUrl;
  int? loai;

  TaskFileModel(
      {this.fileID, this.fileName, this.fileType, this.fileUrl, this.loai});

  TaskFileModel.fromJson(Map<String, dynamic> json) {
    fileID = json['fileID'];
    fileName = json['fileName'];
    fileType = json['fileType'];
    fileUrl = json['fileUrl'];
    loai = json['loai'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileID'] = fileID;
    data['fileName'] = fileName;
    data['fileType'] = fileType;
    data['fileUrl'] = fileUrl;
    data['loai'] = loai;
    return data;
  }
}
