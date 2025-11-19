import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yyb/common/sheet_widget/picker_widget.dart';
import 'package:wb_base_widget/component/bottom_sheet_widget.dart';

class PingPicker {

  static Future showNewTime({
    String title = '选择时间',
     DateTime? initialDateTime,
     ValueChanged<DateTime>? onDateTimeChanged,
     DateTimePickerNotifier? dateTimePickerNotifier,
    BuildContext? context,
    Function? sureCallBack,
    bool showDay = true,
    int lastYear = 4
  }) async {
    await BaseBottomSheet.sheetContentWidget(
        title: title,
        context: context,
        sureCallBack: sureCallBack,
        child:  Container(
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(8.w),
            //   topRight: Radius.circular(8.w),
            // ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 200.w,
                child: DateTimePicker(
                  dateTimePickerNotifier: dateTimePickerNotifier,
                  onDateTimeChanged: onDateTimeChanged,
                  initialDateTime: initialDateTime,
                  showDay: showDay,
                  lastYear: lastYear,
                ),
              )
            ],
          ),
        ));
  }

}