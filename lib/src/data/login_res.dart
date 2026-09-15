class LoginResponse {
  LoginResponse({
    this.message,
    this.statusCode,
    this.data,
  });

  String? message;
  int? statusCode;
  Data? data;

  LoginResponse copyWith({
    String? message,
    int? statusCode,
    Data? data,
  }) {
    return LoginResponse(
      message: message ?? this.message,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
    );
  }

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json["message"],
      statusCode: json["statusCode"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "statusCode": statusCode,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.user,
    this.tokens,
  });

  User? user;
  Tokens? tokens;

  Data copyWith({
    User? user,
    Tokens? tokens,
  }) {
    return Data(
      user: user ?? this.user,
      tokens: tokens ?? this.tokens,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      tokens: json["tokens"] == null ? null : Tokens.fromJson(json["tokens"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "tokens": tokens?.toJson(),
      };
}

class Tokens {
  Tokens({
    this.accessToken,
    this.refreshToken,
  });

  String? accessToken;
  String? refreshToken;

  Tokens copyWith({
    String? accessToken,
    String? refreshToken,
  }) {
    return Tokens(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  factory Tokens.fromJson(Map<String, dynamic> json) {
    return Tokens(
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
    );
  }

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      };
}

class User {
  User({
    this.id,
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
  });

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

  User copyWith({
    String? id,
    String? createdAt,
    String? updatedAt,
    String? firstName,
    String? lastName,
    String? email,
    int? age,
    String? description,
    String? nationality,
    String? gender,
    String? refreshToken,
    String? refreshTokenExpires,
    String? jobTitle,
    String? qualification,
    String? address,
    String? phone,
    String? telegram,
    String? imageUrl,
    String? maritalStatus,
    String? status,
    bool? numerIsVisible,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      age: age ?? this.age,
      description: description ?? this.description,
      nationality: nationality ?? this.nationality,
      gender: gender ?? this.gender,
      refreshToken: refreshToken ?? this.refreshToken,
      refreshTokenExpires: refreshTokenExpires ?? this.refreshTokenExpires,
      jobTitle: jobTitle ?? this.jobTitle,
      qualification: qualification ?? this.qualification,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      telegram: telegram ?? this.telegram,
      imageUrl: imageUrl ?? this.imageUrl,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      status: status ?? this.status,
      numerIsVisible: numerIsVisible ?? this.numerIsVisible,
      role: role ?? this.role,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      age: json["age"],
      description: json["description"],
      nationality: json["nationality"],
      gender: json["gender"],
      refreshToken: json["refreshToken"],
      refreshTokenExpires: json["refreshTokenExpires"],
      jobTitle: json["jobTitle"],
      qualification: json["qualification"],
      address: json["address"],
      phone: json["phone"],
      telegram: json["telegram"],
      imageUrl: json["imageUrl"],
      maritalStatus: json["maritalStatus"],
      status: json["status"],
      numerIsVisible: json["numerIsVisible"],
      role: json["role"],
    );
  }

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "age": age,
        "description": description,
        "nationality": nationality,
        "gender": gender,
        "jobTitle": jobTitle,
        "qualification": qualification,
        "address": address,
        "telegram": telegram,
        "imageUrl": imageUrl,
        "maritalStatus": maritalStatus,
        "status":"ACTIVE"
      };
}
