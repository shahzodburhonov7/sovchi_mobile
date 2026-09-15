import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sovchilar/src/bloc/chat_bloc/chat_bloc.dart';
import 'package:sovchilar/src/screens/chats_page/components/chat_view/chat_view.dart';
import 'package:sovchilar/src/screens/chats_page/components/chats_box.dart';
import 'package:sovchilar/src/service/socket/socket.dart';

import '../../data/login_res.dart';
import '../../domain/network/dio_settings.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../service/shared_pref/my_shared_preferences.dart';
import 'components/search_text_field.dart';

class ChatsPage extends StatefulWidget with ChangeNotifier {
  ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  User? user;
  bool? ok;

  Future<void> getUser() async {
    String? data = await MySharedPreferences.instance.user;
    ok = await MySharedPreferences.instance.paymentOk;
    LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(data!));
    user = loginResponse.data!.user;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: SearchTextField(
            onChanged: (text) {
              context.read<ChatBloc>().add(SearchUsersEvent(text));
            },
          ),
        ),
        scrolledUnderElevation: 0,
      ),
      body: GestureDetector(
        onHorizontalDragCancel: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          child: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
            log('CHAT STATE: $state');

            log('$state');
            if (state is LoadingChatUserState) {
              return Center(
                  child: Platform.isIOS
                      ? CupertinoActivityIndicator() // iOS platformasida
                      : CircularProgressIndicator());
            }
            if (state is EmptyChatUserState) {
              return Center(child: Text("Suhbatlar yo'q"));
            }
            if (state is GetChatUserState) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return ChatsBox(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              MultiRepositoryProvider(
                            providers: [
                              RepositoryProvider(
                                create: (context) => DioSettings(),
                              ),
                              RepositoryProvider(
                                create: (context) => AuthGetUserRepo(
                                    dio: RepositoryProvider.of<DioSettings>(
                                            context)
                                        .dio),
                              ),
                            ],
                            child: ChatView(
                              consId: state.users[index].id!,
                              userName: state
                                  .users[index].participants![0].firstName!,
                              userId: state.users[index].participants![0].id!,
                            ),
                          ),
                        ),
                      );
                    },
                    name: state.users[index].participants![0].firstName!,
                    online: SocketService()
                        .checkOnline(state.users[index].participants![0].id!),
                    imageUrl: state.users[index].participants![0].imageUrl!,
                    lastMessage: state.users[index].lastMessageText,
                    unreadMessagesCount:
                        state.users[index].unreadMessagesCount!,
                  );
                },
                itemCount: state.users.length,
              );
            }
            return SizedBox();
          }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // context.read<ChatBloc>().close();
    super.dispose();
  }
}
