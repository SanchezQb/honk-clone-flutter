import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:honk_clone/services/api_service.dart';
import 'package:honk_clone/ui/auth/models/user_model.dart';
import 'package:honk_clone/ui/auth/providers/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService apiService;
  static final Box userData = Hive.box('userData');
  AuthNotifier(this.apiService) : super(AuthInitialState());

  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    state = AuthLoadingState();
    try {
      final User user = await apiService.signIn(
        username: username,
        password: password,
      );
      userData.put("user", user);
      state = AuthLoadedState(user);
    } on DioError catch (e) {
      if (e.response != null) {
        final error = e.response!.data;
        if (error['message'] is String) {
          state = AuthErrorState(error['message']);
        } else {
          state = AuthErrorState(error['message'][0]);
        }
      } else {
        state = AuthErrorState(e.message);
      }
    }
  }

  Future<void> signUp({
    required String name,
    required String username,
    required String password,
  }) async {
    state = AuthLoadingState();
    try {
      final User user = await apiService.signUp(
        name: name,
        username: username,
        password: password,
      );
      userData.put("user", user);
      state = AuthLoadedState(user);
    } on DioError catch (e) {
      if (e.response != null) {
        final error = e.response!.data;
        if (error['message'] is String) {
          state = AuthErrorState(error['message']);
        } else {
          state = AuthErrorState(error['message'][0]);
        }
      } else {
        state = AuthErrorState(e.message);
      }
    }
  }

  void logOut() {
    userData.delete("user");
    state = AuthInitialState();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
    (ref) => AuthNotifier(ref.watch(apiServiceProvider)));

final togglePasswordStateprovider =
    StateProvider.autoDispose<bool>((ref) => true);
