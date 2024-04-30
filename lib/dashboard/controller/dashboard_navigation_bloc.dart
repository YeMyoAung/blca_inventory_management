import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/dashboard/controller/dashboard_navigation_event.dart';
import 'package:inventory_management_with_sql/dashboard/controller/dashboard_navigation_state.dart';

class DashboardNavigationBloc
    extends Bloc<DashboardNavigationEvent, DashboardNavigationState> {
  DashboardNavigationBloc(super.initialState) {
    on<DashboardNavigationEvent>((event, emit) {
      emit(DashboardNavigationState(event.i));
    });
  }
}
