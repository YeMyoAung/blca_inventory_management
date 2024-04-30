abstract class CreateNewShopState {
  final String? coverPhotoPath;
  final DateTime _dateTime;
  CreateNewShopState({required this.coverPhotoPath})
      : _dateTime = DateTime.now();

  @override
  operator ==(covariant CreateNewShopState other) {
    return other.coverPhotoPath == coverPhotoPath &&
        other._dateTime.toIso8601String() == _dateTime.toIso8601String();
  }

  @override
  int get hashCode => coverPhotoPath?.hashCode ?? ''.hashCode;
}

class CreateNewShopInitialState extends CreateNewShopState {
  CreateNewShopInitialState() : super(coverPhotoPath: null);
}

class CreateNewShopCoverPhotoSelectedState extends CreateNewShopState {
  CreateNewShopCoverPhotoSelectedState({
    required super.coverPhotoPath,
  });
}

class CreateNewShopCreatingState extends CreateNewShopState {
  CreateNewShopCreatingState({required super.coverPhotoPath});
}

class CreateNewShopCreatedState extends CreateNewShopState {
  CreateNewShopCreatedState() : super(coverPhotoPath: null);
}

class CreateNewShopErrorState extends CreateNewShopState {
  final String message;
  CreateNewShopErrorState({
    required this.message,
    required super.coverPhotoPath,
  });
}
