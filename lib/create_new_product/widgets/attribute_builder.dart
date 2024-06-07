import 'package:flutter/material.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_product_option_attribute_info.dart';
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
          return AttributeCard(
            name: attributes[i]['name'].toString(),
          );
        },
      ),
    );
  }
}
