import 'package:shopping_list/features/household/domain/failures/household_failure.dart';
import 'package:shopping_list/features/household/domain/household_code.dart';
import 'package:shopping_list/features/household/domain/repositories/household_repository.dart';

class JoinHousehold {
  final HouseholdRepository _repository;

  const JoinHousehold(this._repository);

  Future<void> call({required String userId, required String code}) async {
    final normalizedCode = code.trim().toUpperCase();
    if (normalizedCode.length != householdCodeLength) {
      throw const InvalidHouseholdCode();
    }

    await _repository.joinHousehold(userId: userId, code: normalizedCode);
  }
}
