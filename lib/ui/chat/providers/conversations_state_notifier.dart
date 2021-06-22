import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:honk_clone/services/api_service.dart';
import 'package:honk_clone/ui/chat/models/conversation_model.dart';
import 'package:honk_clone/ui/chat/providers/chat_state.dart';

class ConversationsStateNotifier extends StateNotifier<ChatState> {
  final ApiService apiService;
  static final Box userData = Hive.box('userData');
  ConversationsStateNotifier(this.apiService)
      : super(ConversationsInitialState());

  Future<void> getConversations() async {
    final String? token = userData.get("user").accessToken;
    state = ConversationsLoadingState();

    try {
      final List<Conversation> conversations =
          await apiService.getConversations(token: token);
      state = ConversationsLoadedState(conversations);
    } on DioError catch (e) {
      if (e.response != null) {
        final error = e.response!.data;
        if (error['message'] is String) {
          state = ConversationsErrorState(error['message']);
        } else {
          state = ConversationsErrorState(error['message'][0]);
        }
      } else {
        state = ConversationsErrorState(e.message);
      }
    }
  }
}

final conversationsStateNotifier =
    StateNotifierProvider<ConversationsStateNotifier, ChatState>(
  (ref) => ConversationsStateNotifier(
    ref.watch(apiServiceProvider),
  ),
);
