part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}
class GetUsersEvent  extends ChatEvent{
   List<Items>? handler;
   GetUsersEvent(this.handler);
}
class SearchUsersEvent extends ChatEvent {
   final String name;
   SearchUsersEvent(this.name);
}
