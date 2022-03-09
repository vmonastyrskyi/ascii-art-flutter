import 'package:flutter/widgets.dart';

extension BuiltInPadding on Widget {
  Widget withPadding(double start, double top, double end, double bottom) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(start, top, end, bottom),
      child: this,
    );
  }

  Widget withPaddingAll(double value) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  Widget withPaddingSymmetric(double horizontal, double vertical) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      child: this,
    );
  }
}
