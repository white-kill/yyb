import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wb_base_widget/component/bottom_sheet_widget.dart';

class SheetBottom {

  static show({
    String title = '请选择',
    Widget? child,
    BuildContext? context,
    bool showTopText = false,
    Function? sureCallBack,
}){
    BaseBottomSheet.sheetContentWidget(
        title: title,
        context: context,
        leftWidget: showTopText?null:Icon(Icons.clear,size: 24.w,color: Color(0xff999999),),
        rightWidget: showTopText?null:Container(width: 24.w,),
        sureCallBack: sureCallBack,
        child:  Container(
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(8.w),
            //   topRight: Radius.circular(8.w),
            // ),
          ),
          child: child,
        ));
  }

}