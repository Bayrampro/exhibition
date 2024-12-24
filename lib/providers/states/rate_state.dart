import 'package:requests_with_riverpod/providers/states/base_state.dart';

class RateState extends BaseState<RateState> {
  const RateState({
    required super.isLoading,
    super.errorMessage,
    super.isSuccess,
  });

  factory RateState.initial() {
    return const RateState(
      isLoading: false,
      errorMessage: null,
      isSuccess: false,
    );
  }

  @override
  copyWith({bool? isLoading, String? errorMessage, bool? isSuccess}) {
    return RateState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
