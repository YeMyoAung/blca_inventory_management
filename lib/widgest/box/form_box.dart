import 'package:flutter/cupertino.dart';
import 'package:starlight_utils/starlight_utils.dart';

class FormBox extends StatelessWidget {
  const FormBox({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.alignment,
    required this.child,
  });
  final double? width, height;
  final EdgeInsetsGeometry? padding, margin;
  final AlignmentGeometry? alignment;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
      ),
      alignment: alignment,
      child: child,
    );
  }
}
