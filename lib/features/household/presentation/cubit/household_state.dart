import 'package:equatable/equatable.dart';
import 'package:shopping_list/core/failures/data_failure.dart';

sealed class HouseholdState extends Equatable {
  const HouseholdState();

  @override
  List<Object?> get props => [];
}

final class HouseholdUnknown extends HouseholdState {
  const HouseholdUnknown();
}

final class HouseholdMissing extends HouseholdState {
  const HouseholdMissing();
}

final class HouseholdReady extends HouseholdState {
  final String householdId;

  const HouseholdReady(this.householdId);

  @override
  List<Object?> get props => [householdId];
}

final class HouseholdError extends HouseholdState {
  final DataFailure failure;

  const HouseholdError(this.failure);

  @override
  List<Object?> get props => [failure];
}
