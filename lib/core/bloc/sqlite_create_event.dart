abstract class SqliteCreateBaseEvent {
  const SqliteCreateBaseEvent();
}

abstract class NullObject {
  const NullObject();
}

class SqliteCreateEvent<T> extends SqliteCreateBaseEvent {
  final T? arguments;
  const SqliteCreateEvent({
    this.arguments,
  });
}


//  on => listen => SqliteCreateEvent call => add(SqliteCreateEvent())

// after
// listen => SqliteCreateEvent<T> call => add(SqliteCreateEvent()) 
// T base class => NullObject
// listen => SqliteCreateEvent<NullObject> call => add(SqliteCreateEvent<NullObject>())

/// class T extends NullObject