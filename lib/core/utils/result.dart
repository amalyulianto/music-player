/// Represents the result of an operation that can either succeed or fail.
sealed class Result<T> {
  const Result();
}

/// Represents a successful operation containing data of type [T].
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

/// Represents a failed operation containing a descriptive error [message].
class Failure<T> extends Result<T> {
  final String message;

  const Failure(this.message);
}
