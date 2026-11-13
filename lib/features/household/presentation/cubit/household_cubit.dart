import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/failures/data_failure.dart';
import 'package:shopping_list/features/household/domain/usecases/watch_user_household.dart';
import 'package:shopping_list/features/household/presentation/cubit/household_state.dart';

class HouseholdCubit extends Cubit<HouseholdState> {
  HouseholdCubit({required WatchUserHousehold watchUserHousehold})
    : _watchUserHousehold = watchUserHousehold,
      super(const HouseholdUnknown());

  final WatchUserHousehold _watchUserHousehold;

  late final String _userId;
  StreamSubscription<String?>? _subscription;

  void init(String userId) {
    _userId = userId;
    _subscribe();
  }

  void _subscribe() {
    _subscription = _watchUserHousehold(_userId).listen(
      (householdId) => emit(
        householdId == null
            ? const HouseholdMissing()
            : HouseholdReady(householdId),
      ),
      onError: (Object error) => emit(
        HouseholdError(
          error is DataFailure ? error : const UnknownDataFailure(),
        ),
      ),
    );
  }

  Future<void> retry() async {
    await _subscription?.cancel();
    emit(const HouseholdUnknown());
    _subscribe();
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
