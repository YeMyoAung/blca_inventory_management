abstract class SqliteExecuteBaseEvent {
  const SqliteExecuteBaseEvent();
}

abstract class NullObject {
  const NullObject();
}

class SqliteExecuteEvent<T> extends SqliteExecuteBaseEvent {
  final T? arguments;
  const SqliteExecuteEvent({
    this.arguments,
  });
}


//  on => listen => SqliteCreateEvent call => add(SqliteCreateEvent())

// after
// listen => SqliteCreateEvent<T> call => add(SqliteCreateEvent()) 
// T base class => NullObject
// listen => SqliteCreateEvent<NullObject> call => add(SqliteCreateEvent<NullObject>())

/// class T extends NullObject