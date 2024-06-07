import 'package:inventory_management_with_sql/core/bloc/bloc_state.dart';

abstract class SetOptionValueBaseEvent extends BlocBaseState {
  SetOptionValueBaseEvent();
}

class AddNewOptionValueEvent extends SetOptionValueBaseEvent {}

class AddNewAttributeValueEvent extends SetOptionValueBaseEvent {
  final int attributeId, optionId;
  AddNewAttributeValueEvent(this.attributeId, this.optionId);
}

class RemoveOptionValueEvent extends SetOptionValueBaseEvent {
  final int optionId;
  RemoveOptionValueEvent(this.optionId);
}

class ClearOptionValueEvent extends SetOptionValueBaseEvent {}

class GenerateOptionValueEvent extends SetOptionValueBaseEvent {}

class RemoveAttributeFieldEvent extends SetOptionValueBaseEvent {
  final int attributeId, optionId;
  RemoveAttributeFieldEvent(this.attributeId, this.optionId);
}
