import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:honk_clone/services/api_service.dart';
import 'package:honk_clone/ui/auth/models/user_model.dart';
import 'package:honk_clone/ui/search/providers/search_state.dart';

class SearchStateNotifier extends StateNotifier<SearchState> {
  final ApiService apiService;
  static final Box userData = Hive.box('userData');

  SearchStateNotifier(this.apiService) : super(SearchInitialState());

  Future<void> searchForUsers({required String query}) async {
    final String? token = userData.get("user").accessToken;
    state = SearchLoadingState();

    try {
      final List<User> results = await apiService.searchForUsers(
        token: token,
        query: query,
      );

      state = SearchLoadedState(results);
    } on DioError catch (e) {
      if (e.response != null) {
        final error = e.response!.data;
        if (error['message'] is String) {
          state = SearchErrorState(error['message']);
        } else {
          state = SearchErrorState(error['message'][0]);
        }
      } else {
        state = SearchErrorState(e.message);
      }
    }
  }
}

final searchStateNotifier =
    StateNotifierProvider.autoDispose<SearchStateNotifier, SearchState>(
  (ref) => SearchStateNotifier(
    ref.watch(apiServiceProvider),
  ),
);
