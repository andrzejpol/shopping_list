sealed class DataFailure implements Exception {
  const DataFailure();
}

class PermissionDeniedFailure extends DataFailure {
  const PermissionDeniedFailure();
}

class ServiceUnavailableFailure extends DataFailure {
  const ServiceUnavailableFailure();
}

class UnknownDataFailure extends DataFailure {
  const UnknownDataFailure();
}
