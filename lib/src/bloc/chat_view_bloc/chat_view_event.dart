// part of 'chat_view_bloc.dart';
//
// @immutable
// abstract class ChatViewEvent {}
// class GetMessagesEvent extends ChatViewEvent{
//   List<DataMes> messages;
//   GetMessagesEvent({required this.messages});
// }
// class NewMessagesEvent extends ChatViewEvent{
//   final DataMes message;
//   NewMessagesEvent({required this.message});
// }
part of 'chat_view_bloc.dart';

@immutable
abstract class ChatViewEvent {}

class LoadMessagesEvent extends ChatViewEvent {
  LoadMessagesEvent();
}

class GetMessagesEvent extends ChatViewEvent {
  final List<DataMes> messages;
  GetMessagesEvent({required this.messages});
}
