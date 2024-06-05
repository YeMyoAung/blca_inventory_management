import 'package:flutter/material.dart';
import 'package:inventory_management_with_sql/theme/theme.dart';

class StockValue extends StatelessWidget {
  final String title;
  final double value;
  const StockValue({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: StandardTheme.getBodyTextStyle(context),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$value"),
            const Icon(Icons.arrow_drop_down_outlined)
          ],
        ),
      ],
    );
  }
}

