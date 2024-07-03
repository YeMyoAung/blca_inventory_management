import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/container.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/core/db/utils/sqlite_table_const.dart';
import 'package:inventory_management_with_sql/dashboard/controller/dashboard_navigation_bloc.dart';
import 'package:inventory_management_with_sql/dashboard/controller/dashboard_navigation_event.dart';
import 'package:inventory_management_with_sql/inventory/view/inventory_view.dart';
import 'package:inventory_management_with_sql/repo/inventory_repo/inventory_entity.dart';
import 'package:inventory_management_with_sql/repo/inventory_repo/inventory_repo.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:inventory_management_with_sql/theme/theme.dart';
import 'package:inventory_management_with_sql/use_case/sqlite_create_new_invenoty_log_usecase.dart';
import 'package:inventory_management_with_sql/use_case/sqlite_inventory_list_usecase.dart';
import 'package:inventory_management_with_sql/widgest/box/form_box.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';
import 'package:starlight_utils/starlight_utils.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Dashboard"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CustomOutlinedButton(
              onPressed: () {
                StarlightUtils.pushNamedAndRemoveUntil(shopList, (p0) => false);
              },
              label: "Logout",
              icon: Icons.logout,
            ),
          )
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InventoryOverviewReport(),
            TotalCount(),
            TodayReport(),
            TodayInventoryReport(),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}

class TodayReport extends StatelessWidget {
  const TodayReport({super.key});

  @override
  Widget build(BuildContext context) {
    return FormBox(
      margin: const EdgeInsets.only(top: 10),
      width: context.width,
      child: Text(
        "Today Reports",
        style: context.theme.appBarTheme.titleTextStyle,
      ),
    );
  }
}

class TotalCount extends StatelessWidget {
  const TotalCount({super.key});

  @override
  Widget build(BuildContext context) {
    final inventoryRepo = container.get<SqliteInventoryRepo>();
    final style = context.theme.appBarTheme.titleTextStyle;
    final dashboardNavigationBloc = context.read<DashboardNavigationBloc>();
    return FormBox(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: SizedBox(
        height: 80,
        child: FutureBuilder(
          future: inventoryRepo.database.rawQuery("""
              SELECT (select count(id) from $categoryTb) as Categories,
                (select count(id) from $productTb) as Products,
                (select count(id) from $variantTb) as Variants,
                (select count(id) from $inventoryTb) as Reports
              """),
          builder: (_, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            final data = snap.data ?? <Map>[];
            if (data.isEmpty) {
              return const Text("No Data");
            }
            final counts = data.first;
            final keys = counts.keys;
            return ListView.separated(
              separatorBuilder: (context, index) => VerticalDivider(
                color: context.theme.primaryColor,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: keys.length,
              itemBuilder: (_, i) {
                final key = keys.elementAt(i);

                return InkWell(
                  onTap: () {
                    int id = 2;
                    if (key == "Categories") {
                      id = 1;
                    } else if (key == "Reports") {
                      id = 3;
                    }

                    dashboardNavigationBloc.add(DashboardNavigationEvent(id));
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 15,
                    ),
                    width: 90,
                    child: Column(
                      children: [
                        Text(
                          "$key",
                          style: style?.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${counts[key]}",
                          style: style?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class InventoryOverviewReport extends StatelessWidget {
  const InventoryOverviewReport({
    super.key,
  });

  static const String _query =
      "select count($inventoryTb.id) as total from $inventoryTb where $inventoryTb.reason=?";

  @override
  Widget build(BuildContext context) {
    // (select count(id) from $inventoryTb) as total,
    final inventoryRepo = container.get<SqliteInventoryRepo>();
    return FormBox(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Overview Inventory Report",
            style: context.theme.appBarTheme.titleTextStyle,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: 230,
            child: Row(
              children: [
                SizedBox(
                  height: 220,
                  width: context.width * 0.7,
                  child: FutureBuilder(
                    future: inventoryRepo.database.rawQuery("""
              SELECT ($_query) as $PURCHASE,($_query) as $SELL,($_query) as $DAMAGE,($_query) as $LOST
                        """, [PURCHASE, SELL, DAMAGE, LOST]),
                    builder: (_, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      final data = snap.data ?? <Map>[];
                      if (data.isEmpty) {
                        return const Text("No Data");
                      }
                      final dataSet = data.first;
                      //Map{purchase:0,sell:0,damage:0,lost:0}
                      if (dataSet.values.fold<double>(0,
                              (previousValue, element) {
                            return previousValue +
                                (double.tryParse(element.toString()) ?? 0);
                          }) ==
                          0) {
                        return const Center(child: Text("No Data"));
                      }
                      return OverviewPieChart(dataSet: data.first);
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: Reasons.keys
                          .map(
                            (e) => Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  color: getColor(e),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  e,
                                  style:
                                      StandardTheme.getBodyTextStyle(context),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OverviewPieChart extends StatefulWidget {
  final Map dataSet;
  const OverviewPieChart({super.key, required this.dataSet});

  @override
  State<OverviewPieChart> createState() => _OverviewPieChartState();
}

class _OverviewPieChartState extends State<OverviewPieChart> {
  String touchTitle = "";

  @override
  Widget build(BuildContext context) {
    return LineChart(
      // mainData(),
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: const FlDotData(
              show: false,
            ),
            spots: List.generate(
              widget.dataSet.keys.length,
              (index) {
                return FlSpot(
                  index + 1,
                  double.parse(widget
                      .dataSet[widget.dataSet.keys.elementAt(index)]
                      .toString()),
                );
              },
            ),
          ),
        ],
      ),
    );

    return BarChart(
      BarChartData(
        gridData: const FlGridData(
          show: false,
        ),
        barGroups: List.generate(
          widget.dataSet.keys.length,
          (index) {
            return BarChartGroupData(
              barRods: [
                BarChartRodData(
                    toY: double.parse(widget
                        .dataSet[widget.dataSet.keys.elementAt(index)]
                        .toString()),
                    color: getColor(widget.dataSet.keys.elementAt(index))),
              ],
              x: index + 1,
            );
          },
        ),
      ),
    );

    logger.i("_OverviewPieChartState ${widget.dataSet}");
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchTitle = "";
                return;
              }
              touchTitle =
                  pieTouchResponse.touchedSection!.touchedSection?.title ?? "";
            });
          },
        ),
        sectionsSpace: 0,
        centerSpaceRadius: 30,
        sections: widget.dataSet.keys.map(
          (e) {
            final isTouch = e == touchTitle;
            return PieChartSectionData(
              radius: isTouch ? 75 : 70,
              title: e,
              showTitle: isTouch,
              badgePositionPercentageOffset: isTouch ? 1.2 : 0.5,
              titleStyle: StandardTheme.getBodyTextStyle(context).copyWith(
                color: Colors.white,
              ),
              badgeWidget: Text(
                widget.dataSet[e].toString(),
                style: StandardTheme.getBodyTextStyle(context).copyWith(
                  color: isTouch ? Colors.black : Colors.white,
                ),
              ),
              value: double.tryParse(widget.dataSet[e].toString()),
              color: getColor(e),
            );
          },
        ).toList(),
      ),
    );
  }
}

class TodayInventoryReport extends StatelessWidget {
  const TodayInventoryReport({super.key});

  Future<List<Inventory>> getData(SqliteInventoryListUseCase usecase,
      DateTime today, DateTime tomorrow) async {
    final value = await usecase.repo.database.rawQuery("""
    select * from $inventoryTb where $inventoryTb.created_at >= ? and $inventoryTb.created_at < ?
    """, [today.toString(), tomorrow.toString()]);
    final result = value.map(Inventory.fromJson).toList();
    for (final e in result) {
      final name = await usecase.getVariantName(e.variantID);
      e.variantName = name;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final inventoryRepo = container.get<SqliteInventoryRepo>();
    final usecase = SqliteInventoryListUseCase(repo: inventoryRepo);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day);
    return FutureBuilder(
      future: getData(usecase, today, tomorrow),
      builder: (_, snap) {
        return Column(
          children: (snap.data ?? <Inventory>[])
              .map((e) => Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InventoryItem(inventory: e)))
              .toList(),
        );
      },
    );
  }
}
