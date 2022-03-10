import 'package:ascii_camera/app_colors.dart';
import 'package:ascii_camera/extensions/widget.dart';
import 'package:flutter/material.dart';

class OptionsWidget extends StatelessWidget {
  const OptionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _OptionButton(
          onPressed: () {},
          iconSize: 32.0,
          iconData: Icons.grain_rounded,
          size: ButtonSize.small,
        ),
        const SizedBox(width: 32.0),
        _OptionButton(
          onPressed: () {},
          iconSize: 40.0,
          iconData: Icons.camera,
          size: ButtonSize.large,
        ),
        const SizedBox(width: 32.0),
        _OptionButton(
          onPressed: () {},
          iconSize: 32.0,
          iconData: Icons.loop_rounded,
          size: ButtonSize.small,
        ),
      ],
    ).withPaddingAll(24.0);
  }
}

enum ButtonSize { small, large }

class _OptionButton extends StatefulWidget {
  const _OptionButton({
    Key? key,
    required this.onPressed,
    required this.iconData,
    this.iconSize,
    required this.size,
  }) : super(key: key);

  final VoidCallback onPressed;
  final IconData iconData;
  final double? iconSize;
  final ButtonSize size;

  @override
  _OptionButtonState createState() => _OptionButtonState();
}

double _calculateSize(ButtonSize size) {
  switch (size) {
    case ButtonSize.small:
      return 48.0;
    case ButtonSize.large:
      return 64.0;
  }
}

class _OptionButtonState extends State<_OptionButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: _calculateSize(widget.size),
      height: _calculateSize(widget.size),
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.white),
        shape: BoxShape.circle,
      ),
      child: InkWell(
        onTap: widget.onPressed,
        customBorder: const CircleBorder(),
        child: Icon(
          widget.iconData,
          size: widget.iconSize,
          color: AppColors.white,
        ),
      ),
    );
  }
}
