import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/dashboard/controller/dashboard_engine_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<DashboardEngineBloc>().stream.listen((event) {
      print(event);
    });
    return const Placeholder();
  }
}
