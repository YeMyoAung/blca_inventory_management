abstract class CreateNewShopState {
  final String? coverPhotoPath;

  const CreateNewShopState({required this.coverPhotoPath});

  @override
  operator ==(covariant CreateNewShopState other) {
    return other.coverPhotoPath == coverPhotoPath;
  }

  @override
  int get hashCode => coverPhotoPath?.hashCode ?? ''.hashCode;
}

class CreateNewShopInitialState extends CreateNewShopState {
  const CreateNewShopInitialState() : super(coverPhotoPath: null);
}

class CreateNewShopCoverPhotoSelectedState extends CreateNewShopState {
  const CreateNewShopCoverPhotoSelectedState({
    required super.coverPhotoPath,
  });
}

class CreateNewShopCreateingState extends CreateNewShopState {
  const CreateNewShopCreateingState({required super.coverPhotoPath});
}

class CreateNewShopCreatedState extends CreateNewShopState {
  const CreateNewShopCreatedState() : super(coverPhotoPath: null);
}

class CreateNewShopErrorState extends CreateNewShopState {
  const CreateNewShopErrorState({
    required super.coverPhotoPath,
  });
}
