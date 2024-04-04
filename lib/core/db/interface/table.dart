abstract class TableProperties {}

class TableForeignKey implements TableProperties {
  final String fColumn;
  final String table;
  final String tblColumn;

  const TableForeignKey({
    required this.fColumn,
    required this.table,
    this.tblColumn = "id",
  });
}

class TableColumn implements TableProperties {
  final String name;
  final String type;
  final String options;

  const TableColumn({
    required this.name,
    required this.type,
    this.options = "",
  });
}
