part of 'chat_view_bloc.dart';

@immutable
abstract class ChatViewState {}

class ChatViewInitial extends ChatViewState {}
class GetChatMessagesState extends ChatViewState {
  final List<DataMes> messages;
  GetChatMessagesState({required this.messages});
}
class EmptyChatMessagesState extends ChatViewState {}
class LoadingChatMessagesState extends ChatViewState {}
