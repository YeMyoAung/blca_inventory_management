///interface
abstract class DataStore<D> {
  D? database; //postgres,mongo,firebase

  ///connection
  Future<void> connect();

  ///close
  Future<void> close();

  ///table create
  Future<void> onUp(int version, [D? db]);

  ///table drop
  Future<void> onDown(int old, current, [D? db]);
}
