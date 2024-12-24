import 'package:requests_with_riverpod/providers/states/base_state.dart';

class NewCatState extends BaseState<NewCatState> {
  NewCatState({
    required super.isLoading,
    super.errorMessage,
    super.isSuccess,
  });

  factory NewCatState.initial() {
    return NewCatState(
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
    return NewCatState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
