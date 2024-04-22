import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';

void main() {
  // String name = """Create table if not exists users (
  //       id integer primary key autoincrement,
  //       created_at text not null,
  //       updated_at text,
  //       name varchar(255) not null,""";
  // print(name[name.length - 2]);
  // print(name[name.length - 1]);
  // // print(name[name.length]);
  // name.replaceFirst(",", "", name.length - 2);
  print(A(id: 1) == A(id: 1));
}

class A extends DatabaseModel {
  A({required super.id});

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

class B extends DatabaseModel {
  B({required super.id});

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
