import 'package:flutter/material.dart';
import 'package:flutter_ui_food_delivery_app/utils/colors.dart';
import 'package:flutter_ui_food_delivery_app/utils/metrics.dart';

class Base extends StatelessWidget {
  const Base({
    Key? key,
    required this.child,
    this.bgColor,
  }) : super(key: key);
  final Color? bgColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: w(context),
        height: h(context),
        color: bgColor ?? bgPrimary(context),
        child: child,
      ),
    );
  }
}
