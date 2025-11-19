import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wb_base_widget/text_widget/bank_text.dart';

class AbcButton extends StatefulWidget {
  final String title;
  final double width;
  final double height;
  final Color bgColor;
  final Color titleColor;
  final double radius;
  final double fontSize;
  final BoxBorder? border;
  final void Function()? onTap;

  const AbcButton({
    super.key,
    required this.title,
    this.width = 75,
    this.height = 32,
    this.bgColor = Colors.white,
    this.titleColor = Colors.black,
    this.onTap,
    this.border,
    this.radius = 20,
    this.fontSize = 14,
  });

  @override
  State<AbcButton> createState() => _AbcButtonState();
}

class _AbcButtonState extends State<AbcButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: widget.width.w,
        height: widget.height.w,
        decoration: BoxDecoration(
          color: widget.bgColor,
          border: widget.border,
          borderRadius: BorderRadius.all(Radius.circular(widget.radius.w)),
        ),
        alignment: Alignment.center,
        child: BaseText(
          text: widget.title,
          color: widget.titleColor,
          fontSize: widget.fontSize.sp,
        ),
      ),
    );
  }
}
