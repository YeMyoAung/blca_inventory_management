import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';

abstract class SqliteEvent<Model extends DatabaseModel> {
  const SqliteEvent();
}

class SqliteGetEvent<Model extends DatabaseModel> extends SqliteEvent<Model> {}

class SqliteCreatedEvent<Model extends DatabaseModel>
    extends SqliteEvent<Model> {
  final Result<Model> model;

  const SqliteCreatedEvent(this.model);
}

class SqliteUpdatedEvent<Model extends DatabaseModel>
    extends SqliteEvent<Model> {
  final Result<Model> model;

  const SqliteUpdatedEvent(this.model);
}

class SqliteDeletedEvent<Model extends DatabaseModel>
    extends SqliteEvent<Model> {
  final Result<Model> model;
  const SqliteDeletedEvent(this.model);
}
