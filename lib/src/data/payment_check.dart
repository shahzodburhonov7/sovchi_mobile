class PaymentCheck {
  String? message;
  int? statusCode;
  Data? data;

  PaymentCheck({this.message, this.statusCode, this.data});

  PaymentCheck.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? startDate;
  String? endDate;
  bool? isActive;
  Plan? plan;

  Data(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.startDate,
        this.endDate,
        this.isActive,
        this.plan});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    isActive = json['isActive'];
    plan = json['plan'] != null ? new Plan.fromJson(json['plan']) : null;
  }
}

class Plan {
  String? id;
  String? createdAt;
  String? updatedAt;
  Name? name;
  int? durationInDays;
  String? price;
  List<Name>? benefits;

  Plan(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.durationInDays,
        this.price,
        this.benefits});

  Plan.fromJson(Map<String, dynamic> json) {
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
