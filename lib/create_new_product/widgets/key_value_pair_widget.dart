import 'package:flutter/material.dart';

class KeyValuePairWidget extends StatelessWidget {
  const KeyValuePairWidget({
    super.key,
    required this.leading,
    required this.trailing,
  });
  final Widget leading, trailing;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: leading),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: trailing,
        )),
      ],
    );
  }
}
