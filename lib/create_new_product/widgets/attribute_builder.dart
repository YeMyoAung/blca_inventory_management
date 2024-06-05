import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

class VariantAttributeBuilder extends StatelessWidget {
  final List attributes;
  const VariantAttributeBuilder({
    super.key,
    required this.attributes,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: context.width,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: attributes.length,
        itemBuilder: (_, i) {
          return Container(
            margin: const EdgeInsets.only(right: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(
              attributes[i]['name'].toString(),
            ),
          );
        },
      ),
    );
  }
}
