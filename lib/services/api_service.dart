import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:honk_clone/constants/constants.dart';
import 'package:honk_clone/ui/auth/models/user_model.dart';
import 'package:honk_clone/ui/chat/models/conversation_model.dart';

class ApiService {
  static BaseOptions options = new BaseOptions(
    baseUrl: kBaseUrl,
  );
  Dio dio = new Dio(options);

  Future<User> signIn({
    required String username,
    required String password,
    String? fcmToken,
  }) async {
    Response response = await dio.post(
      "/auth/login",
      data: {
        "username": username,
        "password": password,
      },
    );
    final payload = User.fromJson(response.data);
    return payload;
  }

  Future<User> signUp({
    required String name,
    required String username,
    required String password,
    String? fcmToken,
  }) async {
    Response response = await dio.post(
      "/auth/signup",
      data: {
        "name": name,
        "username": username,
        "password": password,
      },
    );
    final payload = User.fromJson(response.data);
    return payload;
  }

  Future<List<Conversation>> getConversations({required String? token}) async {
    Response response = await dio.get(
      "/chat/conversations",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );
    final payload = response.data as List;
    final data = payload.map((message) => Conversation.fromJson(message));
    return data.toList();
  }

  Future<List<User>> searchForUsers({
    required String? token,
    required String query,
  }) async {
    Response response = await dio.get(
      "/auth/users/search?query=$query",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );
    final payload = response.data as List;
    final data = payload.map((message) => User.fromJson(message));
    return data.toList();
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});
