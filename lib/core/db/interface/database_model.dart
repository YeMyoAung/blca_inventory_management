abstract class DatabaseModel {
  Map<String, dynamic> toJson();
}

abstract class DatabaseParamModel {
  Map<String, dynamic> toCreate();
  Map<String, dynamic> toUpdate();
}
