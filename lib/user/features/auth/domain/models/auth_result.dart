import 'auth_user.dart';

/// Sealed class representing the result of any Auth operation.
sealed class AuthResult {
  const AuthResult();
}

class AuthSuccess extends AuthResult {
  final AuthUser? user;
  final String? message;

  const AuthSuccess({this.user, this.message});
}

class AuthFailure extends AuthResult {
  final String error;

  const AuthFailure(this.error);
}
