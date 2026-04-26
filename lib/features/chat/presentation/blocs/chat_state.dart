import 'package:equatable/equatable.dart';

import '../../domain/entities/message.dart';

class ChatState extends Equatable {
  final List<Message> messages;

  const ChatState({required this.messages});

  factory ChatState.initial() {
    return const ChatState(messages: []);
  }

  ChatState copyWith({List<Message>? messages}) {
    return ChatState(messages: messages ?? this.messages);
  }

  @override
  List<Object> get props => [messages];
}
