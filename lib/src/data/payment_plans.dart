class PaymentPlans {
  String? message;
  int? statusCode;
  List<Data>? data;

  PaymentPlans({this.message, this.statusCode, this.data});

  PaymentPlans.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? createdAt;
  String? updatedAt;
  Name? name;
  int? durationInDays;
  String? price;
  List<Name>? benefits;

  Data(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.durationInDays,
        this.price,
        this.benefits});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    durationInDays = json['durationInDays'];
    price = json['price'];
    if (json['benefits'] != null) {
      benefits = <Name>[];
      json['benefits'].forEach((v) {
        benefits!.add(new Name.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.name != null) {
      data['name'] = this.name!.toJson();
    }
    data['durationInDays'] = this.durationInDays;
    data['price'] = this.price;
    if (this.benefits != null) {
      data['benefits'] = this.benefits!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Name {
  String? ru;
  String? uz;

  Name({this.ru, this.uz});

  Name.fromJson(Map<String, dynamic> json) {
    ru = json['ru'];
    uz = json['uz'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ru'] = this.ru;
    data['uz'] = this.uz;
    return data;
  }
}
