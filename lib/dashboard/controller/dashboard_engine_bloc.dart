import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/dashboard/controller/dashboard_engine_event.dart';
import 'package:inventory_management_with_sql/dashboard/controller/dashboard_engine_state.dart';
import 'package:inventory_management_with_sql/repo/dashboard_repo/dashboard_repo.dart';

class DashboardEngineBloc extends Bloc {
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
        return emit(DashboardEngineErrorState(message: event.toString()));
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
  Future<void> close() {
    return Future.wait([
      _subscription?.cancel() ?? Future.value(),
      repo.dispose(),
    ]);
  }
}
