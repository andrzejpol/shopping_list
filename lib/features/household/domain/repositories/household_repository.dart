abstract interface class HouseholdRepository {
  Stream<String?> watchHouseholdId(String userId);

  Future<String> createHousehold(String userId);

  Future<void> joinHousehold({required String userId, required String code});
}
