import 'package:requests_with_riverpod/providers/states/base_state.dart';

class LoginState extends BaseState<LoginState> {
  LoginState({
    required super.isLoading,
    super.errorMessage,
    super.isSuccess,
  });

  factory LoginState.initial() {
    return LoginState(
      isLoading: false,
      errorMessage: null,
      isSuccess: false,
    );
  }

  @override
  copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
