abstract class DashboardEngineState {
  const DashboardEngineState();
}

class DashboardEngineInitialState extends DashboardEngineState {
  const DashboardEngineInitialState();
}

class DashboardEngineLoadingState extends DashboardEngineState {
  const DashboardEngineLoadingState();
}

class DashboardEngineReadyState extends DashboardEngineState {
  const DashboardEngineReadyState();
}

class DashboardEngineErrorState extends DashboardEngineState {
  final String message;

  const DashboardEngineErrorState({required this.message});
}
