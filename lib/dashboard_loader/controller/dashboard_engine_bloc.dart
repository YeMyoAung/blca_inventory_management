import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/dashboard_loader/controller/dashboard_engine_event.dart';
import 'package:inventory_management_with_sql/dashboard_loader/controller/dashboard_engine_state.dart';
import 'package:inventory_management_with_sql/repo/dashboard_repo/dashboard_repo.dart';

class DashboardEngineBloc
    extends Bloc<DashboardEngineEvent, DashboardEngineState> {
  final DashboardEngineRepo repo;
  StreamSubscription? _subscription;
  DashboardEngineBloc(super.initialState, this.repo) {
    _subscription = repo.isReady.listen((event) {
      return add(DashboardEngineStreamEvent(
        result: event,
      ));
    });

    on<DashboardEngineStreamEvent>((event, emit) {
      if (event.result.hasError) {
        return emit(
          DashboardEngineErrorState(
            message: event.result.toString(),
          ),
        );
      }
      emit(const DashboardEngineReadyState());
    });

    on<DashboardEngineInitEvent>((_, emit) async {
      emit(const DashboardEngineLoadingState());
      await repo.init();
    });

    add(const DashboardEngineInitEvent());
  }
  @override
  Future<void> close() async {
    await Future.wait([
      _subscription?.cancel() ?? Future.value(),
      repo.dispose(),
    ]);

    // return super.close().then((value) {
    //   container.remove<DashboardEngineBloc>();
    // });
    return super.close();
  }
}
