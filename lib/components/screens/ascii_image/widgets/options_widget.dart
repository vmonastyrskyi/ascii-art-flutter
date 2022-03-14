import 'package:ascii_camera/app_colors.dart';
import 'package:ascii_camera/components/screens/ascii_image/bloc/ascii_image/ascii_image_bloc.dart';
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
          onPressed: context.asciiImageBloc.changeImageResolutionPreset,
          iconData: Icons.grain_rounded,
          iconSize: 32.0,
          size: ButtonSize.small,
        ),
        const SizedBox(width: 32.0),
        _OptionButton(
          onPressed: context.asciiImageBloc.toggleImageProcessing,
          iconData: Icons.camera,
          iconSize: 40.0,
          size: ButtonSize.large,
        ),
        const SizedBox(width: 32.0),
        _OptionButton(
          onPressed: context.asciiImageBloc.swapCamera,
          iconSize: 32.0,
          iconData: Icons.loop_rounded,
          size: ButtonSize.small,
        ),
      ],
    ).withPaddingAll(24.0);
  }
}

enum ButtonSize { small, large }

class _OptionButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      width: _calculateSize(),
      height: _calculateSize(),
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.white),
        shape: BoxShape.circle,
      ),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Icon(
          iconData,
          size: iconSize,
          color: AppColors.white,
        ),
      ),
    );
  }

  double _calculateSize() {
    switch (size) {
      case ButtonSize.small:
        return 48.0;
      case ButtonSize.large:
        return 64.0;
    }
  }
}
