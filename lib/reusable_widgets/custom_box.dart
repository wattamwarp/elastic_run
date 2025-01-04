import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomBox extends StatelessWidget {
  final Alignment? alignment;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final Widget? child;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final Color? color;
  final Constraints? constraints;

  CustomBox(
      {this.alignment,
        this.padding,
        this.margin,
        this.height,
        this.width,
        this.child,
        this.decoration,
        this.foregroundDecoration,
        this.color,
        this.constraints});

  @override
  Widget build(BuildContext context) {
    Widget? w = child;

    if (decoration != null ||
        foregroundDecoration != null ||
        constraints != null ||
        color != null) {
      w = Container(
        foregroundDecoration: foregroundDecoration,
        decoration: decoration,
        margin: margin,
        constraints: constraints as BoxConstraints?,
        width: width,
        height: height,
        alignment: alignment,
        padding: padding,
        color: color,
        child: w,
      );

      return w;
    }

    if (child == null) {
      return SizedBox(
        height: height,
        width: width,
      );
    }

    if (alignment != null) {
      w = Align(
        alignment: alignment!,
        child: w,
      );
    }

    if (padding != null) {
      w = Padding(
        padding: padding!,
        child: w,
      );
    }

    if (height != null || width != null) {
      w = SizedBox(
        height: height,
        width: width,
        child: w,
      );
    }

    if (margin != null) {
      w = Padding(
        padding: margin!,
        child: w,
      );
    }

    return w!;
  }
}
