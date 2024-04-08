void main() {
  String name = """Create table if not exists users (
        id integer primary key autoincrement,
        created_at text not null,
        updated_at text,
        name varchar(255) not null,""";
  print(name[name.length - 2]);
  print(name[name.length - 1]);
  // print(name[name.length]);
  name.replaceFirst(",", "", name.length - 2);
}
