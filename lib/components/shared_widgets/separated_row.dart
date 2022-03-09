import 'package:flutter/material.dart';

class SeparatedRow extends StatelessWidget {
  const SeparatedRow({
    Key? key,
    required this.separator,
    this.children = const <Widget>[],
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.verticalDirection = VerticalDirection.down,
    this.mainAxisSize = MainAxisSize.max,
    this.includeOuterTop = true,
    this.includeOuterBottom = true,
    this.includeOuterSeparators = false,
    this.textDirection,
    this.textBaseline,
  }) : super(key: key);

  final Widget separator;
  final List<Widget> children;
  final MainAxisSize mainAxisSize;
  final VerticalDirection verticalDirection;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool includeOuterTop;
  final bool includeOuterBottom;
  final bool includeOuterSeparators;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    if (this.children.isNotEmpty) {
      if (includeOuterSeparators && includeOuterTop) {
        children.add(separator);
      }

      for (int i = 0; i < this.children.length; i++) {
        children.add(this.children[i]);
        if (i != this.children.length - 1) {
          children.add(separator);
        }
      }

      if (includeOuterSeparators && includeOuterBottom) {
        children.add(separator);
      }
    }

    return Row(
      key: key,
      mainAxisSize: mainAxisSize,
      verticalDirection: verticalDirection,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      textBaseline: textBaseline,
      children: children,
    );
  }
}
