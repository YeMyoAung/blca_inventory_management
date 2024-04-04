import 'package:inventory_management_with_sql/core/db/interface/table.dart';

String toSqlQuery(TableProperties property) {
  if (property is TableColumn) {
    return "${property.name} ${property.type} ${property.options},";
  }

  if (property is TableForeignKey) {
    return "foreign key (${property.fColumn}) references ${property.table}(${property.tblColumn})";
  }

  throw UnimplementedError();
}
