import 'package:flutter/foundation.dart';

import 'package:honk_clone/ui/auth/models/user_model.dart';

abstract class SearchState {
  const SearchState();
}

class SearchInitialState extends SearchState {
  const SearchInitialState();
}

class SearchLoadingState extends SearchState {
  const SearchLoadingState();
}

class SearchLoadedState extends SearchState {
  final List<User> results;
  const SearchLoadedState(this.results);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchLoadedState && listEquals(other.results, results);
  }

  @override
  int get hashCode => results.hashCode;
}

class SearchErrorState extends SearchState {
  final String? message;
  const SearchErrorState(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchErrorState && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
