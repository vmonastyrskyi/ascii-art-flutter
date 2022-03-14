import 'package:ascii_camera/app_colors.dart';
import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  const AppBarButton({
    Key? key,
    required this.onPressed,
    required this.iconData,
  }) : super(key: key);

  final VoidCallback onPressed;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.0,
      height: 40.0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Icon(
          iconData,
          color: AppColors.white,
        ),
      ),
    );
  }
}
