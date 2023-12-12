import 'package:flutter/material.dart';
import 'package:flutter_danthocode_instagram_clone/utils/colors.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: InstagramColor.primaryColor,
      ),
    );
  }
}

class LoaderPage extends StatelessWidget {
  const LoaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Loader();
  }
}