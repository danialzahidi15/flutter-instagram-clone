import 'package:flutter/material.dart';
import 'package:flutter_danthocode_instagram_clone/providers/user_model_provider.dart';
import 'package:flutter_danthocode_instagram_clone/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveLayoutScreen extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayoutScreen({
    super.key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  });

  @override
  State<ResponsiveLayoutScreen> createState() => _ResponsiveLayoutScreenState();
}

class _ResponsiveLayoutScreenState extends State<ResponsiveLayoutScreen> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserModelProvider _userModelProvider = Provider.of(context, listen: false);
    return _userModelProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webScreenSize) {
        return widget.webScreenLayout;
      }
      return widget.mobileScreenLayout;
    });
  }
}
