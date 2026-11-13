import 'package:shopping_list/features/household/domain/repositories/household_repository.dart';

class CreateHousehold {
  final HouseholdRepository _repository;

  const CreateHousehold(this._repository);

  Future<String> call(String userId) {
    return _repository.createHousehold(userId);
  }
}
