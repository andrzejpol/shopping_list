sealed class AuthFailure implements Exception {
  const AuthFailure();
}

class InvalidCredentials extends AuthFailure {
  const InvalidCredentials();
}

class EmailAlreadyInUse extends AuthFailure {
  const EmailAlreadyInUse();
}

class WeakPassword extends AuthFailure {
  const WeakPassword();
}

class InvalidEmail extends AuthFailure {
  const InvalidEmail();
}

class NetworkFailure extends AuthFailure {
  const NetworkFailure();
}

class UnknownAuthFailure extends AuthFailure {
  const UnknownAuthFailure();
}

class TooManyRequests extends AuthFailure {
  const TooManyRequests();
}

class SignInCancelled extends AuthFailure {
  const SignInCancelled();
}

class PopupBlocked extends AuthFailure {
  const PopupBlocked();
}

class AccountExistsWithDifferentCredential extends AuthFailure {
  const AccountExistsWithDifferentCredential();
}
