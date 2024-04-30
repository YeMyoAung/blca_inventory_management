import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';

abstract class DashboardEngineEvent {
  const DashboardEngineEvent();
}

class DashboardEngineInitEvent extends DashboardEngineEvent {
  const DashboardEngineInitEvent();
}

class DashboardEngineStreamEvent extends DashboardEngineEvent {
  final Result result;

  const DashboardEngineStreamEvent({required this.result});
}
