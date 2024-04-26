import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/injection/injection.dart';

void main() async {
  final c = Container();

  // c.setSingletone("Hello World");
  // c.set("Hello World H1");
  // c.set("Hi World", instanceName: "hi");

  c.setLazyFuture<A>(
    () async {
      print("Future");
      return A(id: 1);
    },
    // dispose: (value) async {
    //   print("Dispose");
    //   value.dispose();
    // },
    // autoDispose: true,
  );

  // c.remove<A>();

  final a = await c.getLazyFuture<A>();

  c.get<A>();

  a.dispose();

  c.get<A>().work();

  // String name = """Create table if not exists users (
  //       id integer primary key autoincrement,
  //       created_at text not null,
  //       updated_at text,
  //       name varchar(255) not null,""";
  // print(name[name.length - 2]);
  // print(name[name.length - 1]);
  // // print(name[name.length]);
  // name.replaceFirst(",", "", name.length - 2);
  // print(A(id: 1) == A(id: 1));
}

class A extends DatabaseModel {
  bool isDispose = false;
  A({required super.id});

  void dispose() {
    isDispose = true;
  }

  void work() {
    if (isDispose) throw "Already dispose";
    print("start working");
  }

  @override
  Map<String, dynamic> toJson() {
    return {"a": "This is A"};
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
