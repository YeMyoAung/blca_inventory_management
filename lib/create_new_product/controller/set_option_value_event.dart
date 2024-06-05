abstract class SetOptionValueBaseEvent {
  const SetOptionValueBaseEvent();
}

class AddNewOptionValueEvent extends SetOptionValueBaseEvent {}

class AddNewAttributeValueEvent extends SetOptionValueBaseEvent {
  final int groupId, fieldId;
  const AddNewAttributeValueEvent(this.groupId, this.fieldId);
}

class RemoveOptionValueEvent extends SetOptionValueBaseEvent {
  final int groupId;
  const RemoveOptionValueEvent(this.groupId);
}

class ClearOptionValueEvent extends SetOptionValueBaseEvent {}


class GenerateOptionValueEvent extends SetOptionValueBaseEvent{}