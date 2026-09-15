import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sovchilar/src/service/socket/socket.dart';

import '../../data/get_con.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SocketService _socketService = SocketService();

  List<Items> _allUsers = [];

  ChatBloc() : super(ChatInitial()) {
    on<GetUsersEvent>(_onGetUsers);
    on<SearchUsersEvent>(_onSearchUsers);

    _init();
  }

  Future<void> _init() async {
    try {
      await _socketService.waitForConnection();

      log('🟢 CHAT SOCKET READY');

      _fetchConversations();
    } catch (e) {
      log('❌ Chat socket error: $e');
    }
  }

  void _fetchConversations() {
    log('GET CONVERSATIONS');

    _socketService.getConversations((handler) {
      log('CONVERSATIONS CALLBACK: ${handler.length}');

      add(GetUsersEvent(handler));
    });
  }

  void _onGetUsers(
      GetUsersEvent event,
      Emitter<ChatState> emit,
      ) {
    log('GET USERS EVENT: ${event.handler?.length}');

    final users = event.handler ?? [];

    _allUsers = users;

    if (users.isEmpty) {
      emit(EmptyChatUserState());
    } else {
      emit(GetChatUserState(users: users));
    }
  }

  void _onSearchUsers(
      SearchUsersEvent event,
      Emitter<ChatState> emit,
      ) {
    final query = event.name.trim().toLowerCase();

    if (query.isEmpty) {
      if (_allUsers.isEmpty) {
        emit(EmptyChatUserState());
      } else {
        emit(GetChatUserState(users: _allUsers));
      }

      return;
    }

    final filteredUsers = _allUsers.where((user) {
      final firstName =
      user.participants?.isNotEmpty == true
          ? user.participants!.first.firstName ?? ''
          : '';

      return firstName.toLowerCase().contains(query);
    }).toList();

    if (filteredUsers.isEmpty) {
      emit(EmptyChatUserState());
    } else {
      emit(GetChatUserState(users: filteredUsers));
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}