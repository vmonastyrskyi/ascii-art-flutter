import 'package:ascii_camera/app_colors.dart';
import 'package:ascii_camera/components/shared_widgets/separated_row.dart';
import 'package:ascii_camera/extensions/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ASCIIAppBar extends StatelessWidget with PreferredSizeWidget {
  ASCIIAppBar({
    Key? key,
    required this.title,
    this.leading = const [],
    this.actions = const [],
  }) : super(key: key);

  final String title;
  final List<Widget> leading;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(72.0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildLeading(),
        _buildTitle(),
        _buildActions(),
      ],
    ).withPaddingSymmetric(16.0, 0.0);
  }

  Widget _buildLeading() {
    return Align(
      alignment: Alignment.centerLeft,
      child: SeparatedRow(
        mainAxisSize: MainAxisSize.min,
        separator: const SizedBox(width: 8.0),
        children: leading,
      ),
    );
  }

  Widget _buildTitle() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Align(
      alignment: Alignment.centerRight,
      child: SeparatedRow(
        mainAxisSize: MainAxisSize.min,
        separator: const SizedBox(width: 8.0),
        children: actions,
      ),
    );
  }
}
