import 'package:honk_clone/ui/auth/models/user_model.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitialState extends AuthState {
  const AuthInitialState();
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthLoadedState extends AuthState {
  final User user;
  const AuthLoadedState(this.user);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthLoadedState && other.user == user;
  }

  @override
  int get hashCode => user.hashCode;
}

class AuthErrorState extends AuthState {
  final String? message;
  const AuthErrorState(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthErrorState && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
