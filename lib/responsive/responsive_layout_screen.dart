import "package:flutter/material.dart";
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/utils/dimensions.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();

    addData();
  }

  addData() async {
    // if listen is not false, then it will constantly listen to changes on the user value
    // Just need to call refresh user once
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);

    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // constraints holds the screen size
        if (constraints.maxWidth > webScreenSize) {
          // Web screen
          return widget.webScreenLayout;
        } else {
          // Mobile screen
          return widget.mobileScreenLayout;
        }
      },
    );
  }
}
