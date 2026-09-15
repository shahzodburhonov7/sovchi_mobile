class PhotoData {
  String? message;
  int? statusCode;
  Data? data;

  PhotoData({this.message, this.statusCode, this.data});

  PhotoData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? mimetype;
  String? originalname;
  int? size;
  String? path;
  String? id;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.mimetype,
        this.originalname,
        this.size,
        this.path,
        this.id,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    mimetype = json['mimetype'];
    originalname = json['originalname'];
    size = json['size'];
    path = json['path'];
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mimetype'] = this.mimetype;
    data['originalname'] = this.originalname;
    data['size'] = this.size;
    data['path'] = this.path;
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
