class GetConversations {
  String? status;
  Data? data;

  GetConversations({this.status, this.data});

  GetConversations.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
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
  String? name;
  bool? isGroup;
  List<Participants>? participants;
  List<Messages>? messages;
  String? lastMessageText;
  String? lastMessageTime;
  int? unreadMessagesCount;
  String? createdAt;
  String? updatedAt;


  Items(
      {this.id,
        this.name,
        this.isGroup,
        this.participants,
        this.messages,
        this.lastMessageText,
        this.lastMessageTime,
        this.unreadMessagesCount,
        this.createdAt,
        this.updatedAt});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isGroup = json['isGroup'];
    if (json['participants'] != null) {
      participants = <Participants>[];
      json['participants'].forEach((v) {
        participants!.add(new Participants.fromJson(v));
      });
    }
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
    lastMessageText = json['lastMessageText'];
    lastMessageTime = json['lastMessageTime'];
    unreadMessagesCount = json['unreadMessagesCount'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isGroup'] = this.isGroup;
    if (this.participants != null) {
      data['participants'] = this.participants!.map((v) => v.toJson()).toList();
    }
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    data['lastMessageText'] = this.lastMessageText;
    data['lastMessageTime'] = this.lastMessageTime;
    data['unreadMessagesCount'] = this.unreadMessagesCount;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Participants {
  String? id;
  String? firstName;
  String? lastName;
  String? imageUrl;
  String? email;
  int? age;
  String? description;
  String? nationality;
  bool? online;

  Participants(
      {this.id,
        this.firstName,
        this.lastName,
        this.imageUrl,
        this.email,
        this.age,
        this.description,
        this.nationality,this.online});

  void setOnline (bool onlineCheck) => online = onlineCheck;

  Participants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    imageUrl = json['imageUrl'];
    email = json['email'];
    age = json['age'];
    description = json['description'];
    nationality = json['nationality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['imageUrl'] = this.imageUrl;
    data['email'] = this.email;
    data['age'] = this.age;
    data['description'] = this.description;
    data['nationality'] = this.nationality;
    return data;
  }
}

class Messages {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? message;
  bool? isRead;
  Sender? sender;

  Messages(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.message,
        this.isRead,
        this.sender});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    message = json['message'];
    isRead = json['isRead'];
    sender =
    json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['message'] = this.message;
    data['isRead'] = this.isRead;
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    return data;
  }
}

class Sender {
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

  Sender(
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

  Sender.fromJson(Map<String, dynamic> json) {
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
