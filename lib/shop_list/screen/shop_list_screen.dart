import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_read_state.dart';
import 'package:inventory_management_with_sql/repo/shop_repo/shop_entity.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:inventory_management_with_sql/shop_list/controller/shop_list_bloc.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';
import 'package:starlight_utils/starlight_utils.dart';

void goToDashboardScreen(String shopName) {
  StarlightUtils.pushReplacementNamed(dashboardLoading, arguments: shopName);
}

class ShopListScreen extends StatelessWidget {
  const ShopListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final height = context.height * 0.51;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 80),
            child: FlutterLogo(
              size: 60,
            ),
          ),
          const ShopList(),
          Container(
            width: context.width * 0.87,
            margin: const EdgeInsets.only(left: 2, right: 2, top: 20),
            height: 60,
            child: CustomOutlinedButton(
              onPressed: () {
                StarlightUtils.pushNamed(createNewShop);
              },
              label: "Create New Shop",
            ),
          ),
        ],
      ),
    );
  }
}

class ShopList extends StatelessWidget {
  ///List<Shop>
  const ShopList({super.key});

  @override
  Widget build(BuildContext context) {
    // final ticker = Timer.periodic(const Duration(seconds: 3), (t) async {
    //   await context.read<ShopListBloc>().shop.create(
    //         ShopParam.toCreate(name: "Test ${t.tick}", coverPhoto: "${t.tick}"),
    //       );
    // });
    // Future.delayed(const Duration(seconds: 30), () async {
    //   ticker.cancel();
    //   // await context.read<ShopListBloc>().shop.create(
    //   //       ShopParam.toCreate(name: "Test ", coverPhoto: ""),
    //   //     );
    // });
    return BlocBuilder<ShopListBloc, SqliteReadState<Shop>>(
      builder: (_, state) {
        final shops = state.list;
        final int totalShops = shops.length;
        if (totalShops == 0) {
          return SizedBox(
            width: context.width,
          );
        }
        double shopListHeight = context.height * 0.37;
        if (totalShops == 1) {
          shopListHeight = context.height * 0.098;
        } else if (totalShops == 2) {
          shopListHeight /= 2;
        } else if (totalShops == 3) {
          shopListHeight = context.height * 0.28;
        }
        return SizedBox(
          width: context.width,
          height: shopListHeight,
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (_, i) {
                return Card(
                  elevation: 0.5,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      goToDashboardScreen(shops[i].name);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      height: 70,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: FileImage(
                              File(shops[i].coverPhoto),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            shops[i].name,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: totalShops,
            ),
          ),
        );
      },
    );
  }
}
