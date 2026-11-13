sealed class HouseholdFailure implements Exception {
  const HouseholdFailure();
}

class InvalidHouseholdCode extends HouseholdFailure {
  const InvalidHouseholdCode();
}

class HouseholdNotFound extends HouseholdFailure {
  const HouseholdNotFound();
}

class UnknownHouseholdFailure extends HouseholdFailure {
  const UnknownHouseholdFailure();
}
