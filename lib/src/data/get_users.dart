class GetUsers {
  String? message;
  int? statusCode;
  Data? data;

  GetUsers({this.message, this.statusCode, this.data});

  GetUsers.fromJson(Map<String, dynamic> json) {
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
  List<Items>? items;
  int? total;

  Data({this.items, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Items {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? firstName;
  String? lastName;
  String? email;
  int? age;
  String? description;
  String? nationality;
  String? gender;
  String? refreshToken;
  String? refreshTokenExpires;
  String? jobTitle;
  String? qualification;
  String? address;
  String? phone;
  String? telegram;
  String? imageUrl;
  String? maritalStatus;
  String? status;
  String? password;
  bool? numerIsVisible;
  String? role;
  String? assetImage;

  Items(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.firstName,
        this.lastName,
        this.email,
        this.age,
        this.description,
        this.nationality,
        this.gender,
        this.refreshToken,
        this.refreshTokenExpires,
        this.jobTitle,
        this.qualification,
        this.address,
        this.phone,
        this.telegram,
        this.imageUrl,
        this.maritalStatus,
        this.status,
        this.password,
        this.numerIsVisible,
        this.role,
        this.assetImage
      });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    age = json['age'];
    description = json['description'];
    nationality = json['nationality'];
    gender = json['gender'];
    refreshToken = json['refreshToken'];
    refreshTokenExpires = json['refreshTokenExpires'];
    jobTitle = json['jobTitle'];
    qualification = json['qualification'];
    address = json['address'];
    phone = json['phone'];
    telegram = json['telegram'];
    imageUrl = json['imageUrl'];
    maritalStatus = json['maritalStatus'];
    status = json['status'];
    password = json['password'];
    numerIsVisible = json['numerIsVisible'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['age'] = this.age;
    data['description'] = this.description;
    data['nationality'] = this.nationality;
    data['gender'] = this.gender;
    data['refreshToken'] = this.refreshToken;
    data['refreshTokenExpires'] = this.refreshTokenExpires;
    data['jobTitle'] = this.jobTitle;
    data['qualification'] = this.qualification;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['telegram'] = this.telegram;
    data['imageUrl'] = this.imageUrl;
    data['maritalStatus'] = this.maritalStatus;
    data['status'] = this.status;
    data['password'] = this.password;
    data['numerIsVisible'] = this.numerIsVisible;
    data['role'] = this.role;
    return data;
  }
}
