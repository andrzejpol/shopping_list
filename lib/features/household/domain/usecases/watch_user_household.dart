import 'package:shopping_list/features/household/domain/repositories/household_repository.dart';

class WatchUserHousehold {
  final HouseholdRepository _repository;

  const WatchUserHousehold(this._repository);

  Stream<String?> call(String userId) {
    return _repository.watchHouseholdId(userId);
  }
}
