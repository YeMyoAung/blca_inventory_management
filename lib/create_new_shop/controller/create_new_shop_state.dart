import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';

abstract class CreateNewShopState {
  final DateTime _dateTime;
  CreateNewShopState() : _dateTime = DateTime.now();

  @override
  operator ==(covariant CreateNewShopState other) {
    return other._dateTime.toIso8601String() == _dateTime.toIso8601String();
  }

  @override
  int get hashCode => _dateTime.hashCode;
}

class CreateNewShopInitialState extends CreateNewShopState {
  CreateNewShopInitialState();
}

class CreateNewShopCoverPhotoSelectedState extends SqliteExecuteBaseState {
  CreateNewShopCoverPhotoSelectedState();
}

class CreateNewShopCreatingState extends CreateNewShopState {
  CreateNewShopCreatingState();
}

class CreateNewShopCreatedState extends CreateNewShopState {
  CreateNewShopCreatedState();
}

class CreateNewShopErrorState extends CreateNewShopState {
  final String message;
  CreateNewShopErrorState({
    required this.message,
  });
}
