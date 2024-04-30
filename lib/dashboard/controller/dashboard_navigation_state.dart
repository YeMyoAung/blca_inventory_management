class DashboardNavigationState {
  final int i;
  const DashboardNavigationState(this.i);

  @override
  operator ==(covariant DashboardNavigationState other) {
    return other.i == i;
  }

  @override
  int get hashCode => i;
}
