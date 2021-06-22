import 'package:flutter/foundation.dart';

import 'package:honk_clone/ui/chat/models/conversation_model.dart';

abstract class ChatState {
  const ChatState();
}

class ConversationsInitialState extends ChatState {
  const ConversationsInitialState();
}

class ConversationsLoadingState extends ChatState {
  const ConversationsLoadingState();
}

class ConversationsLoadedState extends ChatState {
  final List<Conversation> conversations;
  const ConversationsLoadedState(this.conversations);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConversationsLoadedState &&
        listEquals(other.conversations, conversations);
  }

  @override
  int get hashCode => conversations.hashCode;
}

class ConversationsErrorState extends ChatState {
  final String? message;
  const ConversationsErrorState(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConversationsErrorState && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
