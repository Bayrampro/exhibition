abstract class BaseState<T> {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const BaseState({
    required this.isLoading,
    this.errorMessage,
    this.isSuccess = false,
  });

  T copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  });
}
