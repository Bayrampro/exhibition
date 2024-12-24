import 'package:requests_with_riverpod/providers/states/base_state.dart';

class EditCatState extends BaseState {
  const EditCatState({
    required super.isLoading,
    super.errorMessage,
    super.isSuccess,
  });

  factory EditCatState.initial() {
    return const EditCatState(
      isLoading: false,
      errorMessage: null,
      isSuccess: false,
    );
  }

  @override
  copyWith({bool? isLoading, String? errorMessage, bool? isSuccess}) {
    return EditCatState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
