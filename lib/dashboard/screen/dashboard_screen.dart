import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/cateogry/view/category_list_view.dart';
import 'package:inventory_management_with_sql/dashboard/controller/dashboard_navigation_bloc.dart';
import 'package:inventory_management_with_sql/dashboard/controller/dashboard_navigation_event.dart';
import 'package:inventory_management_with_sql/dashboard/controller/dashboard_navigation_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardNavigationBloc = context.read<DashboardNavigationBloc>();
    return Scaffold(
      body: BlocBuilder<DashboardNavigationBloc, DashboardNavigationState>(
          builder: (_, state) {
        return [
          const CategoryListView(),
          const CategoryListView(),
          const CategoryListView(),
          const CategoryListView(),
        ][state.i];
      }),
      bottomNavigationBar:
          BlocBuilder<DashboardNavigationBloc, DashboardNavigationState>(
        builder: (_, state) => BottomNavigationBar(
          currentIndex: state.i,
          onTap: (value) {
            dashboardNavigationBloc.add(DashboardNavigationEvent(value));
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard_outlined,
              ),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              label: "Category",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box_outlined,
              ),
              label: "Product",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_outlined),
              label: "Inventory",
            ),
          ],
        ),
      ),
    );
  }
}
