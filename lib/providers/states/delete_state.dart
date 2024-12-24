import 'package:requests_with_riverpod/providers/states/base_state.dart';

class DeleteState extends BaseState<DeleteState> {
  DeleteState({
    required super.isLoading,
    super.errorMessage,
    super.isSuccess,
  });

  factory DeleteState.initial() {
    return DeleteState(
      isLoading: false,
      errorMessage: null,
      isSuccess: false,
    );
  }

  @override
  copyWith({bool? isLoading, String? errorMessage, bool? isSuccess}) {
    return DeleteState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
