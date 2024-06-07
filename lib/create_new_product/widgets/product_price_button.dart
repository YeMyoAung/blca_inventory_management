import 'package:flutter/material.dart';

class ProductPriceButton extends StatelessWidget {
  final Function() onTap;
  final Widget Function()? builder;
  const ProductPriceButton({
    super.key,
    required this.onTap,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: const Icon(
        Icons.monetization_on,
      ),
      title: const Text(
        "Price",
      ),
      trailing: builder?.call() ?? const Text("NA"),
    );
  }
}
