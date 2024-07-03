import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/utils/dialog.dart';
import 'package:inventory_management_with_sql/dashboard_loader/controller/dashboard_engine_bloc.dart';
import 'package:inventory_management_with_sql/dashboard_loader/controller/dashboard_engine_state.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:starlight_utils/starlight_utils.dart';

class DashboardLoadingScreen extends StatelessWidget {
  const DashboardLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardEngineBloc, DashboardEngineState>(
      listenWhen: (_, current) =>
          current is DashboardEngineErrorState ||
          current is DashboardEngineReadyState,
      listener: (_, state) async {
        if (state is DashboardEngineReadyState) {
          /// go to dashboard screen
          StarlightUtils.pushNamed(
            dashboard,
            arguments: context.read<DashboardEngineBloc>(),
          );
          return;
        }
        state as DashboardEngineErrorState;
        await dialog("Failed to load dashboard", state.message);
        StarlightUtils.pushReplacementNamed(shopList);
      },
      child: Scaffold(
        body: SizedBox(
          width: context.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.inkDrop(
                color: Colors.white,
                size: 50,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 40, bottom: 20),
                child: Text(
                  "This may take a few minute...",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
