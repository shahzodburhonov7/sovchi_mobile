class PaymentUrl {
  String? message;
  int? statusCode;
  Data? data;

  PaymentUrl({this.message, this.statusCode, this.data});

  PaymentUrl.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    if (this.data != null) {}
    return data;
  }
}

class Data {
  String? paymentUrl;

  Data({this.paymentUrl});

  Data.fromJson(Map<String, dynamic> json) {
    paymentUrl = json['paymentUrl'];
  }
}
