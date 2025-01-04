import 'package:elastic_run/color/er_color.dart';
import 'package:elastic_run/extensions/containers.dart';
import 'package:elastic_run/extensions/text.dart';
import 'package:elastic_run/reusable_widgets/custom_box.dart';
import 'package:flutter/material.dart';

class ErWidgets{

  static ElevatedButton filledButton(
      {required String text,
        required VoidCallback onPressed,
        bool isEnabled = true,
        double? height = 45,
        double elevation = 4,
        double radius = 4,
        int fontSize = 14,
        double? width,
        EdgeInsets? padding,
        Color backgroundColor = ErColor.primary,
        Color disabledBackgroundColor = ErColor.disabled,
        Color textColor = ErColor.white,
        Widget? child}) =>
      ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ButtonStyle(
          shape: WidgetStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius))),
          elevation: WidgetStateProperty.all<double>(elevation),
          backgroundColor: WidgetStateProperty.all<Color>(
              isEnabled ? backgroundColor : disabledBackgroundColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (child != null) child,
            2.width,
            CustomBox(
                height: height,
                width: width,
                padding: padding,
                alignment: Alignment.center,
                child:text.boldText(color: textColor,fontSize: 14)),
          ],
        ),
      );
}