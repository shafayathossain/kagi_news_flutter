class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  Result._({required this.isSuccess, this.data, this.error});

  factory Result.success(T data) => Result._(data: data, isSuccess: true);
  factory Result.error(String message) => Result._(error: message, isSuccess: false);
}
