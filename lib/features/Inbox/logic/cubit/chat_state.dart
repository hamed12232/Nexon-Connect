part of 'chat_cubit.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}
class ChatCreated extends ChatState {
  final List<Map<String, dynamic>> chats;
  ChatCreated(this.chats);
}


class MessageSent extends ChatState {}

class ChatError extends ChatState {
  final String error;
  ChatError(this.error);
}
