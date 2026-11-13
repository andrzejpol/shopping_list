import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/features/household/domain/failures/household_failure.dart';
import 'package:shopping_list/features/household/domain/usecases/create_household.dart';
import 'package:shopping_list/features/household/domain/usecases/join_household.dart';
import 'package:shopping_list/features/household/presentation/cubit/household_setup_state.dart';

class HouseholdSetupCubit extends Cubit<HouseholdSetupState> {
  HouseholdSetupCubit({
    required CreateHousehold createHousehold,
    required JoinHousehold joinHousehold,
  }) : _createHousehold = createHousehold,
       _joinHousehold = joinHousehold,
       super(const HouseholdSetupState());

  final CreateHousehold _createHousehold;
  final JoinHousehold _joinHousehold;

  Future<void> create(String userId) => _submit(() => _createHousehold(userId));

  Future<void> join({required String userId, required String code}) =>
      _submit(() => _joinHousehold(userId: userId, code: code));

  Future<void> _submit(Future<void> Function() action) async {
    emit(const HouseholdSetupState(isSubmitting: true));
    try {
      await action();
    } on HouseholdFailure catch (failure) {
      emit(HouseholdSetupState(failure: failure));
    }
  }
}
