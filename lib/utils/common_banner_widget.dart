import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class CommonBannerWidget extends StatelessWidget {
  final List<String> imagePaths;
  final double? height;
  final double? aspectRatio;
  final double viewportFraction;
  final bool autoPlay;
  final bool enableInfiniteScroll;
  final ValueChanged<int>? onPageChanged;
  final BoxFit fit;

  const CommonBannerWidget({
    Key? key,
    required this.imagePaths,
    this.height,
    this.aspectRatio,
    this.viewportFraction = 1.0,
    this.autoPlay = true,
    this.enableInfiniteScroll = true,
    this.onPageChanged,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imagePaths.isEmpty) {
      return SizedBox(height: height ?? 0);
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: height,
        aspectRatio: aspectRatio ?? 16 / 9,
        viewportFraction: viewportFraction,
        initialPage: 0,
        enableInfiniteScroll: enableInfiniteScroll,
        autoPlay: autoPlay,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayCurve: Curves.easeInOut,
        scrollDirection: Axis.horizontal,
        pauseAutoPlayOnTouch: true,
        onPageChanged: (index, reason) {
          onPageChanged?.call(index);
        },
      ),
      items: imagePaths.map((path) {
        return Image.asset(
          path,
          fit: fit,
        );
      }).toList(),
    );
  }
} 