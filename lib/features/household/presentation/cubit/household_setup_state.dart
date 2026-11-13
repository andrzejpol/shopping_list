import 'package:equatable/equatable.dart';
import 'package:shopping_list/features/household/domain/failures/household_failure.dart';

class HouseholdSetupState extends Equatable {
  final bool isSubmitting;
  final HouseholdFailure? failure;

  const HouseholdSetupState({this.isSubmitting = false, this.failure});

  @override
  List<Object?> get props => [isSubmitting, failure];
}
