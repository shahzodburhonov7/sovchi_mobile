class CreateConversation {
  bool? isGroup;
  List<Participants>? participants;
  String? name;
  String? lastMessageText;
  String? lastMessageTime;
  String? id;
  String? createdAt;
  String? updatedAt;

  CreateConversation(
      {this.isGroup,
        this.participants,
        this.name,
        this.lastMessageText,
        this.lastMessageTime,
        this.id,
        this.createdAt,
        this.updatedAt});

  CreateConversation.fromJson(Map<String, dynamic> json) {
    isGroup = json['isGroup'];
    if (json['participants'] != null) {
      participants = <Participants>[];
      json['participants'].forEach((v) {
        participants!.add(new Participants.fromJson(v));
      });
    }
    name = json['name'];
    lastMessageText = json['lastMessageText'];
    lastMessageTime = json['lastMessageTime'];
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isGroup'] = this.isGroup;
    if (this.participants != null) {
      data['participants'] = this.participants!.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    data['lastMessageText'] = this.lastMessageText;
    data['lastMessageTime'] = this.lastMessageTime;
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Participants {
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

  Participants(
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
        this.role});

  Participants.fromJson(Map<String, dynamic> json) {
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
