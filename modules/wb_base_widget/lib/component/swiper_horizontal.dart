import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwiperHorizontal extends StatefulWidget {
  final int itemCount;
  final Color activeColor;
  final Color color;
  final Widget Function(BuildContext context, int index) widgetBuilder;

  const SwiperHorizontal({
    super.key,
    required this.itemCount,
    required this.widgetBuilder,
    required this.activeColor,
    required this.color,
  });

  @override
  State<SwiperHorizontal> createState() => _SwiperHorizontalState();
}

class _SwiperHorizontalState extends State<SwiperHorizontal> {
  List widgetIndexList = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.itemCount; i++) {
      widgetIndexList.add(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Swiper(
        itemBuilder: widget.widgetBuilder,
        itemCount: widget.itemCount,
        loop: false,
        pagination: SwiperPagination(
            builder: SwiperCustomPagination(builder: (context, config) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widgetIndexList.map((e) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                width: config.activeIndex == e ? 15.w : 5.w,
                height: 5.w,
                decoration: BoxDecoration(
                  color: config.activeIndex == e
                      ? widget.activeColor
                      : widget.color,
                  borderRadius: BorderRadius.circular(4.w),
                ),
              );
            }).toList(),
          );
        })),
        // control: const SwiperControl(),
      ),
    );
  }
}
