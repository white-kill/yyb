import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WbCustomLoadingWidget extends StatefulWidget {
  final ImageProvider image;
  const WbCustomLoadingWidget({super.key, required this.image});

  @override
  State<WbCustomLoadingWidget> createState() => _WbCustomLoadingWidgetState();
}

class _WbCustomLoadingWidgetState extends State<WbCustomLoadingWidget>
    with TickerProviderStateMixin{

  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLoadingThree();
  }
  Widget _buildLoadingThree() {
    return Center(
      child: Container(
        height: 105.w,
        width: 105.w,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          RotationTransition(
            alignment: Alignment.center,
            turns: _controller,
            child: Image(
              image: widget.image,
              height: 45,
              width: 45,
            ),
          ),
        ]),
      ),
    );
  }
}
