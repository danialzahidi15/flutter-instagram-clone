import 'package:flutter/material.dart';
import 'package:flutter_danthocode_instagram_clone/utils/colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: InstagramColor.mobileBackgroundColor,
        title: const Text('Notifications'),
        centerTitle: false,
      ),
    );
  }
}
