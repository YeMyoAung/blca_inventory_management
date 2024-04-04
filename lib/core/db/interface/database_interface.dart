///interface
abstract class DataStore<D> {
  D? database;

  ///connection
  Future<void> connect();

  ///close
  Future<void> close();

  ///table create
  Future<void> onUp([D? db]);

  ///table drop
  Future<void> onDown([D? db]);
}
