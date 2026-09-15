import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sovchilar/src/data/favorite_users.dart';
import 'package:sovchilar/src/data/get_users.dart';

import '../../config/core/app_images.dart';
import '../../domain/repositories/auth_repo.dart';
import '../questionnaire_page/component/questionnaire_box.dart';

class SubscribedPage extends StatefulWidget {
  const SubscribedPage({super.key});

  @override
  State<SubscribedPage> createState() => _SubscribedPageState();
}

class _SubscribedPageState extends State<SubscribedPage> {
  List<Datas> data = [];
  List<String> favoriteUsersIdList = [];
  bool _loading = true;

  Future<void> getFavoriteUsersString() async {
    final AuthGetUserRepo repo =
        RepositoryProvider.of<AuthGetUserRepo>(context);
    final FavoriteUsers favoriteUsers = await repo.getFavoriteUsers();
    if (favoriteUsers.data != null) {
      for (Datas user in favoriteUsers.data!) {
        if (data.contains(user) != true) {
          user.favourite!.gender == 'MALE'
              ? user.favourite!.assetImage = getMaleRandomImages()
              : user.favourite!.assetImage = getFemaleRandomImages();
          data.add(user);
        }
      }
    }
    favoriteUsers.data?.forEach((value) {
      if (favoriteUsersIdList.contains(value.favourite!.id) != true) {
        favoriteUsersIdList.add(value.favourite!.id ?? "");
      }
    });
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    getFavoriteUsersString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthGetUserRepo repo =
        RepositoryProvider.of<AuthGetUserRepo>(context);
    return SafeArea(
      child: Scaffold(
        body: _loading
            ? Center(
                child: Platform.isIOS
                    ? CupertinoActivityIndicator() // iOS platformasida
                    : CircularProgressIndicator())
            : data.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: ListView.builder(
                      itemCount: data.length,
                      key: PageStorageKey<String>('my_list_view'),
                      itemBuilder: (BuildContext context, int index) {
                        Items user = Items(
                          id: data[index].favourite!.id,
                          firstName: data[index].favourite!.firstName,
                          imageUrl: data[index].favourite!.imageUrl,
                          maritalStatus: data[index].favourite!.maritalStatus,
                          address: data[index].favourite!.address,
                          age: data[index].favourite!.age,
                          nationality: data[index].favourite!.nationality,
                          qualification: data[index].favourite!.qualification,
                          description: data[index].favourite!.description,
                          gender: data[index].favourite!.gender,
                          assetImage: data[index].favourite!.assetImage,
                        );
                        return QuestionnaireBox(
                          user: user,
                          favorite: true,
                          onPressed: () async {
                            await repo.setFavorite(data[index].favourite!.id!);
                            if (favoriteUsersIdList
                                .contains(data[index].favourite!.id!)) {
                              favoriteUsersIdList
                                  .remove(data[index].favourite!.id!);
                              for(Datas user in data){
                                if(user.favourite?.id == data[index].favourite!.id!
                                ){
                                  data.remove(user);
                                  setState(() {
                                    data;
                                  });
                                }
                              }
                            }
                            getFavoriteUsersString();
                            setState(() {});
                          },
                          assetImage: user.assetImage!,
                        );
                      },
                    ),
                  )
                : SizedBox(),
      ),
    );
  }
}
