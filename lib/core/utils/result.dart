/// Represents the result of an operation that can either succeed or fail.
sealed class Result<T> {
  /// Const constructor.
  const Result();
}

/// Represents a successful operation containing data of type [T].
class Success<T> extends Result<T> {
  /// The data returned on success.
  final T data;

  /// Creates a [Success] result containing [data].
  const Success(this.data);
}

/// Represents a failed operation containing a descriptive error [message].
class Failure<T> extends Result<T> {
  /// The error message.
  final String message;

  /// Creates a [Failure] result containing [message].
  const Failure(this.message);
}
