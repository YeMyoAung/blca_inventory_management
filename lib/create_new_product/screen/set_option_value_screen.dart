import 'package:flutter/material.dart';
import 'package:inventory_management_with_sql/theme/theme.dart';
import 'package:inventory_management_with_sql/widgest/box/form_box.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';

class SetOptionValueScreen extends StatelessWidget {
  const SetOptionValueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Options"),
        actions: [
          CustomOutlinedButton(
            onPressed: () {
              ///TODO save
            },
            label: "Save",
            icon: Icons.save_outlined,
          )
        ],
      ),
      body: ListView(
        children: [
          FormBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Option Name",
                  style: StandardTheme.getBodyTextStyle(context),
                ),
                TextFormField(),
                Text(
                  "Attribute",
                  style: StandardTheme.getBodyTextStyle(context),
                ),
                TextFormField(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
