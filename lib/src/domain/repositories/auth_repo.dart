import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:sovchilar/src/data/get_user.dart';
import 'package:sovchilar/src/data/get_users.dart';
import 'package:sovchilar/src/data/login_res.dart';
import 'package:sovchilar/src/data/payment_check.dart';
import 'package:sovchilar/src/data/payment_url.dart';
import 'package:sovchilar/src/service/shared_pref/my_shared_preferences.dart';

import '../../data/favorite_users.dart';
import '../../data/get_photo_date.dart';
import '../../data/payment_plans.dart';
import '../../data/profile_user.dart';

class AuthGetUserRepo {
  final Dio dio;
  String? lastErrorMessage;
  AuthGetUserRepo({required this.dio});

  Future<bool> logInRequest({
    required String phoneNumber,
    required String password,
  }) async {
    lastErrorMessage = null;

    try {
      final response = await dio.post(
        "/auth/login",
        data: {
          "phone": phoneNumber,
          "password": password,
        },
        options: Options(
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      debugPrint("LOGIN STATUS: ${response.statusCode}");
      debugPrint("LOGIN RESPONSE: ${response.data}");

      // =========================
      // SUCCESS
      // =========================

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        try {
          LoginResponse.fromJson(response.data);

          await MySharedPreferences.instance.saveUser(
            jsonEncode(response.data),
          );

          return true;
        } catch (e) {
          debugPrint("LOGIN PARSE ERROR: $e");

          lastErrorMessage =
          "Login ma'lumotlarini o'qib bo'lmadi";

          return false;
        }
      }

      // =========================
      // ERROR FROM BACKEND
      // =========================

      if (response.data is Map) {
        lastErrorMessage =
            response.data['message']?.toString();
      }

      lastErrorMessage ??= "Raqam yoki parol xato";

      debugPrint(
        "LOGIN ERROR: $lastErrorMessage",
      );

      return false;
    } catch (e) {
      debugPrint("LOGIN REQUEST ERROR: $e");

      lastErrorMessage =
      "Server bilan bog'lanishda xatolik yuz berdi";

      return false;
    }
  }

  Future<void> refreshToken() async {
    String? data = await MySharedPreferences.instance.user;
    LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(data!));
    final response = await dio.post(
      "/auth/refresh",
      data: {"refreshToken": loginResponse.data?.tokens?.refreshToken ?? ""},
      options: Options(
        validateStatus: (status) => status! < 500,
      ),
    );

    updateUser(updateUser: loginResponse.data!.user!);

    var a = await MySharedPreferences.instance.user;
    LoginResponse res = LoginResponse.fromJson(jsonDecode(a!));

    log("user111:${res.data?.tokens?.accessToken}");
  }

  Future<void> regWithEmail({required String email}) async {
    final response = await dio.post("/auth/send-mail", data: {"email": email});
  }

  Future<bool> verifyEmailWithCode(
      {required String email, required String code}) async {
    final response = await dio.post("/auth/verify-email",
        data: {"code": int.parse(code), "email": email});
    return response.data.toString().contains('200');
  }

  Future<bool> regWithPhone({required String phone}) async {
    final response = await dio.post("/auth/send-sms", data: {"phone": phone});
    return response.data.toString().contains('200');
  }

  Future<bool> verifyPhoneWithCode(
      {required String phone, required String code}) async {
    final response = await dio
        .post("/auth/verify-code", data: {"code": code, "phone": phone});
    return response.data.toString().contains('200');
  }
  Future<bool> isPhoneRegistered({
    required String phone,
  }) async {
    try {
      final response = await dio.get(
        "/users-uz/phone/$phone",
        options: Options(
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      debugPrint(
        "CHECK PHONE STATUS: ${response.statusCode}",
      );

      debugPrint(
        "CHECK PHONE RESPONSE: ${response.data}",
      );

      // 200 => user mavjud
      if (response.statusCode == 200) {
        return true;
      }

      // 404 => user mavjud emas
      if (response.statusCode == 404) {
        return false;
      }

      return false;
    } catch (e) {
      debugPrint(
        "CHECK PHONE ERROR: $e",
      );

      return false;
    }
  }


  Future<LoginResponse?> createUser(
      {required String firstName,
      required String password,
      required String gender,
      String? phone,
      String? email}) async {
    final response = await dio.post("/users-uz",
        data: phone != null
            ? {
                "firstName": firstName,
                "password": password,
                "gender": gender,
                "phone": phone
              }
            : {
                "firstName": firstName,
                "password": password,
                "gender": gender,
                "email": email
              });

    try {
      LoginResponse loginResponse = LoginResponse.fromJson(response.data);
      MySharedPreferences.instance.saveUser(jsonEncode(response.data));
      return loginResponse;
    } catch (e) {
      return null;
    }
  }

  Future<LoginResponse?> register({
    required String phone,
    required String verificationToken,
    required String firstName,
    required String lastName,
    required String password,
    required String gender,
  }) async {
    final response = await dio.post(
      "/auth/register",
      data: {
        "phone": phone,
        "verificationToken": verificationToken,
        "firstName": firstName,
        "lastName": lastName,
        "password": password,
        "gender": gender,
      },
    );

    try {
      final LoginResponse loginResponse =
      LoginResponse.fromJson(response.data);

      await MySharedPreferences.instance.saveUser(
        jsonEncode(response.data),
      );

      return loginResponse;
    } catch (e) {
      debugPrint("register error: $e");
      return null;
    }
  }



  Future<bool> forgetPass({String? phone, String? email}) async {
    final response = await dio.post("/auth/forgot-password",
        data: phone != null ? {"phone": '+998880341002'} : {"email": email});
    return response.data.toString().contains('200');
  }

  Future<GetUser?> findByEmail({String? email}) async {
    final response = await dio.get("/users-uz/find-by-email/$email");
    try {
      return GetUser.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<bool> findByEmailAuth({String? email}) async {
    final response = await dio.get(
      "/users-uz/find-by-email/$email",
      options: Options(
        validateStatus: (status) =>
            status! < 500, // 401 xatolikni qo'l bilan boshqaramiz
      ),
    );
    return response.data.toString().contains('404');
  }

  Future<bool> findByNumberAuth({String? phone}) async {
    final response = await dio.get(
      "/users-uz/phone/$phone",
      options: Options(
        validateStatus: (status) =>
            status! < 500, // 401 xatolikni qo'l bilan boshqaramiz
      ),
    );
    return response.data.toString().contains('404');
  }

  Future<GetUser?> findByPhone({String? phone}) async {
    final response = await dio.get(
      "/users-uz/phone/$phone",
    );
    try {
      return GetUser.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<bool> newPass({required String id, required String newPass}) async {
    final response = await dio
        .put("/users-uz/update-password/$id", data: {"password": newPass});
    return response.data.toString().contains('200');
  }

  Future<bool> delImage({required String imageUrl}) async {
    User? user;

    String? data = await MySharedPreferences.instance.user;
    LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(data!));
    user = loginResponse.data!.user;
    final response = await dio.post("/file/remove-by-url",
        data: {"imageUrl": imageUrl},
        options: Options(headers: {
          "Authorization": "Bearer ${loginResponse.data!.tokens!.accessToken}"
        }));
    return response.data.toString().contains('200');
  }

  Future<FavoriteUsers> getFavoriteUsers() async {
    User? user;

    String? data = await MySharedPreferences.instance.user;
    LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(data!));
    user = loginResponse.data!.user;

    final response = await dio.get("/user-favourite/user/${user!.id}",
        options: Options(headers: {
          "Authorization": "Bearer ${loginResponse.data!.tokens!.accessToken}"
        }));
    return FavoriteUsers.fromJson(response.data);
  }

  Future<GetUsers?> getUsers({
    String? gender,
    int ageFrom = 18,
    int ageTo = 30,
    String? address,
    String? maritalStatus,
    int page = 1,
  }) async {
    Map<String, dynamic> queryParameters = {
      if (gender != null) 'gender': gender,
      'ageFrom': ageFrom.toString(),
      'ageTo': ageTo.toString(),
      if (address != null) 'address': address,
      if (maritalStatus != null) 'maritalStatus': maritalStatus,
      if (maritalStatus != null) 'maritalStatus': maritalStatus,
      'limit': '10',
      'page': page.toString(),
    };

    final response = await dio.get(
      "/users-uz",
      queryParameters: queryParameters,
    );
    final GetUsers getUsers = GetUsers.fromJson(response.data);
    return getUsers;
  }
  Future<bool> resetPassword({
    required String phone,
    required String verificationToken,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        "/auth/reset-password",
        data: {
          "phone": phone,
          "verificationToken": verificationToken,
          "password": password,
        },
        options: Options(
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      debugPrint("RESET PASSWORD STATUS: ${response.statusCode}");
      debugPrint("RESET PASSWORD RESPONSE: ${response.data}");

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
      debugPrint("RESET PASSWORD ERROR: $e");
      return false;
    }
  }



  Future<void> setFavorite(String id) async {
    User? user;

    String? data = await MySharedPreferences.instance.user;
    LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(data!));
    user = loginResponse.data!.user;

    final response = await dio.post("/user-favourite",
        options: Options(
          headers: {
            "Authorization": "Bearer ${loginResponse.data!.tokens!.accessToken}"
          },
        ),
        data: {'user': user!.id!, 'favourite': id});
  }

  Future<void> paymentCheck() async {
    User? user;

    String? data = await MySharedPreferences.instance.user;
    LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(data!));
    user = loginResponse.data!.user;

    final response = await dio.get(
      "/subscription/user/${user!.id!}",
      options: Options(
        headers: {
          "Authorization": "Bearer ${loginResponse.data!.tokens!.accessToken}"
        },
      ),
    );

    PaymentCheck paymentCheck = PaymentCheck.fromJson(response.data);
    MySharedPreferences.instance.payment(jsonEncode(response.data));
    MySharedPreferences.instance
        .paymentActive(paymentCheck.data?.isActive ?? false);
  }

  Future<UserProfile?> getUserProfile(String id) async {
    final response = await dio.get(
      "/users-uz/$id",
    );
    UserProfile userProfile = UserProfile.fromJson(response.data);
    return userProfile;
  }

  Future<PaymentPlans?> getPaymentPlans() async {
    final response = await dio.get(
      "/subscription-plan",
    );
    PaymentPlans paymentPlans = PaymentPlans.fromJson(response.data);
    return paymentPlans;
  }

  Future<PaymentUrl?> paymentUrl({required String planId}) async {
    User? user;

    String? data = await MySharedPreferences.instance.user;
    LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(data!));
    user = loginResponse.data!.user;
    final response = await dio.post("/subscription",
        options: Options(
          headers: {
            "Authorization": "Bearer ${loginResponse.data!.tokens!.accessToken}"
          },
        ),
        data: {"userId": user!.id, "planId": planId});
    PaymentUrl paymentUrl = PaymentUrl.fromJson(response.data);
    return paymentUrl;
  }

  Future<PhotoData?> postPhoto(File image) async {
    User? user;

    String? data = await MySharedPreferences.instance.user;
    LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(data!));
    user = loginResponse.data!.user;

    String fileName = image.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        image.path,
        filename: fileName,
        contentType: MediaType("image", "png"), // MIME turini ko‘rsatish
      ),
    });
    final response = await dio.post("/file/upload",
        options: Options(
          headers: {
            "Authorization":
                "Bearer ${loginResponse.data!.tokens!.accessToken}",
            'accept': '*/*',
            'Content-Type': 'multipart/form-data'
          },
        ),
        data: formData);

    PhotoData photoData = PhotoData.fromJson(response.data);
    return photoData;
  }

  Future<bool> updateUser({required User updateUser}) async {
    User? user;

    String? data = await MySharedPreferences.instance.user;
    LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(data!));
    user = loginResponse.data!.user;
    final response = await dio.put("/users-uz/register/${user!.id}",
        options: Options(
          headers: {
            "Authorization":
                "Bearer ${loginResponse.data!.tokens!.accessToken}",
          },
        ),
        data: updateUser.toJson());
    try {
      LoginResponse loginResponse = LoginResponse.fromJson(response.data);
      MySharedPreferences.instance.saveUser(jsonEncode(response.data));
      return response.toString().contains('200');
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateImageUrl() async {
    User? user;

    String? data = await MySharedPreferences.instance.user;
    LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(data!));
    user = loginResponse.data!.user;
    final response = await dio.put("/users-uz/register/${user!.id}",
        options: Options(
          headers: {
            "Authorization":
                "Bearer ${loginResponse.data!.tokens!.accessToken}",
          },
        ),
        data: {'imageUrl': ""});
    try {
      LoginResponse loginResponse = LoginResponse.fromJson(response.data);
      MySharedPreferences.instance.saveUser(jsonEncode(response.data));
      return response.toString().contains('200');
    } catch (e) {
      return false;
    }
  }

  Future<bool> numberIsVisible({required bool numberIsVisible}) async {
    User? user;

    String? data = await MySharedPreferences.instance.user;
    LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(data!));
    user = loginResponse.data!.user;
    final response = await dio.put("/users-uz/register/${user!.id}",
        options: Options(
          headers: {
            "Authorization":
                "Bearer ${loginResponse.data!.tokens!.accessToken}",
          },
        ),
        data: {'numerIsVisible': numberIsVisible});
    try {
      LoginResponse loginResponse = LoginResponse.fromJson(response.data);
      MySharedPreferences.instance.saveUser(jsonEncode(response.data));
      return response.toString().contains('200');
    } catch (e) {
      return false;
    }
  }

  Future<bool> statusChange({required String statusChange}) async {
    User? user;

    String? data = await MySharedPreferences.instance.user;
    LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(data!));
    user = loginResponse.data!.user;
    final response = await dio.put("/users-uz/register/${user!.id}",
        options: Options(
          headers: {
            "Authorization":
                "Bearer ${loginResponse.data!.tokens!.accessToken}",
          },
        ),
        data: {'status': statusChange});
    try {
      LoginResponse loginResponse = LoginResponse.fromJson(response.data);
      MySharedPreferences.instance.saveUser(jsonEncode(response.data));
      return response.toString().contains('200');
    } catch (e) {
      return false;
    }
  }
  Future<Map<String, dynamic>> verifyStart({
    required String phone,
  }) async {
    final response = await dio.post(
      "/verify/start",
      data: {
        "phone": phone,
      },
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    if (response.data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(response.data);
    }

    throw Exception("Verification session yaratilmadi");
  }

  Future<Map<String, dynamic>> verifyStatus({
    required String sessionId,
  }) async {
    final response = await dio.get(
      "/verify/status/$sessionId",
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    if (response.data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(response.data);
    }

    throw Exception("Verification status olinmadi");
  }

}
