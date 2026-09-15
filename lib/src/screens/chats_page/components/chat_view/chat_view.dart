import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sovchilar/src/bloc/chat_view_bloc/chat_view_bloc.dart';
import 'package:sovchilar/src/config/core/app_images.dart';
import 'package:sovchilar/src/screens/chats_page/components/chat_view/components/chat_bubble.dart';
import 'package:sovchilar/src/screens/chats_page/components/chat_view/components/chat_send_button.dart';
import 'package:sovchilar/src/service/socket/socket.dart';

import '../../../../data/login_res.dart';
import '../../../../data/profile_user.dart';
import '../../../../domain/network/dio_settings.dart';
import '../../../../domain/repositories/auth_repo.dart';
import '../../../../service/shared_pref/my_shared_preferences.dart';
import '../../../user_profile/user_profile_page.dart';
import 'components/chat_text_field.dart';
import 'components/pop_up_menu.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    super.key,
    required this.consId,
    required this.userName,
    required this.userId,
  });

  final String consId;
  final String userName;
  final String userId;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final SocketService _socketService = SocketService();
  User? user;
  UserProfile? userProfile;

  Future<void> getUser() async {
    String? data = await MySharedPreferences.instance.user;
    LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(data!));
    user = loginResponse.data!.user;
    final AuthGetUserRepo repo =
        RepositoryProvider.of<AuthGetUserRepo>(context);
    userProfile = await repo.getUserProfile(widget.userId);
    setState(() {});
  }

  @override
  void initState() {
    getUser();
    _socketService.setConsId(widget.consId);
    context.read<ChatViewBloc>().startListening(widget.consId);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  final ScrollController _scrollController = ScrollController();
  final TextEditingController controller = TextEditingController();

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragCancel: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 70.w,
          leading: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: IconButton(
                onPressed: () {
                  _socketService.clearMessages();
                  Navigator.pop(context);
                  _socketService.setConsId('');
                },
                icon: Icon(CupertinoIcons.back)),
          ),
          title: Text(widget.userName),
          actions: [
            BlocBuilder<ChatViewBloc, ChatViewState>(
              builder: (context, state) {
                if (state is GetChatMessagesState) {
                  return ChatPopupMenuButton(
                    onPressedForm: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => MultiRepositoryProvider(
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
                            child: UserProfilePage(
                              id: widget.userId,
                              assetImage: userProfile!.data!.gender == "MALE"
                                  ? getMaleRandomImages()
                                  : getFemaleRandomImages(),
                            ),
                          ),
                        ),
                      );
                    },
                    status: '',
                  );
                }
                return SizedBox();
              },
            ),
            20.horizontalSpace
          ],
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatViewBloc, ChatViewState>(
                  builder: (context, state) {
                    if (state is LoadingChatMessagesState) {
                      return Center(
                        child: Platform.isIOS
                            ? const CupertinoActivityIndicator()
                            : const CircularProgressIndicator(),
                      );
                    }

                    if (state is GetChatMessagesState) {
                      WidgetsBinding.instance.addPostFrameCallback(
                            (_) => _scrollToBottom(),
                      );

                      return ListView.builder(
                        controller: _scrollController,
                        dragStartBehavior: DragStartBehavior.down,
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final message = state.messages[index];

                          return ChatBubble(
                            message: message.message!,
                            isMe: message.sender!.id! == user!.id!,
                            isRead: message.isRead ?? false,
                            timestamp: message.createdAt!,
                            messageId: message.id!,
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),

              Padding(
                padding: REdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Expanded(
                      child: ChatTextField(
                        controller: controller,
                      ),
                    ),
                    5.horizontalSpace,
                    ChatSendButton(
                      onPressed: () {
                        final text = controller.text.trim();

                        if (text.isEmpty) return;

                        _socketService.sendMessage(
                          text,
                          widget.consId,
                        );

                        controller.clear();
                      },
                    ),
                  ],
                ),
              ),

              5.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
