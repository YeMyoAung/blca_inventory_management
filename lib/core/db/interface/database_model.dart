/// Model
abstract class DatabaseModel {
  const DatabaseModel();
  Map<String, dynamic> toJson();
}

/// How to create or udpate
abstract class DatabaseParamModel {
  const DatabaseParamModel();
  Map<String, dynamic> toCreate();
  Map<String, dynamic> toUpdate();
}
