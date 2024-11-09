import 'package:flutter/material.dart';
import 'package:spartapp_test/theme/custom_colors.dart';

class BaseScaffoldWidget extends StatelessWidget {
  const BaseScaffoldWidget({
    super.key,
    this.backgroundColor,
    required this.appbarTitle,
    required this.body,
    this.leading,
    this.padding = EdgeInsets.zero,
  });

  final Color? backgroundColor;
  final String appbarTitle;
  final Widget body;
  final Widget? leading;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? CustomColors.primary,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          centerTitle: true,
          title: Text(
            appbarTitle,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          leading: leading,
        ),
      ),
      body: Padding(
        padding: padding,
        child: body,
      ),
    );
  }
}
