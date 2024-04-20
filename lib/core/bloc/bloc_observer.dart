import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';

class CustomBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    logger.i("OnCreate: $bloc");
    super.onCreate(bloc);
  }

  @override
  void onClose(BlocBase bloc) {
    logger.i("OnClose: $bloc");
    super.onClose(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    logger.w("OnEvent: $bloc was get Event: $event");
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    logger.w(
        "OnChange: $bloc was Changed: ${change.currentState} ${change.nextState}");
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logger.e("OnError: $bloc was get Error: $error");
    super.onError(bloc, error, stackTrace);
  }
}
