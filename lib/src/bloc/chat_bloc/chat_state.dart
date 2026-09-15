part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class GetChatUserState extends ChatState {
   List<Items> users;
   GetChatUserState({required this.users});
}

class EmptyChatUserState extends ChatState {}

class LoadingChatUserState extends ChatState {}
