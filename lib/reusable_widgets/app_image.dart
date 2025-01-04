
import 'dart:io';

import 'package:elastic_run/generated/assets.dart';
import 'package:elastic_run/reusable_widgets/custom_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class AppImage extends StatelessWidget {
  final String imageSource;
  final String fallbackImageSource;
  final double? height;
  final double? width;
  final double? fallbackHeight;
  final double? fallbackWidth;
  final double scale;
  final BoxFit? fit;
  final Color? color;

 const AppImage(this.imageSource,
      {super.key,
        this.height,
        this.width,
        this.fit,
        this.color,
        this.scale = 1,
        this.fallbackImageSource = "",
        this.fallbackHeight,
        this.fallbackWidth});

  @override
  Widget build(BuildContext context) {
    String imageSource =
    this.imageSource.isNotEmpty ? this.imageSource : fallbackImageSource;
    double? height = this.imageSource.isNotEmpty ? this.height : fallbackHeight;
    double? width = this.imageSource.isNotEmpty ? this.width : fallbackWidth;
    if (imageSource.isEmpty) return  const SizedBox.shrink();
    return CustomBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (_isLottie(imageSource))
            Lottie.asset(imageSource,
                animate: true,
                repeat: true,
                fit: fit,
                width: width,
                height: height)
          else if (_isPath(imageSource))
            Image.file(File(imageSource),
                height: height,
                width: width,
                fit: fit,
                color: color,
                scale: scale)
          else if (_isUrl(imageSource)) ...[
              if (_isSvg(imageSource))
                SvgPicture.network(
                  imageSource,
                  height: height,
                  width: width,
                  fit: fit ?? BoxFit.contain,
                  color: color,
                )
              else
                Image.network(
                  imageSource,
                  height: height,
                  width: width,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      Assets.imagesCars,
                      height: height,
                      width: width,
                      fit: fit,
                      color: color,
                      scale: scale,
                    );
                  },
                  fit: fit,
                  color: color,
                  scale: scale,
                ),
            ] else if (_isAsset(imageSource)) ...[
              if (_isSvg(imageSource))
                SvgPicture.asset(
                  imageSource,
                  height: height,
                  width: width,
                  fit: fit ?? BoxFit.contain,
                  color: color,
                )
              else
                Image.asset(
                  imageSource,
                  height: height,
                  width: width,
                  fit: fit,
                  color: color,
                  scale: scale,
                ),
            ],
        ],
      ),
    );
  }

  _isPath(String imageSource) {
    return imageSource.contains("storage/") ||
        imageSource.contains("emulated/") ||
        imageSource.contains("Android/") ||
        imageSource.contains("/data/user/0/");
  }

  _isUrl(String imageSource) {
    return imageSource.contains("https://");
  }

  _isAsset(String imageSource) {
    return imageSource.contains("assets/");
  }

  _isSvg(String imageSource) {
    return imageSource.contains(".svg");
  }

  _isLottie(String imageSource) {
    return imageSource.contains('.json');
  }
}
