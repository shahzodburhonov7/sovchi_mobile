class UpdateUser {
  String? firstName;
  String? lastName;
  int? age;
  String? description;
  String? nationality;
  String? status;
  String? gender;
  String? jobTitle;
  String? qualification;
  String? address;
  String? phone;
  String? telegram;
  String? imageUrl;
  String? maritalStatus;
  String? password;
  String? email;
  String? role;
  String? refreshToken;
  String? refreshTokenExpires;

  UpdateUser(
      {this.firstName,
        this.lastName,
        this.age,
        this.description,
        this.nationality,
        this.status,
        this.gender,
        this.jobTitle,
        this.qualification,
        this.address,
        this.phone,
        this.telegram,
        this.imageUrl,
        this.maritalStatus,
        this.password,
        this.email,
        this.role,
        this.refreshToken,
        this.refreshTokenExpires});

  UpdateUser.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    age = json['age'];
    description = json['description'];
    nationality = json['nationality'];
    status = json['status'];
    gender = json['gender'];
    jobTitle = json['jobTitle'];
    qualification = json['qualification'];
    address = json['address'];
    phone = json['phone'];
    telegram = json['telegram'];
    imageUrl = json['imageUrl'];
    maritalStatus = json['maritalStatus'];
    password = json['password'];
    email = json['email'];
    role = json['role'];
    refreshToken = json['refreshToken'];
    refreshTokenExpires = json['refreshTokenExpires'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['age'] = this.age;
    data['description'] = this.description;
    data['nationality'] = this.nationality;
    data['status'] = this.status;
    data['gender'] = this.gender;
    data['jobTitle'] = this.jobTitle;
    data['qualification'] = this.qualification;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['telegram'] = this.telegram;
    data['imageUrl'] = this.imageUrl;
    data['maritalStatus'] = this.maritalStatus;
    data['password'] = this.password;
    data['email'] = this.email;
    data['role'] = this.role;
    data['refreshToken'] = this.refreshToken;
    data['refreshTokenExpires'] = this.refreshTokenExpires;
    return data;
  }
}
