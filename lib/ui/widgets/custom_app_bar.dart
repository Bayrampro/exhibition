import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    this.backButton,
    this.actions,
  });

  final Widget? backButton;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      title: Image.asset(
        'assets/images/app_bar_logo.png',
        width: 650,
        height: 110,
      ),
      centerTitle: true,
      backgroundColor: theme.cardColor,
      toolbarHeight: 80,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      leading: backButton,
      actions: actions,
    );
  }
}
