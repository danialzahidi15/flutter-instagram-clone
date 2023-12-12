import 'package:flutter/material.dart';
import 'package:flutter_danthocode_instagram_clone/utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: InstagramColor.blueColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(text),
      ),
    );
  }
}
