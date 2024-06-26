import 'package:inventory_management_with_sql/core/bloc/bloc_state.dart';

class SetOptionValueBaseState extends BlocBaseState {}

class SetOptionValueInitialState extends SetOptionValueBaseState {}

class AddNewOptionValueState extends SetOptionValueBaseState {}

class ClearOptionValueState extends SetOptionValueBaseState {}

class RemoveOptionValueState extends SetOptionValueBaseState {}

class GenerateOptionValueState extends SetOptionValueBaseState {}

class GeneratedOptionValueState extends SetOptionValueBaseState {
  final List<String>? selectedProperties;

  GeneratedOptionValueState({required this.selectedProperties});
}
